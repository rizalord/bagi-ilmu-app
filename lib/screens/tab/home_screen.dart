import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Header(),
              Education(),
              Subject(),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Row(
                        children: [
                          Text(
                            'Video',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Color(0xFFBC3686),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            ' Pembelajaran',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Color(0xFFFF8625),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              width: MediaQuery.of(context).size.width * .7,
                              height: MediaQuery.of(context).size.width * .5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(11),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://i.ytimg.com/vi/ZpU3mEaK0_w/maxresdefault.jpg',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Text(
                                    'Kalkulus',
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        height: 2,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              width: MediaQuery.of(context).size.width * .7,
                              height: MediaQuery.of(context).size.width * .5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(11),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://i.ytimg.com/vi/hJHvdBlSxug/maxresdefault.jpg',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Text(
                                    'Biology',
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        height: 2,
                                        color: Colors.purple),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class Subject extends StatelessWidget {
  const Subject({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 15),
      margin: EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mata Pelajaran',
            textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Color(0xFFBC3686),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runAlignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.end,
            runSpacing: 10,
            spacing: (MediaQuery.of(context).size.width - (2 * 15)) * .030,
            children: [
              Container(
                width: (MediaQuery.of(context).size.width - (2 * 15)) * .485,
                height: MediaQuery.of(context).size.width * .3,
                decoration: BoxDecoration(
                  color: Color(0xFFFA694C),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.bookReader,
                              size: 41,
                              color: Colors.white,
                            ),
                            Text(
                              'Matematika',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: ((MediaQuery.of(context).size.width - (2 * 15)) *
                              .485) *
                          .28,
                      decoration: BoxDecoration(
                        color: Color(0xFFFF9233),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                          topRight: Radius.circular(11),
                          bottomRight: Radius.circular(11),
                        ),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.pencilRuler,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width - (2 * 15)) * .485,
                height: MediaQuery.of(context).size.width * .3,
                decoration: BoxDecoration(
                  color: Color(0xFF8E3ED2),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.bookReader,
                              size: 41,
                              color: Colors.white,
                            ),
                            Text(
                              'IPA',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: ((MediaQuery.of(context).size.width - (2 * 15)) *
                              .485) *
                          .28,
                      decoration: BoxDecoration(
                        color: Color(0xFF462066),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                          topRight: Radius.circular(11),
                          bottomRight: Radius.circular(11),
                        ),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.dna,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width - (2 * 15)) * .485,
                height: MediaQuery.of(context).size.width * .3,
                decoration: BoxDecoration(
                  color: Color(0xFF462066),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.bookReader,
                              size: 41,
                              color: Colors.white,
                            ),
                            Text(
                              'B. Indonesia',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: ((MediaQuery.of(context).size.width - (2 * 15)) *
                              .485) *
                          .28,
                      decoration: BoxDecoration(
                        color: Color(0xFF8E3ED2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                          topRight: Radius.circular(11),
                          bottomRight: Radius.circular(11),
                        ),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.book,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width - (2 * 15)) * .485,
                height: MediaQuery.of(context).size.width * .3,
                decoration: BoxDecoration(
                  color: Color(0xFFFF9233),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.bookReader,
                              size: 41,
                              color: Colors.white,
                            ),
                            Text(
                              'B. Inggris',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: ((MediaQuery.of(context).size.width - (2 * 15)) *
                              .485) *
                          .28,
                      decoration: BoxDecoration(
                        color: Color(0xFFFA694C),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                          topRight: Radius.circular(11),
                          bottomRight: Radius.circular(11),
                        ),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.rocketchat,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class Education extends StatelessWidget {
  const Education({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 15),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jenjang Pendidikan',
            textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Color(0xFFBC3686),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 15),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: (MediaQuery.of(context).size.width - (2 * 15)) *
                            .485,
                        height: MediaQuery.of(context).size.width * .3,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(11),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFBC3686).withOpacity(.17),
                              offset: Offset(0, 9),
                              blurRadius: 42,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(11),
                                child: Image.asset(
                                  'assets/images/sd_home.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  color: Color(0xFFBC3686).withOpacity(.64),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                borderRadius: BorderRadius.circular(11),
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(11),
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'SD',
                                        style: GoogleFonts.poppins(
                                          fontSize: 40,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width:
                          (MediaQuery.of(context).size.width - (2 * 15)) * .485,
                      height: MediaQuery.of(context).size.width * .3,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(11),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFFE4014).withOpacity(.17),
                            offset: Offset(0, 9),
                            blurRadius: 42,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(11),
                              child: Image.asset(
                                'assets/images/smp_home.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                color: Color(0xFFFE4014).withOpacity(.64),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Material(
                              borderRadius: BorderRadius.circular(11),
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(11),
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'SMP',
                                      style: GoogleFonts.poppins(
                                        fontSize: 40,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  width: (MediaQuery.of(context).size.width - (2 * 15)),
                  height: MediaQuery.of(context).size.width * .3,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(11),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF7304CA).withOpacity(.17),
                        offset: Offset(0, 9),
                        blurRadius: 42,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: Image.asset(
                            'assets/images/sma_home.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            color: Color(0xFF7304CA).withOpacity(.64),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Material(
                          borderRadius: BorderRadius.circular(11),
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(11),
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Center(
                                child: Text(
                                  'SMA/SMK',
                                  style: GoogleFonts.poppins(
                                    fontSize: 40,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * .5,
      padding: EdgeInsets.symmetric(horizontal: 15),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hello,',
                  style: GoogleFonts.roboto(
                    fontSize: 26,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  'Brayden',
                  style: GoogleFonts.roboto(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Image.asset(
              'assets/images/home_illustration.png',
            ),
          ),
        ],
      ),
    );
  }
}
