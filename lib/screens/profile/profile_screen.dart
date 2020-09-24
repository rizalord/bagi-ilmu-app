import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unord/blocs/tab_bloc.dart';
import 'package:unord/blocs/user_bloc.dart';
import 'package:unord/data/constants.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final emailController = TextEditingController();
  final cityController = TextEditingController();
  final provinceController = TextEditingController();
  final phoneController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserBloc, Map>(
        builder: (_, user) {
          emailController.text = user['email'];
          cityController.text = user['city'] == null ? '-' : user['city'];
          provinceController.text =
              user['province'] == null ? '-' : user['province'];
          phoneController.text =
              user['phone_number'] == null ? '-' : user['phone_number'];

          return Stack(
            children: [
              SingleChildScrollView(
                child: BlocBuilder<TabBloc, int>(
                  builder: (_, tabIndex) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: (MediaQuery.of(context).size.width * .8),
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top),
                        decoration: BoxDecoration(
                          color: tabIndex == 0
                              ? Theme.of(context).primaryColor
                              : tabIndex == 1
                                  ? Colors.orange[700]
                                  : Colors.purple[700],
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          width: 1,
                                          color: Colors.white.withOpacity(.3)),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            width: 2, color: Colors.white),
                                      ),
                                      margin: EdgeInsets.all(5),
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: user['image'] != null
                                            ? CachedNetworkImageProvider(
                                                URLs.host.substring(0,
                                                        URLs.host.length - 1) +
                                                    user['image']['formats']
                                                        ['thumbnail']['url'],
                                              )
                                            : AssetImage(
                                                'assets/images/default_user_icon.png',
                                              ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    user['username'],
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  user['city'] != null &&
                                          user['province'] != null
                                      ? Text(
                                          user['city'] +
                                              ', ' +
                                              user['province'],
                                          style: GoogleFonts.poppins(
                                            color: Colors.white.withOpacity(.8),
                                            fontSize: 16,
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 40),
                          child: Column(
                            children: [
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    color: tabIndex == 0
                                        ? Theme.of(context).primaryColor
                                        : tabIndex == 1
                                            ? Colors.orange[700]
                                            : Colors.purple[700],
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(.5),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(.5),
                                    ),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(.5),
                                    ),
                                  ),
                                ),
                                controller: emailController,
                              ),
                              SizedBox(height: 8),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: 'No HP',
                                  labelStyle: TextStyle(
                                    color: tabIndex == 0
                                        ? Theme.of(context).primaryColor
                                        : tabIndex == 1
                                            ? Colors.orange[700]
                                            : Colors.purple[700],
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(.5),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(.5),
                                    ),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(.5),
                                    ),
                                  ),
                                ),
                                controller: phoneController,
                              ),
                              SizedBox(height: 8),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: 'Kota',
                                  labelStyle: TextStyle(
                                    color: tabIndex == 0
                                        ? Theme.of(context).primaryColor
                                        : tabIndex == 1
                                            ? Colors.orange[700]
                                            : Colors.purple[700],
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(.5),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(.5),
                                    ),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(.5),
                                    ),
                                  ),
                                ),
                                controller: cityController,
                              ),
                              SizedBox(height: 8),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: 'Provinsi',
                                  labelStyle: TextStyle(
                                    color: tabIndex == 0
                                        ? Theme.of(context).primaryColor
                                        : tabIndex == 1
                                            ? Colors.orange[700]
                                            : Colors.purple[700],
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(.5),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(.5),
                                    ),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(.5),
                                    ),
                                  ),
                                ),
                                controller: provinceController,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 5,
                top: 5 + MediaQuery.of(context).padding.top,
                child: IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () => Modular.to.pop(),
                ),
              ),
              Positioned(
                right: 5,
                top: 5 + MediaQuery.of(context).padding.top,
                child: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.pencilAlt,
                    color: Colors.white,
                    size: 18,
                  ),
                  onPressed: () => Modular.to.pushNamed('/profile/edit'),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
