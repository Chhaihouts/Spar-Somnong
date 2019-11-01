import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_kickstart/data_provider/chat_provider.dart';
import 'package:flutter_kickstart/data_provider/user_provider.dart';
import 'package:flutter_kickstart/presentations/bottom_navigation_tab/account_tab.dart';
import 'package:flutter_kickstart/presentations/bottom_navigation_tab/nested_navigator.dart';
import 'package:flutter_kickstart/presentations/screen/login_screen.dart';
import 'package:provider/provider.dart';

import 'bottom_navigation_tab/home_tab.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainPageState createState() => new _MainPageState();
}

enum TabItem {
  HomeTab,
  AccountScreenTab
}
class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
  StreamSubscription chatChangeListener;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      NestedNavigator(
        initialRoute: "/",
        routes: {
          "/": (context) => Home(),
          '/login': (context) => LoginScreen(),
        },
        navigationKey: navigationKey,
      ),
      AccountScreen(),
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      listenChatChange();
      Provider.of<UserProvider>(context, listen: true).addListener((){
        listenChatChange();
      });
    });
  }

  @override
  void dispose() {
    chatChangeListener?.cancel();
    super.dispose();
  }

  void listenChatChange(){
    var user = Provider.of<UserProvider>(context, listen: false).getUser();
    if (user != null && chatChangeListener == null) {
      chatChangeListener=Provider.of<ChatProvider>(context,listen: false).dbreference
          .orderByChild('users/${user.id}/userId')
          .equalTo(user.id)
          .onValue
          .listen((onData){
        var value = onData.snapshot.value as Map<dynamic, dynamic>;
        print("chat length ${value?.length}");
        if(value != null){
          Provider.of<ChatProvider>(context,listen: false).numberOfChat = value.length;
        }else{
          Provider.of<ChatProvider>(context,listen: false).numberOfChat = 0;
        }
        bool hasSeenAll = true;
        value.values.forEach((chat){
          if(chat['lastMessage'] != null){
            if(chat['lastMessage']['key']!=chat['users']['${user.id}']['lastSeen']){
              hasSeenAll = false;
            }
          }
        });
        print("has seen all $hasSeenAll");
        Provider.of<ChatProvider>(context,listen: false).hasSeenAll = hasSeenAll;
      });
    }else{
      chatChangeListener?.cancel();
      chatChangeListener = null;
    }
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      var isLoggedIn = Provider.of<UserProvider>(context, listen: false).getUser();
      if (isLoggedIn == null) {
        Navigator.of(context).pushNamed("/login");
        return;
      }
    }
    setState(() {
      if (_selectedIndex == index && index == 0) {
        navigationKey.currentState.popUntil(ModalRoute.withName("/"));
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: IndexedStack(
            children: _widgetOptions,
            index: _selectedIndex,
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/icons/home.png",
                    width: 25.47,
                    height: 22,
                  ),
                  activeIcon: Image.asset(
                    "assets/icons/home_active.png",
                    width: 25.47,
                    height: 22,
                  ),
                  title: Container(height: 0),
                  backgroundColor: Colors.white),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/account.png",
                  width: 25.47,
                  height: 22,
                ),
                activeIcon: Image.asset(
                  "assets/icons/account_active.png",
                  width: 25.47,
                  height: 22,
                ),
                title: Container(height: 0),
              ),
            ],
            backgroundColor: Colors.white,
            unselectedItemColor: Colors.blue,
            unselectedFontSize: 14.0,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.teal,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
          ),
        );
  }
}
