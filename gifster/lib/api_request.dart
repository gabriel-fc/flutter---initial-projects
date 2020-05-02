import 'package:http/http.dart' as http;
import 'dart:convert';

final urlTrending =
    "https://api.giphy.com/v1/gifs/trending?api_key=zgqrj0sKEg0zRuYHetw1pMWadfu6Kn9V&limit=20&rating=G";
final urlSearch =
    "https://api.giphy.com/v1/gifs/search?api_key=zgqrj0sKEg0zRuYHetw1pMWadfu6Kn9V&q=REPLACE_INPUT&limit=20&offset=REPLACE_OFFSET&rating=G&lang=en";
Future<List> request(input, {offset = '0'}) async {
  var res;
  if (input == "")  
    res = await http.get(urlTrending);
  else
    res = await http.get(urlSearch
        .replaceAll("REPLACE_INPUT", input)
        .replaceAll("REPLACE_OFFSET", offset));

  print(res.statusCode.toString() + " -- status code");

  if (res.statusCode == 200)
    return (jsonDecode(res.body))['data'];
  else
    return [];
}
