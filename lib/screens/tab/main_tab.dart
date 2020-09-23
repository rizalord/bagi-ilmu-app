import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unord/screens/tab/home_screen.dart';

class MainTab extends StatefulWidget {
  @override
  _MainTabState createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  final _pageController = PageController(initialPage: 0);
  int initialPage = 0;

  void onPageChanged(int index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);

    print(index);

    setState(() {
      initialPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).textSelectionColor,
        iconTheme: IconThemeData(
          color: initialPage == 0
              ? Theme.of(context).primaryColor
              : initialPage == 1
                  ? Colors.orange[700]
                  : Colors.purple[700],
        ),
        title: Text(
          'Unord',
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            color: initialPage == 0
                ? Theme.of(context).primaryColor
                : initialPage == 1
                    ? Colors.orange[700]
                    : Colors.purple[700],
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 33,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(width: 2, color: Colors.white),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://avatars1.githubusercontent.com/u/49712569?s=460&u=88f8d12ee2c71e442fb30ad4138d33bbe254fd87&v=4',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ahmad Khamdani',
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
              decoration: BoxDecoration(
                  color: initialPage == 0
                      ? Theme.of(context).primaryColor
                      : initialPage == 1
                          ? Colors.orange[700]
                          : Colors.purple[700]),
            ),
            ListTile(
              title: Text('Profil'),
              leading: Icon(Icons.account_circle),
              onTap: () {},
            ),
            ListTile(
              title: Text('Catatanku'),
              leading: Icon(Icons.library_books),
              onTap: () {},
            ),
            ListTile(
              title: Text('Bookmarks'),
              leading: Icon(Icons.bookmark),
              onTap: () {},
            ),
            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.logout),
              onTap: () {},
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: initialPage,
        onItemSelected: onPageChanged,
        curve: Curves.easeInOut,
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: Theme.of(context).primaryColor,
          ),
          BottomNavyBarItem(
            icon: Padding(
              padding: EdgeInsets.only(left: 5),
              child: FaIcon(
                FontAwesomeIcons.bookOpen,
                size: 20,
              ),
            ),
            title: Text('Catatan'),
            activeColor: Colors.orange[700],
          ),
          BottomNavyBarItem(
              icon: Padding(
                padding: EdgeInsets.only(left: 5),
                child: FaIcon(
                  FontAwesomeIcons.pencilAlt,
                  size: 20,
                ),
              ),
              title: Text('Diskusi PR'),
              activeColor: Colors.purple[700]),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomeScreen(),
          HomeScreen(),
          HomeScreen(),
        ],
      ),
    );
  }
}
