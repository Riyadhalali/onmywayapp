import 'package:alatareekeh/services/Post.dart';
import 'package:http/http.dart' as http;

class Service {
  static const String url =
      'https://jsonplaceholder.typicode.com/posts'; // link of the server

  static Future<List<Post>> getPosts() async {
    try {
      final response = await http.get(url); // get the data from the server
      // print(response.body);
      if (response.statusCode == 200) {
        final List<Post> listPosts = postFromJson(response.body);
        //   print(listPosts);
        return listPosts;
      }
    } catch (e) {
      return List<Post>();
    }
  } // end function
} // end class
