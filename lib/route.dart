import 'package:get/get.dart';
import 'package:refresh_network/home_list/view.dart';
import 'package:refresh_network/login/view.dart';

class Routes {
  static String login = "/login";
  static String home="/home";
  static List<GetPage> get pages {
    return [
       GetPage(name: login,page: () =>  LoginPage(),),
      GetPage(name: home,page: () =>  LiveStreamingPage(),)
    ];
  }
}