// ignore_for_file: no_leading_underscores_for_local_identifiers, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_feeds/cards.dart';
import 'package:social_media_feeds/models/post.dart';
import 'package:social_media_feeds/viewmodels/main_viewmodel.dart';
import 'package:social_media_feeds/viewmodels/user_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  bool isFabVisible = false;

  @override
  void initState() {
    super.initState();
    var _mainModel = Provider.of<MainViewModel>(context, listen: false);
    _mainModel.getPosts();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent > 0 &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.9 &&
          _mainModel.finish == false) {
        setState(() {
          isLoading = true;
        });

        _mainModel.getMorePosts(_mainModel.posts).then((_) {
          setState(() {
            isLoading = false;
          });
        });
      }
      
      if (_scrollController.position.pixels > 100) {
        if (!isFabVisible) {
          setState(() {
            isFabVisible = true;
          });
        }
      } else {
        if (isFabVisible) {
          setState(() {
            isFabVisible = false;
          });
        }
      }
    });
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
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 215, 237, 255),
      appBar: AppBar(title:  const Text('Social Media Feed'),centerTitle: true,actions: [PopupMenuButton<String>(
            icon:const Icon(Icons.more_vert),
            onSelected: _handleMenuItem,
            itemBuilder: (BuildContext context) {
              return [
            const    PopupMenuItem<String>(
                  value: 'add_feed',
                  child: Text('Add Post'),
                ),
             const   PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ];
            },
          ),],),
      floatingActionButton: AnimatedOpacity(
        duration:const Duration(milliseconds: 500),
        opacity: isFabVisible ? 1.0 : 0.0,
        child: Visibility(
          visible: isFabVisible,
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
            mini: true,
            onPressed: () {
              _scrollController.animateTo(
                0,
                duration:const Duration(milliseconds: 1000),
                curve: Curves.ease,
              );
            },
            backgroundColor: const Color.fromARGB(255, 150, 224, 255),
            child:const Icon(Icons.keyboard_arrow_up, color: Colors.white),
          ),
        ),
      ),
      body: _mainModel.state == ViewState.geldi && _mainModel.posts.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _mainModel.posts.length,
                    itemBuilder: (context, index) {
                      Post post = _mainModel.posts[index];
                      String tarih = formatHumanReadableDate(DateTime.parse(post.date));
                      return Cards( post: post, tarih: tarih,);
                    },
                  ),
                ),
                Visibility(
                  visible: isLoading,
                  child:const SizedBox(height: 7.5),
                ),
                Visibility(
                  visible: isLoading,
                  child:const Center(child: CircularProgressIndicator()),
                ),
                Visibility(
                  visible: isLoading,
                  child:const SizedBox(height: 7.5),
                ),
              ],
            )
          :const  Center(child: CircularProgressIndicator()),
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


class DoubleTapLike extends StatefulWidget {
  final Widget child;
  final Post post;

  const DoubleTapLike({super.key, required this.child,required this.post});

  @override
  _DoubleTapLikeState createState() => _DoubleTapLikeState();
}

class _DoubleTapLikeState extends State<DoubleTapLike>
    with SingleTickerProviderStateMixin {
  bool _isLiked = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  void _handleDoubleTap() {
    setState(() {
              var _userModel = Provider.of<UserViewModel>(context, listen: false);
      _isLiked = true;
      if(widget.post.likes.contains(_userModel.user.username)){
      }else{
        var _mainModel = Provider.of<MainViewModel>(context, listen: false);

        _mainModel.begeniEkle(widget.post.id, _userModel.user.username);
      }
    });
    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _controller.reverse().then((_) {
          setState(() {
            _isLiked = false;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _handleDoubleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget.child,
          if (_isLiked)
            ScaleTransition(
              scale: _animation,
              child: ShaderMask(
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
                  size: 100,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
