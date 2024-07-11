// ignore_for_file: avoid_returning_null_for_void

import 'package:flutter/material.dart';
import 'package:social_media_feeds/locator.dart';
import 'package:social_media_feeds/models/post.dart';
import 'package:social_media_feeds/repository/repository.dart';


enum ViewState { geliyor, geldi, hata }

class MainViewModel with ChangeNotifier {
  final Repository _repository = locator<Repository>();
  ViewState _state = ViewState.geliyor;
  ViewState get state => _state;
 List<Post> posts=[];
  String metin="";
  bool finish=false;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

   getPosts() async{
 await Future.delayed(const Duration(seconds: 1));
    state = ViewState.geliyor;
    try {
    var sonuc= await _repository.getPosts();
    if(sonuc['error']!=""){
      metin=sonuc['error'];
      state = ViewState.hata;
      return false;
    }else{
      posts=sonuc['posts'];
      state = ViewState.geldi;
      return true;
    }
      
    } catch (e) {
      state = ViewState.hata;
      return false;
    }
   }
   getMorePosts(List posts) async{
 await Future.delayed(const Duration(seconds: 1));
    try {
    var sonuc= await _repository.getMorePosts(posts);
    if(sonuc['error']!=""){
      metin=sonuc['error'];
      notifyListeners();
      return false;
    }else{
      posts=sonuc['posts'];
      if(posts.length%10!=0){
        finish=true;
      }
      notifyListeners();
      return true;
    }
    } catch (e) {
      notifyListeners();
      return false;
    }
   }

  void begeniEkle(String id, String username) {
    for (var post in posts) {
    if (post.id == id) {
           
        return    _repository.addLike(id,username);
    

    }
    notifyListeners();
  }
  return null; 
}

  void yorumYap(String username, String text,String id) async{
        state = ViewState.geliyor;
   await _repository.yorumYap(username,text,id);
   await Future.delayed(const Duration(seconds: 1));
       state = ViewState.geldi;
  }

  void sendPost(String text, String text2, List<String> base64images,String username) async{
     state = ViewState.geliyor;
   await _repository.sendPost(text,text2,base64images,username);
   await Future.delayed(const Duration(seconds: 1));
       state = ViewState.geldi;
  }
  }
  

