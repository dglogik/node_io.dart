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
    return post(url.host, url.port, url.path);
  }

  Future<HttpClientRequest> put(String host, int port, String path) {
    return null;

  }

  Future<HttpClientRequest> putUrl(Uri url) {
    return null;

  }
}