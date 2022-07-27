
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/bloc/app_bloc.dart';
import 'detail_page.dart';

class MainPage extends StatefulWidget {

  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _Page1State();
}

class _Page1State extends State<MainPage> {

  TextEditingController _searchController = TextEditingController();
  CollectionReference allPlaceCollection = FirebaseFirestore.instance.collection('places');
  List<DocumentSnapshot> documents = [];
  List<Map<String, dynamic>> favourites = [];
  bool isSaved = false;
  var array = "";
  List<int> favouriteList = [];
  String documentId = "";

  String searchText = '';

  @override
  Widget build(BuildContext context) {
    var userValue = context.select((AppBloc bloc) => bloc.state.user).email;
    int currentPageIndex = 0;
    fetchData(userValue.toString());

    return Center(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.all(20.0),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: allPlaceCollection.snapshots(),
                  builder: (context, snapshots) {
                    return (snapshots.connectionState ==
                        ConnectionState.waiting)
                        ? Center(
                      child: CircularProgressIndicator(),
                    )
                        : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshots.data!.docs.length,
                              itemBuilder: (context, index) {
                                var data = snapshots.data!.docs[index]
                                    .data() as Map<String, dynamic>;

                                if (data['place_name']
                                    .toString()
                                    .toLowerCase()
                                    .contains(searchText
                                    .toLowerCase()
                                    .toString())) {
                                  print("inside if " + searchText);
                                  // print(name);
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        child: Card(
                                          semanticContainer: true,
                                          clipBehavior:
                                          Clip.antiAliasWithSaveLayer,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 200,
                                                width: 400,
                                                child: Image.network(
                                                  data['image_url'],
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                              ListTile(
                                                title: Text(
                                                  data['place_name'],
                                                  maxLines: 1,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  style: TextStyle(
                                                      color: Colors
                                                          .black54,
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold),
                                                ),
                                                subtitle: Text(
                                                  data['country'] +
                                                      " : " +
                                                      data['province'] +
                                                      " : " +
                                                      data['city'],
                                                  maxLines: 1,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  style: TextStyle(
                                                      color: Colors
                                                          .black54,
                                                      fontSize: 12,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold),
                                                ),
                                                // trailing: GestureDetector(
                                                //   behavior: HitTestBehavior.translucent,
                                                //   child: Icon(
                                                //     favouriteList.contains( data['FIELD1'])
                                                //         ? Icons.favorite
                                                //         : Icons.favorite_border,
                                                //     color: favouriteList.contains( data['FIELD1'])
                                                //         ? Colors.red
                                                //         : null,
                                                //   ),
                                                // ),
                                              ),
                                            ],
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                10.0),
                                          ),
                                          elevation: 5,
                                          margin: EdgeInsets.all(10),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailScreen(
                                                        todo: snapshots
                                                            .data!
                                                            .docs[
                                                        index],favouriteList: favouriteList,documentId: documentId)),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                }
                                return Container();
                              }),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );


  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // IconData returnIconWidget(Map<String, dynamic> data) {
  //   favourites.add(data);
  //
  //   return Icons.favorite;
  // }

  void fetchData(String user,) async{
    print(user.toString());
    FirebaseFirestore.instance.collection('users').where('email',isEqualTo: user).get().then((querySnapshot) {
      print("-----------------");
      print(querySnapshot.docs[0].data());
      print(querySnapshot.docs[0].id);
      documentId = querySnapshot.docs[0].id;
      favouriteList = List.from(querySnapshot.docs[0].data()['favourite']);
      print(favouriteList);

    });
  }

}