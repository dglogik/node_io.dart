import 'package:node_io/io.dart';

import 'dart:convert';

main() async {
  print("#1");
  HttpClientRequest req = await (new HttpClient()).postUrl(Uri.parse("http://www.httpbin.org/post"));
  print("#2");
  req.add(UTF8.encode("Hello world"));
  print("#3");
  HttpClientResponse res = await req.close();
  print("#4");
  res.listen((list) {});
  print("#5");
}