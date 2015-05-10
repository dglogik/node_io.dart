part of node_io.http;

abstract class RedirectInfo {
  Uri get location;
  String get method;
  int get statusCode;
}

abstract class HttpClientResponse implements Stream<List<int>> {

  int get statusCode;
  int get contentLength;

  String get reasonPhrase;

  bool get persistentConnection;
  bool get isRedirect;

  List<RedirectInfo> get redirects;

  HttpHeaders get headers;

  List<Cookie> get cookies;

  X509Certificate get certificate;

  HttpConnectionInfo get connectionInfo;

  Future<HttpClientResponse> redirect([String method, Uri url, bool followLoops]);

  Future<Socket> detachSocket();
}

class _HttpClientResponse extends Stream implements HttpClientResponse {

  List<List> _data = <List>[];

  Completer<List> _first = new Completer<List>();
  Completer<List> _last = new Completer<List>();

  final JsObject _jsRes;

  final String _reqMethod;

  final List<RedirectInfo> redirects;
  final HttpHeaders headers;

  Future<List> get first => _first.future;
  Future<List> get last => _last.future;

  String get reasonPhrase => _jsRes["statusMessage"];

  int get statusCode => _jsRes["statusCode"];
  int get contentLength => headers.contentLength;

  _HttpClientResponse(JsObject jsRes, this._reqMethod) :
      _jsRes = jsRes,
      redirects = <RedirectInfo>[],
      headers = new _HttpHeaders(jsRes["httpVersion"]) {

    Map<String, dynamic> map = JSON.decode(context["JSON"].callMethod('stringify', _jsRes["headers"]));
    map.forEach((key, value) {
      headers.add(key, value);
    });

    onData(buf) {
      _data.add(bufToList(buf));
      if(_data.length == 1)
        _first.complete(_data[0]);
      _jsRes.callMethod("removeListener", ["data", onData]);
    }
    _jsRes.callMethod("on", ["data", onData]);

    onEnd() {
      _last.complete(_data.last);
      _jsRes.callMethod("removeListener", ["end", onEnd]);
    }
    _jsRes.callMethod("on", ["end", onEnd]);
  }

  bool get isRedirect {
    if (_reqMethod == "GET" || _reqMethod == "HEAD") {
      return statusCode == HttpStatus.MOVED_PERMANENTLY ||
      statusCode == HttpStatus.FOUND ||
      statusCode == HttpStatus.SEE_OTHER ||
      statusCode == HttpStatus.TEMPORARY_REDIRECT;
    } else if (_reqMethod == "POST") {
      return statusCode == HttpStatus.SEE_OTHER;
    }
    return false;
  }

  StreamSubscription<List> listen(void onData(List event), {Function onError, void onDone(), bool cancelOnError}) {
    return null;
  }

  bool get persistentConnection {
    return null;
  }

  List<Cookie> get cookies {
    return null;
  }

  X509Certificate get certificate {
    return null;
  }

  HttpConnectionInfo get connectionInfo {
    return null;
  }

  Future<HttpClientResponse> redirect([String method, Uri url, bool followLoops]) {
    return null;
  }

  Future<Socket> detachSocket() {
    return null;
  }

}