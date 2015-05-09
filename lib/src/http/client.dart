part of node_io.http;

class HttpClient {
  static const int DEFAULT_HTTP_PORT = 80;
  static const int DEFAULT_HTTPS_PORT = 443;

  HttpClient();

  static String findProxyFromEnvironment(Uri url, {Map<String, String> environment}) {

  }

  void addCredentials(Uri url, String realm, HttpClientCredentials credentials) {

  }

  void addProxyCredentials(String host, int port, String realm, HttpClientCredentials credentials) {

  }

  void close({bool force: false}) {

  }

  Future<HttpClientRequest> delete(String host, int port, String path) {
    return null;
  }

  Future<HttpClientRequest> deleteUrl(Uri url) {
    return null;

  }

  Future<HttpClientRequest> get(String host, int port, String path) {
    return null;

  }

  Future<HttpClientRequest> getUrl(Uri url) {
    return null;

  }

  Future<HttpClientRequest> head(String host, int port, String path) {
    return null;

  }

  Future<HttpClientRequest> headUrl(Uri url) {
    return null;

  }

  Future<HttpClientRequest> open(String method, String host, int port, String path) {
    return null;

  }

  Future<HttpClientRequest> openUrl(String method, Uri url) {
    return null;

  }

  Future<HttpClientRequest> patch(String host, int port, String path) {
    return null;

  }

  Future<HttpClientRequest> patchUrl(Uri url) {
    return null;

  }

  Future<HttpClientRequest> post(String host, int port, String path) {
    return null;
  }

  Future<HttpClientRequest> postUrl(Uri url) {
    if(url.scheme == "https") {
      // https
      // TODO
      return null;
    } else {
      // http
      var completer = new Completer<HttpClientResponse>();
      var jsReq = _http.callMethod("request", [{
        "hostname": url.host,
        "port": url.port,
          "path": url.path,
          "method": "POST"
      }, (jsRes) {
        completer.complete(new _HttpClientResponse(jsRes, "POST"));
      }]);
      return new Future.value(new _HttpClientRequest(jsReq, completer.future, url, "POST", new _HttpHeaders("1.1")));
    }
  }

  Future<HttpClientRequest> put(String host, int port, String path) {
    return null;

  }

  Future<HttpClientRequest> putUrl(Uri url) {
    return null;

  }
}