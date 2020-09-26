import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unord/blocs/auth_bloc.dart';
import 'package:unord/blocs/education_bloc.dart';
import 'package:unord/blocs/liked_diskusi_bloc.dart';
import 'package:unord/blocs/liked_notes_bloc.dart';
import 'package:unord/blocs/search_catatan_bloc.dart';
import 'package:unord/blocs/search_diskusi_bloc.dart';
import 'package:unord/blocs/subject_bloc.dart';
import 'package:unord/blocs/tab_bloc.dart';
import 'package:unord/blocs/user_bloc.dart';
import 'package:unord/blocs/voted_comment_bloc.dart';
import 'package:unord/screens/auth/login_screen.dart';
import 'package:unord/screens/auth/register_screen.dart';
import 'package:unord/screens/auth/splash_screen.dart';
import 'package:unord/screens/detail/detail_diskusi_screen.dart';
import 'package:unord/screens/detail/detail_note_screen.dart';
import 'package:unord/screens/profile/profile_edit_screen.dart';
import 'package:unord/screens/profile/profile_screen.dart';
import 'package:unord/screens/tab/main_tab.dart';
import 'package:unord/screens/upload/add_diskusi_screen.dart';
import 'package:unord/screens/upload/add_note_screen.dart';

import 'app_widget.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind((_) => AuthBloc()),
        Bind((_) => UserBloc()),
        Bind((_) => TabBloc()),
        Bind((_) => SearchCatatanBloc()),
        Bind((_) => LikedNotesBloc()),
        Bind((_) => SearchDiskusiBloc()),
        Bind((_) => LikedDiskusiBloc()),
        Bind((_) => EducationBloc()),
        Bind((_) => SubjectBloc()),
        Bind((_) => VotedCommentBloc()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter('/', child: (_, __) => SplashScreen()),
        ModularRouter('/login', child: (_, __) => LoginScreen()),
        ModularRouter('/register', child: (_, __) => RegisterScreen()),
        ModularRouter('/general', child: (_, __) => MainTab()),
        ModularRouter('/profile', child: (_, __) => ProfileScreen()),
        ModularRouter('/profile/edit', child: (_, __) => EditProfileScreen()),
        ModularRouter('/note/upload', child: (_, __) => AddNoteScreen()),
        ModularRouter('/diskusi/upload', child: (_, __) => AddDiskusiScreen()),
        ModularRouter(
          '/note/detail',
          child: (_, args) => DetailNoteScreen(
            id: args.data['id'],
          ),
        ),
        ModularRouter(
          '/diskusi/detail',
          child: (_, args) => DetailDiskusiScreen(
            id: args.data['id'],
          ),
        ),
      ];

  @override
  Widget get bootstrap => AppWidget();
}
