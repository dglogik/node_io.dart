part of node_io.http;

class HttpServer implements Stream<List<int>> {

  final JsObject _server;

  final InternetAddress address;

  final int port;

  bool autoCompress;
  HttpHeaders get defaultResponseHeaders => null;
  Duration idleTimeout;
  String serverHeader;
  bool get isBroadcast { return true; }
  set sessionTimeout(int timeout) {}

  HttpServer._(this.address, this.port, this._server);

  static Future<HttpServer> bind(address, int port, {int backlog: 0, bool v6Only: false, bool shared: false}) =>
    // TODO v6Only, shared
    new Future(() {
      if(!(address is InternetAddress)) {
        address = InternetAddress.lookup(address);
      }

      return new Future.value();
    }).then((_) {
      var completer = new Completer();

      var server = _http.callMethod("createServer");
      server.callMethod("listen", [port, address.address, backlog, () {
        completer.complete(new HttpServer._(address, port, server));
      }]);

      return completer.future;
    });

  static Future<HttpServer> bindSecure(address, int port, {int backlog: 0, bool v6Only: false, String certificateName, bool requestClientCertificate: false, bool shared: false}) {
    return null;
  }

  Future close({bool force: false}) {
    return null;
  }

  HttpConnectionsInfo connectionsInfo() {
    return null;
  }

  Stream<List> skip(int count) {
    return null;
  }

  Stream<List> asBroadcastStream({void onListen(StreamSubscription<List> subscription), void onCancel(StreamSubscription<List> subscription)}) {
    return null;
  }

  StreamSubscription<List> listen(void onData(List event), {Function onError, void onDone(), bool cancelOnError}) {
    return null;
  }

  Stream<List> where(bool test(List event)) {
    return null;
  }

  Stream map(convert(List event)) {
    return null;
  }

  Stream asyncMap(convert(List event)) {
    return null;
  }

  Stream asyncExpand(Stream convert(List event)) {
    return null;
  }

  Stream<List> handleError(Function onError, {bool test(error)}) {
    return null;
  }

  Stream expand(Iterable convert(List value)) {
    return null;
  }

  Future pipe(StreamConsumer<List> streamConsumer) {
    return null;
  }

  Stream transform(StreamTransformer<List, dynamic> streamTransformer) {
    return null;
  }

  Future<List> reduce(List combine(List previous, List element)) {
    return null;
  }

  Future fold(initialValue, combine(previous, List element)) {
    return null;
  }

  Future<String> join([String separator]) {
    return null;
  }

  Future<bool> contains(Object needle) {
    return null;
  }

  Future forEach(void action(List element)) {
    return null;
  }

  Future<bool> every(bool test(List element)) {
    return null;
  }

  Future<bool> any(bool test(List element)) {
    return null;
  }

  Future<int> get length {
    return null;
  }

  Future<bool> get isEmpty {
    return null;
  }

  Future<List<List>> toList() {
    return null;
  }

  Future<Set<List>> toSet() {
    return null;
  }

  Future drain([futureValue]) {
    return null;
  }

  Stream<List> take(int count) {
    return null;
  }

  Stream<List> takeWhile(bool test(List element)) {
    return null;
  }

  Stream<List> skipWhile(bool test(List element)) {
    return null;
  }

  Stream<List> distinct([bool equals(List previous, List next)]) {
    return null;
  }

  Future<List> get first {
    return null;
  }

  Future<List> get last {
    return null;
  }

  Future<List> get single {
    return null;
  }

  Future<dynamic> firstWhere(bool test(List element), {Object defaultValue()}) {
    return null;
  }

  Future<dynamic> lastWhere(bool test(List element), {Object defaultValue()}) {
    return null;
  }

  Future<List> singleWhere(bool test(List element)) {
    return null;
  }

  Future<List> elementAt(int index) {
    return null;
  }

  Stream timeout(Duration timeLimit, {void onTimeout(EventSink sink)}) {
    return null;
  }


}