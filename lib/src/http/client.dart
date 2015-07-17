part of node_io.http;

abstract class HttpClient {
  static const int DEFAULT_HTTP_PORT = 80;
  static const int DEFAULT_HTTPS_PORT = 443;

  factory HttpClient() {
    return new _HttpClient();
  }

  static String findProxyFromEnvironment(Uri url, {Map<String, String> environment}) {
    return null;
  }

  void addCredentials(Uri url, String realm, HttpClientCredentials credentials);

  void addProxyCredentials(String host, int port, String realm, HttpClientCredentials credentials);

  void close({bool force: false});

  Future<HttpClientRequest> delete(String host, int port, String path);

  Future<HttpClientRequest> deleteUrl(Uri url);

  Future<HttpClientRequest> get(String host, int port, String path);

  Future<HttpClientRequest> getUrl(Uri url);

  Future<HttpClientRequest> head(String host, int port, String path);

  Future<HttpClientRequest> headUrl(Uri url);

  Future<HttpClientRequest> open(String method, String host, int port, String path);

  Future<HttpClientRequest> openUrl(String method, Uri url);

  Future<HttpClientRequest> patch(String host, int port, String path);

  Future<HttpClientRequest> patchUrl(Uri url);

  Future<HttpClientRequest> post(String host, int port, String path);

  Future<HttpClientRequest> postUrl(Uri url);

  Future<HttpClientRequest> put(String host, int port, String path);

  Future<HttpClientRequest> putUrl(Uri url);
}

class _HttpClient implements HttpClient {
  _HttpClient();
  
  Function set badCertificateCallback(val) {}

  void addCredentials(Uri url, String realm, HttpClientCredentials credentials) {
  }

  void addProxyCredentials(String host, int port, String realm, HttpClientCredentials credentials) {
  }

  void close({bool force: false}) {}

  Future<HttpClientRequest> delete(String host, int port, String path) {
    return null;
  }

  Future<HttpClientRequest> deleteUrl(Uri url) {
    return null;
  }

  Future<HttpClientRequest> get(String host, int port, String path) {
    return getUrl(new Uri(host: host, port: port, path: path));
  }

  Future<HttpClientRequest> getUrl(Uri url) async {
    return openUrl("GET", url);

  }

  Future<HttpClientRequest> head(String host, int port, String path) {
    return null;
  }

  Future<HttpClientRequest> headUrl(Uri url) {
    return null;
  }

  Future<HttpClientRequest> open(String method, String host, int port, String path) async {
    return new _HttpClientRequest(new Uri(host: host, port: port, path: path), method, new _HttpHeaders("1.1"));
  }

  Future<HttpClientRequest> openUrl(String method, Uri url) async {
    return new _HttpClientRequest(url, method, new _HttpHeaders("1.1"));
  }

  Future<HttpClientRequest> patch(String host, int port, String path) {
    return null;
  }

  Future<HttpClientRequest> patchUrl(Uri url) {
    return null;
  }

  Future<HttpClientRequest> post(String host, int port, String path) {
    return postUrl(new Uri(host: host, port: port, path: path));
  }

  Future<HttpClientRequest> postUrl(Uri url) async {
    return openUrl("POST", url);
  }

  Future<HttpClientRequest> put(String host, int port, String path) {
    return null;
  }

  Future<HttpClientRequest> putUrl(Uri url) {
    return null;
  }
}
