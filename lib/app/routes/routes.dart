import 'package:flutter/material.dart';

import '../../home/view/home_view.dart';
import '../../login/view/view.dart';
import '../bloc/app_bloc.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
