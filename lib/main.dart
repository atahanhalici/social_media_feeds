import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
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
  // await box.clear();
var box2=await Hive.openBox<User>('users');
if(box2.isEmpty){
box2.add(User("deneme", "deneme@deneme.com", "deneme123"));
box2.add(User("atahanhalici", "atahan@deneme.com", "atahan123"));
box2.add(User("asb", "asb@deneme.com", "asb123"));
}



  if (box.isEmpty) {
    

   await box.addAll(defaultPosts);
   for (var photoPath in photos) {
      // Uygulama özel klasör yolunu al
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      // Asset dosyasının byte verisini al
      ByteData data = await rootBundle.load(photoPath);
      List<int> bytes = data.buffer.asUint8List();

      // Kopyalanacak dosyanın hedef yolunu oluştur
      String assetFileName = photoPath.split('/').last; // Asset dosya adını al
      String filePath = '$appDocPath/$assetFileName';

      // Dosyayı uygulama özel klasöre kopyala
      File file = File(filePath);
      await file.writeAsBytes(bytes);

      // ID'ye göre post nesnesini bul ve güncelle
      String id = "";
      if (photoPath.contains("iphone")) {
        id = "10";
      } else if (photoPath.contains("trabzon")) {
        id = "1";
      } else if (photoPath.contains("izmir")) {
        id = "3";
      }

    if(id!="100"){
      try{
    final post = box.values.firstWhere((post) => post.id == id);
        post.imageUrl.add(filePath);
   await box.put(post.key, post);
   print(post.imageUrl);
      }catch(e){
        print(e);
      }

    }

  }
   

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

