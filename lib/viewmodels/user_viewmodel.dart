import 'package:flutter/material.dart';
import 'package:social_media_feeds/locator.dart';
import 'package:social_media_feeds/models/user.dart';
import 'package:social_media_feeds/repository/repository.dart';


enum ViewStates { geliyor, geldi, hata }

class UserViewModel with ChangeNotifier {
  final Repository _repository = locator<Repository>();
  ViewStates _state = ViewStates.geliyor;
  ViewStates get state => _state;
  User user = User("", "", "");
  String metin="";

  set state(ViewStates value) {
    _state = value;
    notifyListeners();
  }

  guncelle(){
 notifyListeners();
  }

   signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    state = ViewStates.geliyor;
    try {
    var sonuc= await _repository.signIn(email,password);
    if(sonuc['error']!=""){
      metin=sonuc['error'];
      state = ViewStates.hata;
      return false;
    }else{
      user=sonuc['user'];
      state = ViewStates.geldi;
      return true;
    }
      
    } catch (e) {
      state = ViewStates.hata;
      return false;
    }
  }

  signUp(String email, String password, String username)async{
    await Future.delayed(const Duration(seconds: 1));
    state = ViewStates.geliyor;
    try {
    var sonuc= await _repository.signUp(email,password,username);
    if(sonuc['error']!=""){
      metin=sonuc['error'];
      state = ViewStates.geldi;
      return false;
    }else{
      user=sonuc['user'];
      state = ViewStates.geldi;
      return true;
    }
      
    } catch (e) {
      state = ViewStates.hata;
      return false;
    }
  }
}