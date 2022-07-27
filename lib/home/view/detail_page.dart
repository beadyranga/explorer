import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  // In the constructor, require a Todo.
  var data;

  DetailScreen({required this.todo}) {
    data = todo.data() as Map<String, dynamic>;
  }

  // Declare a field that holds the Todo.
  DocumentSnapshot todo;

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(data["place_name"]),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(1, 16, 0, 0),
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 1, 10, 0),
                child: Image.network(
                  data['image_url'],
                  fit: BoxFit.fitWidth,
                ),
              ),
              ListTile(
                title: Text(
                  data['place_name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  data['country'] +
                      " : " +
                      data['province'] +
                      " : " +
                      data['city'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 10, 0),
                child: Expanded(
                  child: Row(
                    children: [
                      Row(children: [
                        Text("Web :",style: TextStyle(fontWeight: FontWeight.bold),),

                      ]),
                      Expanded(
                          child: Text(
                            data['web_url'],
                            style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black,decoration: TextDecoration.underline),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          )),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
                scrollDirection: Axis.vertical, //.horizontal
                child: new Text(data['description']),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
