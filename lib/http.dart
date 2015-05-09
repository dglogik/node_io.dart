library node_io.http;

import 'package:node_io/util.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:js';
import 'dart:collection';
import 'dart:typed_data';

import 'common.dart';

part 'src/http/headers.dart';
part 'src/http/date.dart';

part 'src/http/response.dart';
part 'src/http/request.dart';

part 'src/http/client.dart';
part 'src/http/server.dart';

JsObject _http = require('http');
JsObject _https = require('https');

abstract class HeaderValue {
  Map<String, String> get parameters;

  String get value;

  factory HeaderValue([String value="", Map<String, String> parameters]) {
    return new _HeaderValue(value, parameters);
  }

  static HeaderValue parse(String value, {parameterSeparator: ";", preserveBackslash: false}) {
    return _HeaderValue.parse(value, parameterSeparator: parameterSeparator, preserveBackslash: preserveBackslash);
  }

  String toString();
}

abstract class ContentType implements HeaderValue {
  static final TEXT = new ContentType("text", "plain", charset: "utf-8");
  static final HTML = new ContentType("text", "html", charset: "utf-8");
  static final JSON = new ContentType("application", "json", charset: "utf-8");
  static final BINARY = new ContentType("application", "octet-stream");

  String get charset;
  String get mimeType;
  String get primaryType;
  String get subType;

  factory ContentType(String primaryType, String subType, {String charset, Map<String, String> parameters}) {
    return new _ContentType(primaryType, subType, charset, parameters);
  }

  static ContentType parse(String value) {
    return _ContentType.parse(value);
  }
}

abstract class Cookie {
  DateTime expires;

  String domain;
  String name;
  String path;
  String value;

  int maxAge;

  bool httpOnly;
  bool secure;

  factory Cookie([String name, String value]) {
    return new _Cookie(name, value);
  }

  factory Cookie.fromSetCookieValue(String value) {
    return new _Cookie.fromSetCookieValue(value);
  }

  String toString();
}

abstract class HttpClientCredentials {}

abstract class HttpConnectionInfo {
  InternetAddress get remoteAddress;

  int get localPort;
  int get remotePort;
}

abstract class HttpStatus {
  static const int CONTINUE = 100;
  static const int SWITCHING_PROTOCOLS = 101;
  static const int OK = 200;
  static const int CREATED = 201;
  static const int ACCEPTED = 202;
  static const int NON_AUTHORITATIVE_INFORMATION = 203;
  static const int NO_CONTENT = 204;
  static const int RESET_CONTENT = 205;
  static const int PARTIAL_CONTENT = 206;
  static const int MULTIPLE_CHOICES = 300;
  static const int MOVED_PERMANENTLY = 301;
  static const int FOUND = 302;
  static const int MOVED_TEMPORARILY = 302; // Common alias for FOUND.
  static const int SEE_OTHER = 303;
  static const int NOT_MODIFIED = 304;
  static const int USE_PROXY = 305;
  static const int TEMPORARY_REDIRECT = 307;
  static const int BAD_REQUEST = 400;
  static const int UNAUTHORIZED = 401;
  static const int PAYMENT_REQUIRED = 402;
  static const int FORBIDDEN = 403;
  static const int NOT_FOUND = 404;
  static const int METHOD_NOT_ALLOWED = 405;
  static const int NOT_ACCEPTABLE = 406;
  static const int PROXY_AUTHENTICATION_REQUIRED = 407;
  static const int REQUEST_TIMEOUT = 408;
  static const int CONFLICT = 409;
  static const int GONE = 410;
  static const int LENGTH_REQUIRED = 411;
  static const int PRECONDITION_FAILED = 412;
  static const int REQUEST_ENTITY_TOO_LARGE = 413;
  static const int REQUEST_URI_TOO_LONG = 414;
  static const int UNSUPPORTED_MEDIA_TYPE = 415;
  static const int REQUESTED_RANGE_NOT_SATISFIABLE = 416;
  static const int EXPECTATION_FAILED = 417;
  static const int INTERNAL_SERVER_ERROR = 500;
  static const int NOT_IMPLEMENTED = 501;
  static const int BAD_GATEWAY = 502;
  static const int SERVICE_UNAVAILABLE = 503;
  static const int GATEWAY_TIMEOUT = 504;
  static const int HTTP_VERSION_NOT_SUPPORTED = 505;
  static const int NETWORK_CONNECT_TIMEOUT_ERROR = 599;
}

abstract class HttpHeaders {
  static const ACCEPT = "accept";
  static const ACCEPT_CHARSET = "accept-charset";
  static const ACCEPT_ENCODING = "accept-encoding";
  static const ACCEPT_LANGUAGE = "accept-language";
  static const ACCEPT_RANGES = "accept-ranges";
  static const AGE = "age";
  static const ALLOW = "allow";
  static const AUTHORIZATION = "authorization";
  static const CACHE_CONTROL = "cache-control";
  static const CONNECTION = "connection";
  static const CONTENT_ENCODING = "content-encoding";
  static const CONTENT_LANGUAGE = "content-language";
  static const CONTENT_LENGTH = "content-length";
  static const CONTENT_LOCATION = "content-location";
  static const CONTENT_MD5 = "content-md5";
  static const CONTENT_RANGE = "content-range";
  static const CONTENT_TYPE = "content-type";
  static const DATE = "date";
  static const ETAG = "etag";
  static const EXPECT = "expect";
  static const EXPIRES = "expires";
  static const FROM = "from";
  static const HOST = "host";
  static const IF_MATCH = "if-match";
  static const IF_MODIFIED_SINCE = "if-modified-since";
  static const IF_NONE_MATCH = "if-none-match";
  static const IF_RANGE = "if-range";
  static const IF_UNMODIFIED_SINCE = "if-unmodified-since";
  static const LAST_MODIFIED = "last-modified";
  static const LOCATION = "location";
  static const MAX_FORWARDS = "max-forwards";
  static const PRAGMA = "pragma";
  static const PROXY_AUTHENTICATE = "proxy-authenticate";
  static const PROXY_AUTHORIZATION = "proxy-authorization";
  static const RANGE = "range";
  static const REFERER = "referer";
  static const RETRY_AFTER = "retry-after";
  static const SERVER = "server";
  static const TE = "te";
  static const TRAILER = "trailer";
  static const TRANSFER_ENCODING = "transfer-encoding";
  static const UPGRADE = "upgrade";
  static const USER_AGENT = "user-agent";
  static const VARY = "vary";
  static const VIA = "via";
  static const WARNING = "warning";
  static const WWW_AUTHENTICATE = "www-authenticate";

  // Cookie headers from RFC 6265.
  static const COOKIE = "cookie";
  static const SET_COOKIE = "set-cookie";

  static const GENERAL_HEADERS = const [CACHE_CONTROL,
  CONNECTION,
  DATE,
  PRAGMA,
  TRAILER,
  TRANSFER_ENCODING,
  UPGRADE,
  VIA,
  WARNING];

  static const ENTITY_HEADERS = const [ALLOW,
  CONTENT_ENCODING,
  CONTENT_LANGUAGE,
  CONTENT_LENGTH,
  CONTENT_LOCATION,
  CONTENT_MD5,
  CONTENT_RANGE,
  CONTENT_TYPE,
  EXPIRES,
  LAST_MODIFIED];


  static const RESPONSE_HEADERS = const [ACCEPT_RANGES,
  AGE,
  ETAG,
  LOCATION,
  PROXY_AUTHENTICATE,
  RETRY_AFTER,
  SERVER,
  VARY,
  WWW_AUTHENTICATE];

  static const REQUEST_HEADERS = const [ACCEPT,
  ACCEPT_CHARSET,
  ACCEPT_ENCODING,
  ACCEPT_LANGUAGE,
  AUTHORIZATION,
  EXPECT,
  FROM,
  HOST,
  IF_MATCH,
  IF_MODIFIED_SINCE,
  IF_NONE_MATCH,
  IF_RANGE,
  IF_UNMODIFIED_SINCE,
  MAX_FORWARDS,
  PROXY_AUTHORIZATION,
  RANGE,
  REFERER,
  TE,
  USER_AGENT];

  DateTime date;
  DateTime expires;
  DateTime ifModifiedSince;

  ContentType contentType;

  int contentLength;
  int port;

  bool persistentConnection;
  bool chunkedTransferEncoding;

  List<String> operator[](String name);

  String value(String name);
  String host;

  void add(String name, Object value);
  void set(String name, Object value);
  void remove(String name, Object value);
  void removeAll(String name);
  void forEach(void f(String name, List<String> values));
  void noFolding(String name);
  void clear();
}

class HttpException implements Exception {
  final String message;
  final Uri uri;

  const HttpException(this.message, {this.uri : null});
}