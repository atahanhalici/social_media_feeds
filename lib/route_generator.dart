import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_media_feeds/pages/add_feed_page.dart';
import 'package:social_media_feeds/pages/home_page.dart';
import 'package:social_media_feeds/pages/login_page.dart';
import 'package:social_media_feeds/pages/post_detail_page.dart';
import 'package:social_media_feeds/pages/register_page.dart';
import 'package:social_media_feeds/pages/splash_page.dart';

class RouteGenerator {
  static Route<dynamic>? _gidilecekrota(
      Widget gidilecekWidget, RouteSettings settings) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageRoute(
          settings: settings, builder: (context) => gidilecekWidget);
    } else {
      return MaterialPageRoute(
          settings: settings, builder: (context) => gidilecekWidget);
    }
  }

  static Route<dynamic>? rotaOlustur(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _gidilecekrota(const SplashPage(), settings);
      case '/login':
        return _gidilecekrota(const LoginPage(), settings);
      case '/register':
        return _gidilecekrota(const RegisterPage(), settings);
      case '/homepage':
        return _gidilecekrota(const HomePage(), settings);
      case '/postdetail':
        return _gidilecekrota(const PostDetailPage(), settings);
      case '/addFeed':
        return _gidilecekrota(const AddFeedPage(), settings);
      default:
        return _gidilecekrota(const LoginPage(), settings);
    }
  }
}