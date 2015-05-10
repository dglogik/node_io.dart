part of node_io.http;

class _HttpClientRequest implements HttpClientRequest {

  final JsObject _jsReq;
  final Future<HttpClientResponse> done;

  final HttpHeaders headers;
  final Uri uri;

  final String method;

  final Encoding encoding;

  _HttpClientRequest(this._jsReq, this.done, this.uri, this.method, this.headers, [this.encoding = UTF8]);

  HttpConnectionInfo get connectionInfo {
    return null;
  }

  void addError(error, [StackTrace stackTrace]) {

  }

  Future close() {
    _jsReq.callMethod("end");
    return done;
  }

  void add(List<int> data) {
    _jsReq.callMethod("write", [listToBuf(data)]);
  }

  Future addStream(Stream<List<int>> stream) {
    return null;
  }

  void write(Object obj) {
    add(this.encoding.encode(obj.toString()));
  }

  void writeAll(Iterable objects, [String separator]) {
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

  void writeln([Object obj]) {

  }

  List<Cookie> get cookies {
    return null;
  }

  bool get bufferOutput {
    return null;
  }

  bool get followRedirects {
    return null;
  }

  bool get persistentConnection {
    return null;
  }

  int get contentLength {
    return null;
  }

  int get maxRedirects {
    return null;
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