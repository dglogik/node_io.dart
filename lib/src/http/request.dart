part of node_io.http;

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