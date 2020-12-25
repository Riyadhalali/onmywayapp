import 'package:alatareekeh/services/Post.dart';
import 'package:alatareekeh/services/services.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> posts;
  bool loading;
  var response;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    //response = Service.getPosts();
    //print(response);
    Service.getPosts().then((list) {
      setState(() {
        posts = list;
        print(posts);
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Loading"),
      ),
      body: Container(
        color: Colors.blueAccent,
        child: ListView.builder(itemBuilder: (context, index) {
          Post post = posts[index];
          return ListTile(
            title: Text(post.title),
            subtitle: Text(post.body),
          );
        }),
      ),
    );
  }
}
