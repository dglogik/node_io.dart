part of node_io.http;

class HttpClientResponse implements Stream<List<int>> {

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
  
  Future<HttpClientResponse> redirect([String method, Uri url, bool followLoops]) {

  }

  Future<Socket> detachSocket() {

  }

}