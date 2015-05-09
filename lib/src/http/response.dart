part of node_io.http;

class _HttpClientResponse implements HttpClientResponse {

  List<List> _data = <List>[];

  Completer<List> _first = new Completer<List>();
  Completer<List> _last = new Completer<List>();

  final HttpClientRequest _httpRequest;
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

  }

  Stream<List> skip(int count) {

  }

  Future<dynamic> firstWhere(bool test(List element), {Object defaultValue()}) {

  }

  Stream timeout(Duration timeLimit, {void onTimeout(EventSink sink)}) {

  }


  Stream<List> asBroadcastStream({void onListen(StreamSubscription<List> subscription), void onCancel(StreamSubscription<List> subscription)}) {

  }

  Stream<List> where(bool test(List event)) {

  }

  Stream map(convert(List event)) {

  }

  Stream<List> handleError(Function onError, {bool test(error)}) {

  }

  Stream transform(StreamTransformer<List, dynamic> streamTransformer) {

  }

  Future<bool> every(bool test(List element)) {

  }

  Future<List> singleWhere(bool test(List element)) {

  }

  Stream asyncMap(convert(List event)) {

  }

  Stream asyncExpand(Stream convert(List event)) {

  }

  Stream expand(Iterable convert(List value)) {

  }

  Future<String> join([String separator]) {

  }

  Future<bool> get isEmpty {

  }

  bool get persistentConnection {

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

  }

  Future drain([futureValue]) {

  }

  Stream<List> take(int count) {

  }

  Stream<List> distinct([bool equals(List previous, List next)]) {

  }

  Future<dynamic> lastWhere(bool test(List element), {Object defaultValue()}) {
    
  }

  Future<List> elementAt(int index) {

  }

  X509Certificate get certificate {

  }

  StreamSubscription<List> listen(void onData(List event), {Function onError, void onDone(), bool cancelOnError}) {

  }

  Future pipe(StreamConsumer<List> streamConsumer) {

  }

  Future<bool> contains(Object needle) {

  }

  Future<int> get length {

  }

  Future<List<List>> toList() {

  }

  Stream<List> takeWhile(bool test(List element)) {

  }

  Future<List> get single {

  }

  Future<HttpClientResponse> redirect([String method, Uri url, bool followLoops]) {

  }

  Future<Socket> detachSocket() {

  }

  Future forEach(void action(List element)) {

  }

  List<Cookie> get cookies {

  }

  HttpConnectionInfo get connectionInfo {

  }

  Future<Set<List>> toSet() {

  }

  Stream<List> skipWhile(bool test(List element)) {

  }

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