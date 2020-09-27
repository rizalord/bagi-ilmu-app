//  app_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unord/blocs/auth_bloc.dart';
import 'package:unord/blocs/bookmark_bloc.dart';
import 'package:unord/blocs/education_bloc.dart';
import 'package:unord/blocs/liked_diskusi_bloc.dart';
import 'package:unord/blocs/liked_notes_bloc.dart';
import 'package:unord/blocs/search_catatan_bloc.dart';
import 'package:unord/blocs/search_diskusi_bloc.dart';
import 'package:unord/blocs/search_video_bloc.dart';
import 'package:unord/blocs/subject_bloc.dart';
import 'package:unord/blocs/tab_bloc.dart';
import 'package:unord/blocs/user_bloc.dart';
import 'package:unord/blocs/voted_comment_bloc.dart';
import 'package:unord/theme/styles.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => Modular.get<AuthBloc>()),
        BlocProvider<UserBloc>(create: (context) => Modular.get<UserBloc>()),
        BlocProvider<TabBloc>(create: (context) => Modular.get<TabBloc>()),
        BlocProvider<SearchCatatanBloc>(
            create: (context) => Modular.get<SearchCatatanBloc>()),
        BlocProvider<LikedNotesBloc>(
            create: (context) => Modular.get<LikedNotesBloc>()),
        BlocProvider<SearchDiskusiBloc>(
            create: (context) => Modular.get<SearchDiskusiBloc>()),
        BlocProvider<LikedDiskusiBloc>(
            create: (context) => Modular.get<LikedDiskusiBloc>()),
        BlocProvider<EducationBloc>(
            create: (context) => Modular.get<EducationBloc>()),
        BlocProvider<SubjectBloc>(
            create: (context) => Modular.get<SubjectBloc>()),
        BlocProvider<VotedCommentBloc>(
            create: (context) => Modular.get<VotedCommentBloc>()),
        BlocProvider<SearchVideoBloc>(
            create: (context) => Modular.get<SearchVideoBloc>()),
        BlocProvider<BookmarkBloc>(
            create: (context) => Modular.get<BookmarkBloc>()),
      ],
      child: MaterialApp(
        initialRoute: "/",
        navigatorKey: Modular.navigatorKey,
        onGenerateRoute: Modular.generateRoute,
        themeMode: ThemeMode.light,
        theme: CustomTheme.lightTheme,
        darkTheme: CustomTheme.darkTheme,
      ),
    );
  }
}
