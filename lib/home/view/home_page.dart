import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explorer/app/bloc/app_bloc.dart';
import 'package:explorer/home/blocs/places/places_bloc.dart';
import 'package:explorer/home/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Widget> _pages;
  late Widget _page1;
  late Widget _page2;
  late Widget _page3;
  late int _currentIndex;
  late Widget _currentPage;

  @override
  void initState() {
    super.initState();
    _page1 = const Page1();
    _page2 = const Page2();
    _pages = [_page1, _page2];
    _currentIndex = 0;
    _currentPage = _page1;
  }
  void fetchData(String user) async{
    print(user.toString());
    FirebaseFirestore.instance.collection('users').where('email',isEqualTo: user).get().then((querySnapshot) {
      print("-----------------");
      print(querySnapshot.docs[0].data());
      List<int> favouriteList = List.from(querySnapshot.docs[0].data()['favourite']);
      print(favouriteList);
      // querySnapshot.forEach((doc) => {
      // console.log(doc.id);
      // });
    });
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);


  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _currentPage = _pages[index];
    });
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    String name = "";
    final db = FirebaseFirestore.instance;
    // var userValue = context.select((AppBloc bloc) => bloc.state.user).email;
    int currentPageIndex = 0;
    // fetchData(userValue.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          IconButton(
            key: const Key('homePage_logout_iconButton'),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context.read<AppBloc>().add(AppLogoutRequested()),
          )
        ],
      ),
      body: Center(
        child: _currentPage,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outlined),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tour),
            label: 'Visa',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.redAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}

class Page1 extends StatefulWidget {

  const Page1({Key? key}) : super(key: key);

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {

  TextEditingController _searchController = TextEditingController();
  CollectionReference allPlaceCollection = FirebaseFirestore.instance.collection('places');
  List<DocumentSnapshot> documents = [];
  List<Map<String, dynamic>> favourites = [];
  bool isSaved = false;
  var array = "";
  List<int> favouriteList = [];


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
                                                trailing: GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: () {
                                                    print('Icon-tryck');
                                                  },
                                                  child: Icon(
                                                    favouriteList.contains( data['FIELD1'])
                                                        ? returnIconWidget(data)
                                                        : Icons.favorite_border,
                                                    color: favouriteList.contains( data['FIELD1'])
                                                        ? Colors.red
                                                        : null,
                                                  ),
                                                ),),
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
                                                        index])),
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

  IconData returnIconWidget(Map<String, dynamic> data) {
    favourites.add(data);
    return Icons.favorite;
  }

  void fetchData(String user) async{
    print(user.toString());
    FirebaseFirestore.instance.collection('users').where('email',isEqualTo: user).get().then((querySnapshot) {
      print("-----------------");
      print(querySnapshot.docs[0].data());
      favouriteList = List.from(querySnapshot.docs[0].data()['favourite']);
      print(favouriteList);

    });
  }


}

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(' Page'),
    );
  }
}
