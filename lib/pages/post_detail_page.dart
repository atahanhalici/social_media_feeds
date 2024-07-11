// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_feeds/models/post.dart';
import 'package:social_media_feeds/pages/home_page.dart';
import 'package:social_media_feeds/viewmodels/main_viewmodel.dart';
import 'package:social_media_feeds/viewmodels/user_viewmodel.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  bool isLoading = false;
  bool isFabVisible = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var _mainModel = Provider.of<MainViewModel>(context, listen: false);
  
  }
  final CarouselController _carouselController = CarouselController();
   int _current = 0;
    void _showBottomSheet(BuildContext context , List likes) {

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
       
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0), 
                topRight: Radius.circular(20.0), 
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.separated(
                                  shrinkWrap: true,
                                  physics:const NeverScrollableScrollPhysics(),
                                  itemCount: likes.length,
                                  itemBuilder: (context, idx) {
                                    return Container(
                                      margin:const EdgeInsets.symmetric(vertical: 10),
                                      padding:const EdgeInsets.all(10),
                                      
                                      child:
                                       
                                        Row(
                                          children: [
                                         const   CircleAvatar(backgroundImage: AssetImage('assets/logoyazisiz.jpg'),),
                                       const     SizedBox(width: 10,),
                                            Text(
                                              likes[idx].toString(),
                                              style:const TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                     
                                    );
                                  },separatorBuilder: (context, index) {
                                    return const Divider();
                                  },
                                ),
            ),
          );
        });
      },
    );
  }
     void _handleMenuItem(String value) {
    switch (value) {
      case 'add_feed':
        Navigator.pushNamed(context, "/addFeed",
                     );
        break;
      case 'logout':
         Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (Route<dynamic> route) => false,
        );
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
  
    MainViewModel _mainModel = Provider.of<MainViewModel>(context, listen: true);
     UserViewModel _userModel = Provider.of<UserViewModel>(context, listen: true);
     final argument = ModalRoute.of(context)!.settings.arguments as Post;

     String tarih=formatHumanReadableDate(DateTime.parse(argument.date));
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 215, 237, 255),
      appBar: AppBar(title: Text(argument.headerText),centerTitle: true,actions: [PopupMenuButton<String>(
            icon:const Icon(Icons.more_vert),
            onSelected: _handleMenuItem,
            itemBuilder: (BuildContext context) {
              return [
             const   PopupMenuItem<String>(
                  value: 'add_feed',
                  child: Text('Add Post'),
                ),
              const  PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ];
            },
          ),],),

      body: DoubleTapLike(
        post: argument,
        child: Container( width: MediaQuery.of(context).size.width,
                              padding:const EdgeInsets.all(15),
                              margin:const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (argument.imageUrl.isNotEmpty)
                                   Visibility(
                                        visible: true,
                                        child: Center(
                                          child: Container(
                                            margin:const EdgeInsets.symmetric(horizontal: 20),
                                            child: argument.imageUrl.length == 1
                                                ? ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: Image.memory(
                                                      base64.decode(argument.imageUrl[0].split(',')[1]),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                :  argument.imageUrl.isEmpty
                                                    ? const SizedBox.shrink()
                                                    : Column(
                                                        children: [
                                                          CarouselSlider(
                                items: argument.imageUrl.map((img) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.memory(
                                          base64.decode(img.split(',')[1]),
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                                carouselController: _carouselController,
                                options: CarouselOptions(
                                  padEnds: false,
                                  viewportFraction: 1,
                                  height: 300,
                                  autoPlay: true,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  },
                                ),
                                                          ),
                                                          Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: argument.imageUrl.map((url) {
                                  int index = argument.imageUrl.indexOf(url);
                                  return Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin:const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 2.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _current == index
                                          ? const Color.fromARGB(255, 34, 126, 167)
                                          :const  Color.fromRGBO(0, 0, 0, 0.4),
                                    ),
                                  );
                                }).toList(),
                                                          ),
                                                        ],
                                                      ),
                                          ),
                                        ),
                                      ),
                                 const   SizedBox(height: 15),
                                    
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                      Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Expanded(
      child: Text(
        argument.headerText,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    ),
    const SizedBox(width: 10), // Metin ve ikonlar arasında boşluk bırakır
    ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: <Color>[
            Colors.red,
            Colors.purple,
            Colors.pink,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: const Icon(
        Icons.favorite,
        color: Color.fromARGB(255, 255, 0, 0),
        size: 20,
      ),
    ),
    const SizedBox(width: 5),
    Text(
      argument.likes.length.toString(),
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),
    const SizedBox(width: 15),
    ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: <Color>[
            Colors.red,
            Colors.purple,
            Colors.pink,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: const Icon(
        Icons.comment,
        color: Color.fromARGB(255, 255, 0, 0),
        size: 20,
      ),
    ),
    const SizedBox(width: 5),
    Text(
      argument.comments.length.toString(),
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),
  ],
)
,
                                        
 if (argument.likes.length == 1) GestureDetector(
  onTap: () => _showBottomSheet(context,argument.likes),
   child: Row(
        children: [
          Text("${argument.likes.contains(_userModel.user.username)?"Siz":{argument.likes[0]}}",style:const TextStyle(fontWeight: FontWeight.w700),),
          Text(argument.likes.contains(_userModel.user.username)?" beğendiniz":" beğendi"),
        ],
      ),
 ) else argument.likes.length > 1
        ? GestureDetector(
           onTap: () => _showBottomSheet(context,argument.likes),
          child: Row(
            children: [
              Text("${argument.likes.contains(_userModel.user.username)?"Siz":{argument.likes[0]}}",style:const TextStyle(fontWeight: FontWeight.w700),),
             const  Text(" ve "),
                Text("${argument.likes.length - 1} kişi daha",style: const TextStyle(fontWeight: FontWeight.w700),),
             const    Text(" beğendi"),
            ],
          ),
        )
        : const SizedBox(),

                                     
                                       
                                      ],
                                    ),
                               const     SizedBox(height: 10),
                                   RichText(
                                        text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "${argument.author}: ",
                                          style:const  TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(255, 34, 126, 167), 
                                          ),
                                        ),
                                        TextSpan(
                                          text: argument.bodyText,
                                          style:const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                        ),
                                       
                                      ),
                                      
                                 const   SizedBox(height: 10),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                       tarih,
                                        textAlign: TextAlign.end,
                                        style:const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ),
                               const     SizedBox(height: 20,),
                                    if (argument.comments.isNotEmpty && _mainModel.state==ViewState.geldi) ...[
                                    const   Divider(),
                                const    SizedBox(height: 20,),
                                const    Text("Comments", style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),),
                             const   SizedBox(height: 10),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics:const NeverScrollableScrollPhysics(),
                                  itemCount: argument.comments.length,
                                  itemBuilder: (context, idx) {
                                    return Container(
                                      margin:const EdgeInsets.symmetric(vertical: 4),
                                      padding:const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child:RichText(
                                        text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "${argument.comments[idx].keys.first}: ",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(255, 34, 126, 167), 
                                          ),
                                        ),
                                        TextSpan(
                                          text: argument.comments[idx].values.first.toString(),
                                          style:const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54, 
                                          ),
                                        ),
                                      ],
                                        ),
                                       
                                      ), 
                                    );
                                  },
                                ),
                              ],if (argument.comments.isEmpty && _mainModel.state==ViewState.geldi) ...[
                                   const    Divider(),
                                  const  SizedBox(height: 20,),
                                 const   Text("Comments", style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),),
                           const     SizedBox(height: 20,),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child:const Column(
                                  children: [
                                    Icon(Icons.comment,size: 50,),
                                    SizedBox(height: 10,),
                                    Text("No Comments Yet! Do the first to comment",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),),
                                  ],
                                ),
                              )
                              ],
                              if(_mainModel.state!=ViewState.geldi)...[
                             const   Center(child: CircularProgressIndicator(),),
                              ],
                          const    SizedBox(height: 20,),
                                   
                                    TextField(
         controller: _commentController,
            decoration:const InputDecoration(
                focusColor:  Color.fromARGB(255, 34, 126, 167),
                border:  UnderlineInputBorder(),
                hintText: 'Comment',
                hintStyle:  TextStyle(color: Colors.grey),
                ),
               
          ), 
       const   SizedBox(height: 30,),
           GestureDetector(
            onTap: (){
              if(_commentController.text!=""){
                String username=_userModel.user.username;
                _mainModel.yorumYap(username, _commentController.text,argument.id);
                _commentController.text="";
              }
            },
             child: Container(
                     width: double.infinity,
                     height: 40,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 34, 126, 167),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                    ),
                    child:const Padding(
                      padding:
                           EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      child: Center(
                        child: Text('Send Comment',
                            textAlign: TextAlign.center,
                            style:  TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            ),
                      ),
                    ),
                  ),
           ),
       const      SizedBox(height: 20,),
                                  ],
                                ),
                              ),
                              ),
      ),
                            
    );
  }

  String formatHumanReadableDate(DateTime date) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(date);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Dün';
      } else if (difference.inDays < 30) {
        return '${difference.inDays} gün önce';
      } else if (difference.inDays < 365) {
        int months = (difference.inDays / 30).floor();
        return '$months ay önce';
      } else {
        int years = (difference.inDays / 365).floor();
        return '$years yıl önce';
      }
    } else if (difference.inHours > 0) {
      if (difference.inHours == 1) {
        return '1 saat önce';
      } else {
        return '${difference.inHours} saat önce';
      }
    } else if (difference.inMinutes > 0) {
      if (difference.inMinutes == 1) {
        return '1 dakika önce';
      } else {
        return '${difference.inMinutes} dakika önce';
      }
    } else {
      if (difference.inSeconds == 1) {
        return 'Az önce';
      } else {
        return 'Az önce';
      }
    }
  }
 

}