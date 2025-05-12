// ignore_for_file: constant_identifier_names

import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class Secrets {
  static const ANDROID_CLIENT_ID = "53407187172-qmgmqf2k9miias551cbpcuufojovrv4a.apps.googleusercontent.com";

  static const AGENT_IOS_CLIENT_ID = "53407187172-0vdorhavj97c79l48q6pkf1j6lovapj6.apps.googleusercontent.com";

  static const USER_IOS_CLIENT_ID = "53407187172-t9oqptv6mhqmrlf0rb3b50hfip2nmgm2.apps.googleusercontent.com";

  static const WEB_CLIENT_ID = "53407187172-t1ojln3gadj5pvd10bga2gjevvnt93lq.apps.googleusercontent.com";

  static String getIosId() => sl<HomePageBloc>().isUserFlow
      ? Secrets.USER_IOS_CLIENT_ID : Secrets.AGENT_IOS_CLIENT_ID;

  static const PLAID_CLIENT_ID = "63f87207e9b49300135afac8";

  static const PLAID_SECRET = "606fc93026114c32eb5dfc2d6725b6";
}
