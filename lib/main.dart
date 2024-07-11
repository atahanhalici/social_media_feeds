import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_media_feeds/locator.dart';
import 'package:social_media_feeds/models/post.dart';
import 'package:social_media_feeds/models/user.dart';
import 'package:social_media_feeds/pages/splash_page.dart';
import 'package:social_media_feeds/posts.dart';
import 'package:social_media_feeds/route_generator.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:social_media_feeds/viewmodels/main_viewmodel.dart';
import 'package:social_media_feeds/viewmodels/user_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('users');
  Hive.registerAdapter(PostAdapter());
  await Hive.openBox<Post>('posts'); 
  setupLocator();
  await _addDefaultPosts();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserViewModel()),
    ChangeNotifierProvider(create: (_) => MainViewModel()),
  ], child: const MyApp()));
}

Future<void> _addDefaultPosts() async {
  var box = await Hive.openBox<Post>('posts');
   //await box.clear();
var box2=await Hive.openBox<User>('users');
if(box2.isEmpty){
box2.add(User("deneme", "deneme@deneme.com", "deneme123"));
}



  if (box.isEmpty) {
    

   await box.addAll(defaultPosts);
   

  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Media Feeds',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.rotaOlustur,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}

