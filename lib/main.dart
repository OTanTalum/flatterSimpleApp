import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart.';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final token ='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
    'eyJpZCI6IjE5MTY5MzY2MjQxIiwiaWF0IjoxNTc0NzQ1MzkzfQ.'
    'KNjy849Hj6eJLSV_holfJzNGBU9UUoJADGb3Y4hBMj0';

Future<Post> fetchPost() async {


  final response = await http.get(
      'https://prod.mascotbe.com/groups/discover', headers: {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Authorization': 'Bearer $token',
  });

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Post {
  String date;
  List<groups> group;

  Post({this.date, this.group});

  factory Post.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['groups'] as List;
    List<groups> groupList =
        list.map((i) => groups.fromJson(i)).toList();

    return Post(
      date: parsedJson['date'] as String,
      group: groupList,
    );
  }
}

// ignore: camel_case_types
class groups {
  String name;
  List<images> image;

  groups({
    this.name,
    this.image,
  });

  factory groups.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['images'] as List;
    List<images> ImageList =
    list.map((i) => images.fromJson(i)).toList();
    return groups(
        name: parsedJson['name'] as String,
        image:ImageList,

    );
  }
}
class images {
  String url;

  images({this.url});

  factory images.fromJson(Map<String, dynamic> parsedJson) {

    return images(
      url: parsedJson['url'] as String,
    );
  }
}


void main() => runApp(MyApp(post: fetchPost()));

class MyApp extends StatelessWidget {
  final Future<Post> post;

  MyApp({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.amber[700],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Simple app'),
        ),
        body: Center(
            child: Container(
              color: Colors.grey[90120],
              child: FutureBuilder<Post>(
                future: post,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.separated(
                      padding: const EdgeInsets.all(1.0),
                      itemCount: snapshot.data.group.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                                        child: ListTile(
                                            leading: Image.network(snapshot.data.group[index].image[0].url,
                                                height: 200,
                                                width: 100,
                                            ),

                                    title: Text(
                                        snapshot.data.group[index].name,
                                        style: TextStyle(
                                            color: Colors.black)),

                                    trailing: Container(
                                      width: 60,
                                      height: 40,
                                    )));
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  // By default, show a loading spinner
                  return CircularProgressIndicator();
                },
              ),
            )
        ),
      ),
    );
  }
}
