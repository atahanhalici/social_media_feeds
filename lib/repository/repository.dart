// ignore_for_file: void_checks

import 'package:social_media_feeds/locator.dart';
import 'package:social_media_feeds/services/database_service.dart';

class Repository{
final DatabaseService _databaseService = locator<DatabaseService>();


  signIn(String email, String password) async{
    return await _databaseService.signIn(email,password);
  }

  signUp(String email, String password, String username)async {
    return await _databaseService.signUp(email,password,username);
  }
getPosts()async{
   return await _databaseService.getPosts();
}
getMorePosts(List posts)async{
   return await _databaseService.getMorePosts(posts);
}

  void addLike(String id, String username) async{
    return await _databaseService.addLike(id,username);
  }

  yorumYap(String username, String text,String id)async {
 return await _databaseService.yorumYap(username,text,id);
  }

  sendPost(String text, String text2, List<String> base64images,String username) async{
    return await _databaseService.sendPost(text,text2,base64images,username);
  }
}