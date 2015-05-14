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

class _HttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
  final StreamController<List> _controller = new StreamController<List>(sync: true);

  final JsObject _res;

  final String _reqMethod;

  final List<RedirectInfo> redirects;
  final HttpHeaders headers;

  Future<List> get first =>  _controller.stream.first;
  Future<List> get last => _controller.stream.last;

  String get reasonPhrase => _res["statusMessage"];

  int get statusCode => _res["statusCode"];
  int get contentLength => headers.contentLength;

  _HttpClientResponse(JsObject res, this._reqMethod) :
      _res = res,
      redirects = <RedirectInfo>[],
      headers = new _HttpHeaders(res["httpVersion"]) {

    JsObject obj = _res["headers"];

    List<String> keys = context["global"]["Object"].callMethod("keys", [obj]);
    for (var key in keys) {
      headers.add(key, obj[key]);
    }

    onData(buf) {
      _controller.add(bufToList(buf));
    }
    _res.callMethod("on", ["data", onData]);

    onEnd() {
      _controller.close();
      _res.callMethod("removeListener", ["data", onData]);
      _res.callMethod("removeListener", ["end", onEnd]);
    }
    _res.callMethod("on", ["end", onEnd]);
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

  StreamSubscription<List> listen(void onData(List event), {Function onError, void onDone(), bool cancelOnError : false}) {
    return _controller.stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
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
