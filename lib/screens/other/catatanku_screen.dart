import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:unord/blocs/bookmark_bloc.dart';
import 'package:unord/components/Cards/card_diskusi.dart';
import 'package:unord/components/Cards/card_note.dart';
import 'package:unord/components/Cards/card_video.dart';
import 'package:unord/data/constants.dart';
import 'package:unord/helpers/network_helper.dart';

class CatatankuScreen extends StatefulWidget {
  @override
  _CatatankuScreenState createState() => _CatatankuScreenState();
}

class _CatatankuScreenState extends State<CatatankuScreen> {
  List data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    retrieveAllData();
  }

  retrieveAllData() async {
    if (this.mounted)
      setState(() {
        isLoading = true;
      });

    var userId = Hive.box(boxName).get('user_data', defaultValue: [])['id'];

    Response res = await NetworkHelper().get('notes?user.id=$userId');

    if (this.mounted)
      setState(() {
        data = res.data;
        isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Catatanku',
          style: TextStyle(
            color: Colors.orange[700],
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.orange[700]),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : data.length == 0
              ? Center(
                  child: Text(
                    'Belum Ada Catatan',
                    style: GoogleFonts.poppins(),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (_, item) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: NoteCard(
                              data: data[item],
                              enableDelete: true,
                              deleteCallback: retrieveAllData,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
    );
  }
}
