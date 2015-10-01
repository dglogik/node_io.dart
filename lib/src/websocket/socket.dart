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

  static Future<WebSocket> connect(String url,
      {Iterable<String> protocols, Map<String, dynamic> headers}) {
    return _WebSocket.connect(url, protocols, headers);
  }
}

class _WebSocket extends Stream implements WebSocket {
  final StreamController<List> _controller =
      new StreamController<List>(sync: true);

  final JsObject _socket;

  Completer _done = new Completer();

  int _closeCode;
  String _closeReason;

  Duration pingInterval;

  Future get done => _done.future;

  String get protocol => _socket["protocol"];
  String get extensions => context["global"]["Object"]
      .callMethod("keys", [_socket["extensions"]])
      .join("; ");

  String get closeReason => _closeReason;
  int get closeCode => _closeCode;

  int get readyState => _socket["readyState"];

  _WebSocket(this._socket) {
    _done.future.then((_) => _controller.close());

    onData(data, flags) {
      if (!(data is String)) {
        data = bufToList(data);
      }
      _controller.add(data);
    }

    _socket.callMethod("on", ["message", onData]);

    onError(error) {
      _controller.addError(new WebSocketException(error.callMethod("toString")));
    }

    _socket.callMethod("on", ["error", onError]);

    onDone(_, _a) {
      if(!_done.isCompleted)
        _done.complete();
    }

    _socket.callMethod("on", ["close", onDone]);

    _done.future.then((_) {
      // _socket.callMethod("removeListener", ["data", onData]);
      _socket.callMethod("removeListener", ["error", onError]);
    });
  }

  static Future<WebSocket> connect(String url,
      [Iterable<String> protocols = const <dynamic>[],
      Map<String, dynamic> headers = const {}]) {
    var completer = new Completer.sync();
    var socket =
        new JsObject(_ws, [url, new JsObject.jsify({"headers": headers})]);

    bool hasOpened = false;

    socket.callMethod("on", [
      "open",
      () {
        hasOpened = true;
        completer.complete(new _WebSocket(socket));
      }
    ]);

    socket.callMethod("on", [
      "error",
      (err) {
        if(hasOpened)
          return;
        completer.completeError(new WebSocketException(err.callMethod("toString")));
      }
    ]);

    return completer.future;
  }

  void add(data) {
    if (!(data is String)) data = listToBuf(data);
    _socket.callMethod("send", [data]);
  }

  StreamSubscription listen(void onData(message),
      {Function onError, void onDone(), bool cancelOnError}) {
    return _controller.stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
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

  Future close([int code = 1000, String reason]) {
    _socket.callMethod("close", [code, reason]);
    _closeReason = reason;
    _closeCode = code;
    _done.complete();
    return null;
  }

  void addError(error, [StackTrace stackTrace]) {
    _controller.addError(error, stackTrace);
  }
}
