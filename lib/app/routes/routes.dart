import 'package:explorer/app/bloc/app_bloc.dart';
import 'package:explorer/home/view/home_page.dart';
import 'package:explorer/login/view/login_page.dart';
import 'package:flutter/widgets.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
