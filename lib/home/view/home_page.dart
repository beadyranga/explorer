import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explorer/app/bloc/app_bloc.dart';
import 'package:explorer/home/blocs/places/places_bloc.dart';
import 'package:explorer/home/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    String name = "";
    final db = FirebaseFirestore.instance;
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            key: const Key('homePage_logout_iconButton'),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context.read<AppBloc>().add(AppLogoutRequested()),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search), hintText: 'Search...'),
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            )),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('places').snapshots(),
              builder: (context, snapshots) {
                return (snapshots.connectionState == ConnectionState.waiting)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                itemCount: snapshots.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var data = snapshots.data!.docs[index].data()
                                      as Map<String, dynamic>;

                                  if (name.isEmpty) {
                                    return Column(children: [
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
                                          data['city'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              'https://i.cbc.ca/1.6057754.1645809488!/fileImage/httpImage/image.JPG_gen/derivatives/16x9_780/sir-john-a-macdonald-secondary-school-waterloo.JPG'),
                                        ),
                                      ),
                                    ]);
                                  }
                                  if (data['place_name']
                                      .toString()
                                      .toLowerCase()
                                      .startsWith(name.toLowerCase())) {
                                    return Column(
                                      children: [
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
                                            data['city'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                'https://mapio.net/images-p/8528448.jpg'),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    print("Error");
                                  }
                                  return Container();
                                }),
                          )
                        ],
                      );
              },
            )),
          ],
        ),
      ),
    );

    // StreamBuilder<QuerySnapshot>(
    //   stream: FirebaseFirestore.instance.collection('places').snapshots(),
    //   builder: (context, snapshots) {
    //     return (snapshots.connectionState == ConnectionState.waiting)
    //         ? Center(
    //       child: CircularProgressIndicator(),
    //     )
    //         : Column(
    //       children: [
    //         TextField(
    //     //           decoration: InputDecoration(
    //     //               prefixIcon: Icon(Icons.search), hintText: 'Search...'),
    //     //           onChanged: (val) {
    //     //             setState(() {
    //     //               name = val;
    //     //             });
    //     //           },
    //         ),
    //         Expanded(
    //           child: ListView.builder(
    //               itemCount: snapshots.data!.docs.length,
    //               itemBuilder: (context, index) {
    //                 var data = snapshots.data!.docs[index].data()
    //                 as Map<String, dynamic>;
    //
    //                 if (name.isEmpty) {
    //                   return Column(children: [
    //                     ListTile(
    //                       title: Text(
    //                         data['place_name'],
    //                         maxLines: 1,
    //                         overflow: TextOverflow.ellipsis,
    //                         style: TextStyle(
    //                             color: Colors.black54,
    //                             fontSize: 16,
    //                             fontWeight: FontWeight.bold),
    //                       ),
    //                       subtitle: Text(
    //                         data['city'],
    //                         maxLines: 1,
    //                         overflow: TextOverflow.ellipsis,
    //                         style: TextStyle(
    //                             color: Colors.black54,
    //                             fontSize: 16,
    //                             fontWeight: FontWeight.bold),
    //                       ),
    //                       leading: CircleAvatar(
    //                         backgroundImage: NetworkImage(
    //                             'https://i.cbc.ca/1.6057754.1645809488!/fileImage/httpImage/image.JPG_gen/derivatives/16x9_780/sir-john-a-macdonald-secondary-school-waterloo.JPG'),
    //                       ),
    //                     ),
    //                   ]);
    //                 }
    //                 if (data['place_name']
    //                     .toString()
    //                     .toLowerCase()
    //                     .startsWith(name.toLowerCase())) {
    //                   return Column(
    //                     children: [
    //                       ListTile(
    //                         title: Text(
    //                           data['place_name'],
    //                           maxLines: 1,
    //                           overflow: TextOverflow.ellipsis,
    //                           style: TextStyle(
    //                               color: Colors.black54,
    //                               fontSize: 16,
    //                               fontWeight: FontWeight.bold),
    //                         ),
    //                         subtitle: Text(
    //                           data['city'],
    //                           maxLines: 1,
    //                           overflow: TextOverflow.ellipsis,
    //                           style: TextStyle(
    //                               color: Colors.black54,
    //                               fontSize: 16,
    //                               fontWeight: FontWeight.bold),
    //                         ),
    //                         leading: CircleAvatar(
    //                           backgroundImage: NetworkImage(
    //                               'https://mapio.net/images-p/8528448.jpg'),
    //                         ),
    //                       ),
    //                     ],
    //                   );
    //                 }
    //                 return Container();
    //               }),
    //         )
    //       ],
    //     );
    //   },
    // )
  }
}
