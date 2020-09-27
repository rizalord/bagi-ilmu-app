import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unord/blocs/tab_bloc.dart';
import 'package:unord/blocs/user_bloc.dart';
import 'package:unord/data/constants.dart';
import 'package:unord/helpers/widget_helper.dart';

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
    return BlocBuilder<TabBloc, int>(
      builder: (_, tab) => Scaffold(
        backgroundColor: tab == 0
            ? Theme.of(context).primaryColor
            : tab == 1
                ? Colors.orange[700]
                : tab == 2
                    ? Colors.purple[700]
                    : Color(0xFFE95908),
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
                                    : tabIndex == 2
                                        ? Colors.purple[700]
                                        : Color(0xFFE95908),
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
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 1,
                                            color:
                                                Colors.white.withOpacity(.3)),
                                      ),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .25,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                .25,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.width *
                                                .25,
                                          ),
                                          border: Border.all(
                                            width: 2,
                                            color: Colors.white,
                                          ),
                                        ),
                                        margin: EdgeInsets.all(5),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.width *
                                                .25,
                                          ),
                                          child: user['image'] != null
                                              ? WidgetHelper.ImageLoader(
                                                  URLs.host.substring(
                                                          0,
                                                          URLs.host.length -
                                                              1) +
                                                      user['image']['formats']
                                                          ['thumbnail']['url'],
                                                )
                                              : Image.asset(
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
                                              color:
                                                  Colors.white.withOpacity(.8),
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
                          child: IntrinsicHeight(
                            child: Container(
                              height: MediaQuery.of(context).size.height -
                                  (MediaQuery.of(context).size.width * .8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 40,
                              ),
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
                                                : tabIndex == 2
                                                    ? Colors.purple[700]
                                                    : Color(0xFFE95908),
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
                                                : tabIndex == 2
                                                    ? Colors.purple[700]
                                                    : Color(0xFFE95908),
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
                                                : tabIndex == 2
                                                    ? Colors.purple[700]
                                                    : Color(0xFFE95908),
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
                                                : tabIndex == 2
                                                    ? Colors.purple[700]
                                                    : Color(0xFFE95908),
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
      ),
    );
  }
}
