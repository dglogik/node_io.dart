part of node_io.http;

class _HttpClientRequest implements HttpClientRequest {
  final Completer _done = new Completer<HttpClientResponse>.sync();

  final HttpHeaders headers;
  final Uri uri;

  final String method;

  List<dynamic> _buffer = <dynamic>[];

  Encoding encoding;

  bool bufferOutput;
  bool followRedirects;
  bool persistentConnection;

  int contentLength = -1;
  int maxRedirects;

  Future get done => _done.future;

  List<Cookie> get cookies {
    return null;
  }

  _HttpClientRequest(this.uri, this.method, this.headers, [this.encoding = UTF8]);

  HttpConnectionInfo get connectionInfo {
    return null;
  }

  void addError(error, [StackTrace stackTrace]) {
    // TODO
  }

  Future close() {
    headers.add(HttpHeaders.CONTENT_LENGTH, contentLength);

    // TODO?
    var _headers = {};
    headers.forEach((name, values) => _headers[name] = headers.value(name));

    // http
    var req = (uri.scheme == "https" ? _https : _http).callMethod("request", [new JsObject.jsify({
      "hostname": uri.host,
      "port": uri.port,
      "path": uri.path,
      "method": method,
      "headers": _headers
    }), (res) {
      _done.complete(new _HttpClientResponse(res, method));
    }]);

    for (var data in _buffer) {
      req.callMethod("write", [data]);
    }

    req.callMethod("end");
    return done;
  }

  void add(List<int> data) {
    _buffer.add(listToBuf(data));
    if(contentLength < 0)
      contentLength = 0;
    contentLength += data.length;
  }

  Future addStream(Stream<List<int>> stream) {
    return null;
  }

  void write(Object obj) {
    add(encoding.encode(obj.toString()));
  }

  void writeAll(Iterable objects, [String separator = ""]) {
    var index = 0;
    for(var obj in objects) {
      write(obj);
      if(separator != null && index != (objects.length - 1))
        write(separator);
    }
    index++;
  }

  void writeCharCode(int charCode) {
    write(new String.fromCharCode(charCode));
  }

  Future flush() {
    return null;
  }

  void writeln([Object obj = ""]) {
  }
}

abstract class HttpClientRequest implements IOSink {

  HttpHeaders get headers;
  HttpConnectionInfo get connectionInfo;

  List<Cookie> get cookies;

  Future<HttpClientResponse> get done;

  String get method;
  Uri get uri;

  Encoding encoding;

  bool bufferOutput = true;
  bool followRedirects = true;
  bool persistentConnection = true;

  int contentLength;
  int maxRedirects;
}
