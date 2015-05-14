import "package:node_io/io.dart";

import "dart:convert";

main() async {
  await testHttp();
}

testHttp() async {
  print("== HTTP Client ==");
  var client = new HttpClient();
  print("Making POST Request");
  HttpClientRequest req = await client.postUrl(Uri.parse("http://www.httpbin.org/post"));
  print("Writing Data to Request");
  req.write("Hello World");
  print("Closing Request");
  HttpClientResponse res = await req.close();
  print("Got Response");
  print("Listening to Response");
  res.listen((list) => print(UTF8.decode(list)));
}
