import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explorer/app/bloc/app_bloc.dart';
import 'package:explorer/home/blocs/places/places_bloc.dart';
import 'package:explorer/home/view/visa_update.dart';
import 'package:explorer/home/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme.dart';
import 'detail_page.dart';
import 'favourite_page.dart';
import 'main_page.dart';

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
    _page1 = const MainPage();
    _page2 = FavouritePage();
    _page3 = const VisaUpdate();
    _pages = [_page1, _page2,_page3];
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
    var userValue = context.select((AppBloc bloc) => bloc.state.user).email;
    int currentPageIndex = 0;
    fetchData(userValue.toString());
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



