import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:social_media_feeds/models/post.dart';
import 'package:social_media_feeds/pages/home_page.dart';

class Cards extends StatefulWidget {
  final String tarih;
  final Post post;
  const Cards({super.key,required this.post,required this.tarih });

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  final CarouselController _carouselController = CarouselController();
   int _current = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, "/postdetail",
                      arguments: widget.post);
      },
      child: DoubleTapLike(
                          post: widget.post,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(15),
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.post.imageUrl.isNotEmpty)
                               Visibility(
        visible: true,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: widget.post.imageUrl.length == 1
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                      base64.decode(widget.post.imageUrl[0].split(',')[1]),
                      fit: BoxFit.contain,
                    ),
                  )
                : widget.post.imageUrl.isEmpty
                    ? const SizedBox.shrink()
                    : Column(
                        children: [
                          CarouselSlider(
                            items: widget.post.imageUrl.map((img) {
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
                            children: widget.post.imageUrl.map((url) {
                              int index = widget.post.imageUrl.indexOf(url);
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin:const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _current == index
                                      ? const Color.fromARGB(255, 34, 126, 167)
                                      : const Color.fromRGBO(0, 0, 0, 0.4),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
          ),
        ),
      ),
                              const  SizedBox(height: 15),
                                
                               Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Expanded(
      child: Text(
        widget.post.headerText,
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
      widget.post.likes.length.toString(),
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
      widget.post.comments.length.toString(),
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),
  ],
)
,
                             const   SizedBox(height: 10),
                               RichText(
        text: TextSpan(
      children: [
        TextSpan(
          text: "${widget.post.author}: ",
          style:const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 34, 126, 167), 
          ),
        ),
        TextSpan(
          text: widget.post.bodyText,
          style:const TextStyle(
            fontSize: 16,
            color: Colors.black54, 
          ),
        ),
      ],
        ),
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
      
                               const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                   widget. tarih,
                                    textAlign: TextAlign.end,
                                    style:const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
    );
  }
}