import 'package:hive_flutter/hive_flutter.dart';
import 'package:social_media_feeds/models/post.dart';
import 'package:social_media_feeds/models/user.dart';
import 'package:uuid/uuid.dart';

class DatabaseService{
  final Box<User> userBox = Hive.box<User>('users');
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    User? user;

    try {
      user = userBox.values.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      user = null;
    }

    if (user == null) {
      return {
        'user': User("", "", ""), 
        'error': "Geçersiz email veya şifre.",
      };
    }

    return {
      'user': user,
      'error': "", 
    };
  }

Future<Map<String, dynamic>>  signUp(String email, String password, String username) async{
     if (userBox.values.any((user) => user.username == username)) {
    
      return {
        'user': User("", "", ""), 
        'error': "Bu kullanıcı adı zaten mevcut.",
      };
    }

    if (userBox.values.any((user) => user.email == email)) {
        return {
        'user': User("", "", ""), 
        'error': "Bu email adresi zaten kullanılıyor.",
      };
    }

    userBox.add(User(username, email, password));
     return {
        'user': User(username, email, password), 
        'error': "",
      };
  }

  getPosts() async{
     try {
    var box = await Hive.openBox<Post>('posts');
    var posts = box.values.toList(); 
    posts.sort((a, b) => b.date.compareTo(a.date)); 
    posts = posts.take(10).toList(); 
    return {
        'posts': posts, 
        'error': "",
      };
  } catch (e) {
     return {
        'posts': [],
        'error': "Bir hata meydana geldi.",
      };
  }
  }
   getMorePosts(List posts) async{
     try {
    var box = await Hive.openBox<Post>('posts');
    var lastPostDate = DateTime.parse(posts.last.date); 
    var nextPosts = box.values.where((post) => DateTime.parse(post.date).isBefore(lastPostDate)).toList();
    nextPosts.sort((a, b) => b.date.compareTo(a.date)); 
    nextPosts = nextPosts.take(10).toList();
    posts.addAll(nextPosts);
    return {
        'posts': posts, 
        'error': "",
      };
  } catch (e) {
     return {
        'posts': [], 
        'error': "Bir hata meydana geldi.",
      };
  }
  }

  addLike(String id, String username) async{

        var box = await Hive.openBox<Post>('posts');
      final post = box.values.firstWhere((post) => post.id == id);
    post.likes.add(username);
    await box.put(post.key, post);
  }

  yorumYap(String username, String text,String id) async{
 var box = await Hive.openBox<Post>('posts');
      final post = box.values.firstWhere((post) => post.id == id);
        post.comments.add({username:text});
         await box.put(post.key, post);
  }

  sendPost(String text, String text2, List<String> base64images,String username) async{
     var box = await Hive.openBox<Post>('posts');
     String randomId = const Uuid().v4();
    Post post=Post(randomId, DateTime.now().toString(), text, text2, base64images, username, [], []);
    await box.add(post);
  }
}

 
