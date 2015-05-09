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

class _HttpClientResponse implements HttpClientResponse {

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

  bool get isBroadcast => true;

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

  Future<List> reduce(List combine(List previous, List element)) {
    return null;
  }

  Stream<List> skip(int count) {
    return null;
  }

  Future<dynamic> firstWhere(bool test(List element), {Object defaultValue()}) {
    return null;
  }

  Stream timeout(Duration timeLimit, {void onTimeout(EventSink sink)}) {
    return null;
  }

  Stream<List> asBroadcastStream({void onListen(StreamSubscription<List> subscription), void onCancel(StreamSubscription<List> subscription)}) {
    return null;
  }

  Stream<List> where(bool test(List event)) {
    return null;
  }

  Stream map(convert(List event)) {
    return null;
  }

  Stream<List> handleError(Function onError, {bool test(error)}) {
    return null;
  }

  Stream transform(StreamTransformer<List, dynamic> streamTransformer) {
    return null;
  }

  Future<bool> every(bool test(List element)) {
    return null;
  }

  Future<List> singleWhere(bool test(List element)) {
    return null;
  }

  Stream asyncMap(convert(List event)) {
    return null;
  }

  Stream asyncExpand(Stream convert(List event)) {
    return null;
  }

  Stream expand(Iterable convert(List value)) {
    return null;
  }

  Future<String> join([String separator]) {
    return null;
  }

  Future<bool> get isEmpty {
    return null;
  }

  bool get persistentConnection {
    return null;
  }

  Future fold(initialValue, combine(previous, List element)) {
    return last.then((_) {
      for(var d in _data) {
        initialValue = combine(initialValue, d);
      }
      return initialValue;
    });
  }

  Future<bool> any(bool test(List element)) {
    return null;
  }

  Future drain([futureValue]) {
    return null;
  }

  Stream<List> take(int count) {
    return null;
  }

  Stream<List> distinct([bool equals(List previous, List next)]) {
    return null;
  }

  Future<dynamic> lastWhere(bool test(List element), {Object defaultValue()}) {
    return null;
  }

  Future<List> elementAt(int index) {
    return null;
  }

  X509Certificate get certificate {
    return null;
  }

  StreamSubscription<List> listen(void onData(List event), {Function onError, void onDone(), bool cancelOnError}) {
    return null;
  }

  Future pipe(StreamConsumer<List> streamConsumer) {
    return null;
  }

  Future<bool> contains(Object needle) {
    return null;
  }

  Future<int> get length {
    return null;
  }

  Future<List<List>> toList() {
    return null;
  }

  Stream<List> takeWhile(bool test(List element)) {
    return null;
  }

  Future<List> get single {
    return null;
  }

  Future<HttpClientResponse> redirect([String method, Uri url, bool followLoops]) {
    return null;
  }

  Future<Socket> detachSocket() {
    return null;
  }

  Future forEach(void action(List element)) {
    return null;
  }

  List<Cookie> get cookies {
    return null;
  }

  HttpConnectionInfo get connectionInfo {
    return null;
  }

  Future<Set<List>> toSet() {
    return null;
  }

  Stream<List> skipWhile(bool test(List element)) {
    return null;
  }

}