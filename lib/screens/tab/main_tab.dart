import 'dart:async';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unord/blocs/search_catatan_bloc.dart';
import 'package:unord/blocs/search_diskusi_bloc.dart';
import 'package:unord/blocs/search_video_bloc.dart';
import 'package:unord/blocs/tab_bloc.dart';
import 'package:unord/blocs/user_bloc.dart';
import 'package:unord/data/constants.dart';
import 'package:unord/helpers/widget_helper.dart';
import 'package:unord/screens/tab/catatan_screen.dart';
import 'package:unord/screens/tab/diskusi_screen.dart';
import 'package:unord/screens/tab/home_screen.dart';
import 'package:unord/screens/tab/video_screen.dart';
import 'package:unord/services/auth_service.dart';

class MainTab extends StatefulWidget {
  @override
  _MainTabState createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  final _pageController = PageController(initialPage: 0);
  TextEditingController catatanTextController = TextEditingController();
  TextEditingController diskusiTextController = TextEditingController();
  TextEditingController videoTextController = TextEditingController();
  Timer _debounce;
  String queryCatatan = "", queryDiskusi = "", queryVideo = "";
  int _debouncetime = 500;
  int initialPage = 0;

  @override
  void initState() {
    catatanTextController.addListener(onSearchCatatanChanged);
    diskusiTextController.addListener(onSearchDiskusiChanged);
    videoTextController.addListener(onSearchVideoChanged);
    super.initState();
  }

  void onSearchVideoChanged() {
    setState(() {
      queryVideo = videoTextController.text.trim();
    });

    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: _debouncetime), () {
      performSearchVideo(videoTextController.text.trim());
    });
  }

  void onSearchDiskusiChanged() {
    setState(() {
      queryDiskusi = diskusiTextController.text.trim();
    });

    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: _debouncetime), () {
      performSearchDiskusi(diskusiTextController.text);
    });
  }

  void onSearchCatatanChanged() {
    setState(() {
      queryCatatan = catatanTextController.text.trim();
    });

    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: _debouncetime), () {
      performSearchCatatan(catatanTextController.text);
    });
  }

  performSearchDiskusi(String query) {
    Modular.get<SearchDiskusiBloc>().add(query);
  }

  performSearchCatatan(String query) {
    Modular.get<SearchCatatanBloc>().add(query);
  }

  performSearchVideo(String query) {
    Modular.get<SearchVideoBloc>().add(query);
  }

  clearQueryCatatan() {
    setState(() {
      queryCatatan = '';
      catatanTextController.text = '';
    });
  }

  clearQueryDiskusi() {
    setState(() {
      queryDiskusi = '';
      diskusiTextController.text = '';
    });
  }

  clearQueryVideo() {
    setState(() {
      queryVideo = '';
      videoTextController.text = '';
    });
  }

  void onPageChanged(int index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);

    Modular.get<TabBloc>().add(index);

    setState(() {
      initialPage = index;
    });
  }

  void logout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Apa kamu yakin ingin keluar?'),
        actions: [
          FlatButton(
            onPressed: () => Modular.to.pop(),
            child: Text('Tidak'),
          ),
          FlatButton(
            onPressed: () async {
              if (await AuthService().logout()) {
                Modular.to.pushReplacementNamed('/login');
              }
            },
            child: Text('Ya'),
          ),
        ],
      ),
    );
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
                  : initialPage == 2
                      ? Colors.purple[700]
                      : Color(0xFFE95908),
        ),
        title: initialPage == 0
            ? Text(
                'Bagi Ilmu',
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                  color: initialPage == 0
                      ? Theme.of(context).primaryColor
                      : initialPage == 1
                          ? Colors.orange[700].withOpacity(.3)
                          : initialPage == 2
                              ? Colors.purple[700].withOpacity(.3)
                              : Color(0xFFE95908),
                  fontSize: 24,
                ),
              )
            : initialPage == 1
                ? Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        500,
                      ),
                      border: Border.all(
                        color: initialPage == 0
                            ? Theme.of(context).primaryColor
                            : initialPage == 1
                                ? Colors.orange[700]
                                : Colors.purple[700],
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 5),
                        Icon(
                          Icons.search,
                          size: 17,
                          color: Color(0xFF958989),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: TextField(
                            controller: catatanTextController,
                            decoration: InputDecoration(
                              hintText: 'Cari Catatan',
                              hintStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.5,
                                color: Color(0xFF958989),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 6.5,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        queryCatatan.length != 0
                            ? GestureDetector(
                                onTap: clearQueryCatatan,
                                child: Icon(
                                  Icons.close,
                                  size: 17,
                                  color: Color(0xFF958989),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  )
                : initialPage == 2
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            500,
                          ),
                          border: Border.all(
                            color: Colors.purple[700],
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Icon(
                              Icons.search,
                              size: 17,
                              color: Color(0xFF958989),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: TextField(
                                controller: diskusiTextController,
                                decoration: InputDecoration(
                                  hintText: 'Cari Diskusi',
                                  hintStyle: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.5,
                                    color: Color(0xFF958989),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 6.5,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                              ),
                            ),
                            queryDiskusi.length != 0
                                ? GestureDetector(
                                    onTap: clearQueryDiskusi,
                                    child: Icon(
                                      Icons.close,
                                      size: 17,
                                      color: Color(0xFF958989),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            500,
                          ),
                          border: Border.all(
                            color: Color(0xFFE95908),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Icon(
                              Icons.search,
                              size: 17,
                              color: Color(0xFFE95908),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: TextField(
                                controller: videoTextController,
                                decoration: InputDecoration(
                                  hintText: 'Cari Video',
                                  hintStyle: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.5,
                                    color: Color(0xFF958989),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 6.5,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                              ),
                            ),
                            queryVideo.length != 0
                                ? GestureDetector(
                                    onTap: clearQueryVideo,
                                    child: Icon(
                                      Icons.close,
                                      size: 17,
                                      color: Color(0xFF958989),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
        centerTitle: true,
        actions: [
          initialPage != 0 && initialPage != 3
              ? IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    initialPage == 1
                        ? Modular.to.pushNamed('/note/upload')
                        : initialPage == 2
                            ? Modular.to.pushNamed('/diskusi/upload')
                            : null;
                  },
                )
              : Container(
                  width: 40,
                ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: initialPage == 0
              ? Theme.of(context).primaryColor.withOpacity(.1)
              : initialPage == 1
                  ? Colors.orange[700].withOpacity(.1)
                  : initialPage == 2
                      ? Colors.purple[700].withOpacity(.1)
                      : Color(0xFFE95908).withOpacity(.1),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * .39,
                decoration: BoxDecoration(
                  color: initialPage == 0
                      ? Theme.of(context).primaryColor.withOpacity(.3)
                      : initialPage == 1
                          ? Colors.orange[700].withOpacity(.3)
                          : initialPage == 2
                              ? Colors.purple[700].withOpacity(.3)
                              : Color(0xFFE95908).withOpacity(.3),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/sidebar_bg.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        color: initialPage == 0
                            ? Theme.of(context).primaryColor.withOpacity(.8)
                            : initialPage == 1
                                ? Colors.orange[700].withOpacity(.8)
                                : initialPage == 2
                                    ? Colors.purple[700].withOpacity(.8)
                                    : Color(0xFFE95908).withOpacity(.8),
                      ),
                    ),
                    Positioned.fill(
                      child: BlocBuilder<UserBloc, Map>(
                        builder: (context, user) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 26,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 33,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        width: 2, color: Colors.white),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: user['image'] != null
                                        ? WidgetHelper.ImageLoader(
                                            URLs.host.substring(
                                                    0, URLs.host.length - 1) +
                                                user['image']['formats']
                                                    ['thumbnail']['url'],
                                          )
                                        : Image.asset(
                                            'assets/images/default_user_icon.png',
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10, width: 10),
                              Expanded(
                                child: Container(
                                  height: 66,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    user['username'],
                                    style: GoogleFonts.montserrat(
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text('Profil'),
                leading: Icon(
                  Icons.account_circle,
                  color: initialPage == 0
                      ? Theme.of(context).primaryColor
                      : initialPage == 1
                          ? Colors.orange[700]
                          : initialPage == 2
                              ? Colors.purple[700]
                              : Color(0xFFE95908),
                ),
                onTap: () {
                  Modular.to.pop();
                  Modular.to.pushNamed('/profile');
                },
              ),
              ListTile(
                title: Text('Catatanku'),
                leading: FaIcon(
                  FontAwesomeIcons.bookOpen,
                  color: initialPage == 0
                      ? Theme.of(context).primaryColor
                      : initialPage == 1
                          ? Colors.orange[700]
                          : initialPage == 2
                              ? Colors.purple[700]
                              : Color(0xFFE95908),
                ),
                onTap: () {
                  Modular.to.pop();
                  Modular.to.pushNamed('/catatanku');
                },
              ),
              ListTile(
                title: Text('Diskusiku'),
                leading: FaIcon(
                  FontAwesomeIcons.penAlt,
                  color: initialPage == 0
                      ? Theme.of(context).primaryColor
                      : initialPage == 1
                          ? Colors.orange[700]
                          : initialPage == 2
                              ? Colors.purple[700]
                              : Color(0xFFE95908),
                ),
                onTap: () {
                  Modular.to.pop();
                  Modular.to.pushNamed('/diskusiku');
                },
              ),
              ListTile(
                title: Text('Bookmarks'),
                leading: Icon(
                  Icons.bookmark,
                  color: initialPage == 0
                      ? Theme.of(context).primaryColor
                      : initialPage == 1
                          ? Colors.orange[700]
                          : initialPage == 2
                              ? Colors.purple[700]
                              : Color(0xFFE95908),
                ),
                onTap: () {
                  Modular.to.pop();
                  Modular.to.pushNamed('/bookmarks');
                },
              ),
              ListTile(
                title: Text('Logout'),
                leading: Icon(
                  Icons.logout,
                  color: initialPage == 0
                      ? Theme.of(context).primaryColor
                      : initialPage == 1
                          ? Colors.orange[700]
                          : initialPage == 2
                              ? Colors.purple[700]
                              : Color(0xFFE95908),
                ),
                onTap: logout,
              ),
            ],
          ),
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
            title: Text('Diskusi'),
            activeColor: Colors.purple[700],
          ),
          BottomNavyBarItem(
            icon: Padding(
              padding: EdgeInsets.only(left: 5),
              child: FaIcon(
                FontAwesomeIcons.youtube,
                size: 20,
              ),
            ),
            title: Text('Video'),
            activeColor: Color(0xFFE95908),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomeScreen(),
          CatatanScreen(),
          DiskusiScreen(),
          VideoScreen(),
        ],
      ),
    );
  }
}
