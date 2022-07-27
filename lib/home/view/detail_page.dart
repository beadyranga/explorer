import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailScreen extends StatefulWidget {
  // In the constructor, require a Todo.
  var data;
  List<int> favouriteList;
  String documentId;
  DetailScreen({required this.todo,required this.favouriteList,required this.documentId}) {
    data = todo.data() as Map<String, dynamic>;
  }

  // Declare a field that holds the Todo.
  DocumentSnapshot todo;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data["place_name"]),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 1, 10, 0),
            child: Image.network(
              widget.data['image_url'],
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(1, 0, 10, 0),
            child: ListTile(

              title: Text(
                widget.data['place_name'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                widget.data['country'] + " : " + widget.data['province'] + " : " + widget.data['city'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              trailing: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  print('Icon-tryck');

                  if(widget.favouriteList.contains( widget.data['FIELD1'])) {
                    // Remove fav icon
                    print((widget.data['ratings']).toDouble());
                    print("remove"+ widget.data['FIELD1'].toString());
                    widget.favouriteList.remove(widget.data['FIELD1']);
                    updateIcon(widget.data);
                  } else {
                    // add fav icon
                    print("add"  + widget.data['FIELD1'].toString());
                    widget.favouriteList.add(widget.data['FIELD1']);
                    updateIcon(widget.data);
                  }

                  setState(() {

                  });
                },
                child: Icon(

                  widget.favouriteList.contains(widget.data['FIELD1'])
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color:
                      widget.favouriteList.contains(widget.data['FIELD1']) ? Colors.red : null,
                  size: 35,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 1, 10, 0),
              child: RatingBar.builder(
                initialRating: (widget.data['ratings']).toDouble(),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 30,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 0, 10, 0),
            child: Container(
              child: Row(
                children: [
                  Row(children: [
                    Text(
                      "Web :",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ]),
                  Container(
                      child: Text(
                    widget.data['web_url'],
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        decoration: TextDecoration.underline),
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
            child: new Text(widget.data['description']),
          ),
        ],
      ),
    );
  }

  Future<void>  updateIcon(Map<String, dynamic> data) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // widget.favouriteList.add(data['FIELD1']);
    print(widget.favouriteList);
    return users
        .doc(widget.documentId)
        .update({'favourite': widget.favouriteList})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));

  }


}
