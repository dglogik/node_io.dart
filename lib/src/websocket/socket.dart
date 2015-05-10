part of node_io.websocket;

abstract class WebSocket implements StreamSink, Stream {

  static const int CONNECTING = 0;
  static const int OPEN = 1;
  static const int CLOSING = 2;
  static const int CLOSED = 3;

  Duration pingInterval;

  String get closeReason;
  String get extensions;
  String get protocol;

  int get closeCode;
  int get readyState;

  void add(data);

  Future addStream(Stream stream);

  Future close([int code, String reason]);

  static Future<WebSocket> connect(String url, {Iterable<String> protocols, Map<String, dynamic> headers}) {
    return _WebSocket.connect(url, protocols, headers);
  }
}

class _WebSocketSub implements StreamSubscription {

  JsObject _socket;

  final Completer _cancel = new Completer();
  final List _buffer = <dynamic>[];

  Future _done;

  Function _onData;
  Function _onError;
  Function _onDone;

  bool _cancelOnError;
  bool _isPaused = false;

  bool get isPaused => _isPaused;

  _WebSocketSub(this._socket, this._done, [this._onData, this._onError, this._onDone, this._cancelOnError = false]) {
    this._done.then((_) => this.cancel());

    onData(data, _) {
      if(!(data is String)) {
        data = bufToList(data);
      }
      if(_isPaused) {
        _buffer.add(data);
        return;
      }
      _onData(data);
    }

    _socket.callMethod("on", ["data", onData]);

    onError(error) {
      _onError(error);
      if(_cancelOnError)
        this.cancel();
    }

    _socket.callMethod("on", ["error", onError]);

    _cancel.future.then((_) {
      _socket.callMethod("removeListener", ["data", onData]);
      _socket.callMethod("removeListener", ["error", onError]);
      _socket = null;
      _done = null;
    });
  }

  void onData(void handleData(data)) {
    _onData = handleData;
  }

  void onError(Function handleError) {
    _onError = handleError;
  }

  void onDone(void handleDone()) {
    _onDone = handleDone;
  }

  void pause([Future resumeSignal]) {
    if(_isPaused) return;
    _isPaused = true;

    if(resumeSignal != null)
      resumeSignal.then((_) => resume());
  }

  Future cancel() {
    _cancel.complete();
    return null;
  }

  void resume() {
    if(!_isPaused) return;
    _isPaused = false;

    if(_buffer.length > 0) {
      for(var event in _buffer)
        _onData(event);
      _buffer.removeRange(0, _buffer.length - 1);
    }
  }

  Future asFuture([futureValue]) {
    var completer = new Completer();

    _cancel.future.then((_) => completer.complete());
    // TODO: error

    return completer.future;
  }
}

class _WebSocket extends Stream implements WebSocket {

  final JsObject _socket;

  Completer _done = new Completer();

  int _closeCode;
  String _closeReason;

  Duration pingInterval;

  Future get done => _done.future;

  int get closeCode => _closeCode;
  String get closeReason => _closeReason;

  String get protocol => _socket["protocol"];

  String get extensions => context["Object"].callMethod("keys", [_socket["extensions"]]).join("; ");

  int get readyState => _socket["readyState"];

  _WebSocket(this._socket);

  static Future<WebSocket> connect(String url, Iterable<String> protocols, Map<String, dynamic> headers) {
    var completer = new Completer();
    var socket = new JsObject(_ws, [url, protocols, new JsObject.jsify({
      "headers": new JsObject.jsify(headers)
    })]);

    socket.callMethod("on", ["open", () {
      completer.complete(new _WebSocket(socket));
    }]);

    return completer.future;
  }

  void add(data) {
    if(!(data is String))
      data = listToBuf(data);
    _socket.callMethod("send", [data]);
  }

  StreamSubscription listen(void onData(message), {Function onError, void onDone(), bool cancelOnError}) {
    return new _WebSocketSub(_socket, done, onData, onError, onDone, cancelOnError);
  }

  Future addStream(Stream stream) {
    var completer = new Completer();

    _onDone([error, StackTrace stackTrace]) {
      if (error != null) {
        completer.completeError(error, stackTrace);
      } else {
        completer.complete(this);
      }
    }

    var subscription = stream.listen((data) {
      this.add(data);
    }, onDone: _onDone, onError: _onDone, cancelOnError: true);

    return completer.future;
  }

  Future close([int code, String reason]) {
    _socket.callMethod("close", [code, reason]);
    _closeReason = reason;
    _closeCode = code;
    _done.complete();
    return null;
  }

  void addError(errorEvent, [StackTrace stackTrace]) {
    // TODO
  }

}