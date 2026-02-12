import 'package:flutter/material.dart';
import 'package:spotify__uiclone/views/home.dart';
import 'package:spotify__uiclone/views/library.dart';
import 'package:spotify__uiclone/views/profile.dart';
import 'package:spotify__uiclone/views/search.dart';

class Tabbar extends StatefulWidget {
  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 70),
        child: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (index) {
            setState(() {
              this._selectedTab = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music),
              label: "Your Library",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
      body: Stack(
        children: [
          renderView(0, HomeView()),
          renderView(1, SearchView()),
          renderView(2, LibraryView()),
          renderView(3, ProfileView()),
        ],
      ),
    );
  }

  Widget renderView(int tabIndex, Widget view) {
    return IgnorePointer(
      ignoring: _selectedTab != tabIndex,
      child: Opacity(opacity: _selectedTab == tabIndex ? 1 : 0, child: view),
    );
  }
}

