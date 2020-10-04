import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unord/blocs/auth_bloc.dart';
import 'package:unord/blocs/bookmark_bloc.dart';
import 'package:unord/blocs/catatan_refresh.dart';
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
import 'package:unord/screens/auth/login_screen.dart';
import 'package:unord/screens/auth/register_screen.dart';
import 'package:unord/screens/auth/splash_screen.dart';
import 'package:unord/screens/detail/detail_diskusi_screen.dart';
import 'package:unord/screens/detail/detail_note_screen.dart';
import 'package:unord/screens/detail/detail_playlist_screen.dart';
import 'package:unord/screens/detail/detail_video_screen.dart';
import 'package:unord/screens/other/catatanku_screen.dart';
import 'package:unord/screens/other/diskusiku_screen.dart';
import 'package:unord/screens/other/list_bookmark_screen.dart';
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
        Bind((_) => SearchVideoBloc()),
        Bind((_) => BookmarkBloc()),
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
        ModularRouter('/bookmarks', child: (_, __) => ListBookmarkScreen()),
        ModularRouter('/catatanku', child: (_, __) => CatatankuScreen()),
        ModularRouter('/diskusiku', child: (_, __) => DiskusikuScreen()),
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
        ModularRouter(
          '/playlist/detail',
          child: (_, args) => DetailPlaylistScreen(
            id: args.data['id'],
          ),
        ),
        ModularRouter(
          '/video/detail',
          child: (_, args) => DetailVideoScreen(
            id: args.data['id'],
          ),
        ),
      ];

  @override
  Widget get bootstrap => AppWidget();
}
