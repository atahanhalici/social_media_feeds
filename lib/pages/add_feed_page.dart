
// ignore_for_file: use_build_context_synchronously, unnecessary_nullable_for_final_variable_declarations, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:social_media_feeds/viewmodels/main_viewmodel.dart';
import 'package:social_media_feeds/viewmodels/user_viewmodel.dart';

class AddFeedPage extends StatefulWidget {
  const AddFeedPage({super.key});

  @override
  State<AddFeedPage> createState() => _AddFeedPageState();
}

class _AddFeedPageState extends State<AddFeedPage> {
 
  final TextEditingController _headerController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();



  final ImagePicker _picker = ImagePicker();
  final List<File> _images = [];

 Future<void> _pickImageFromGallery() async {
    if (_images.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
     const   SnackBar(
          content: Text('You can select up to 3 images only.'),
        ),
      );
      return;
    }

    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      if (pickedFiles.length + _images.length > 3) {
        ScaffoldMessenger.of(context).showSnackBar(
       const   SnackBar(
            content: Text('You can select up to 3 images only.'),
          ),
        );
        return;
      }
      setState(() {
        _images.addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)).toList());
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      if (_images.length < 3) {
        setState(() {
          _images.add(File(pickedFile.path));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
    const      SnackBar(
            content: Text('You can select up to 3 images only.'),
          ),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }



    void _showBottomSheet(BuildContext context) {

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
              child: SizedBox(
                height: 125,
                child: Column(
                  children: [
                  const  SizedBox(height: 10,),
                    ListTile(
                      leading:const Icon(Icons.photo_camera),
                      title:const Text("Use the camera"),
                      onTap: (){
                       Navigator.of(context).pop();
                       if(_images.length<3){
 _pickImageFromCamera();
                       }
                       },
                    ),
                     ListTile(
                      leading: const Icon(Icons.image),
                      title: const Text("Choose from gallery"),
                      onTap: (){
                        Navigator.of(context).pop();
                        if(_images.length<3){
_pickImageFromGallery();
                        }
                        },
                    ),
                  ],
                ),
              )
            ),
          );
        });
      },
    );
  }
     void _handleMenuItem(String value) {
    switch (value) {
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

    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 215, 237, 255),
      appBar: AppBar(title:const Text("Add Post"),centerTitle: true,actions: [PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: _handleMenuItem,
            itemBuilder: (BuildContext context) {
              return [
               
            const    PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ];
            },
          ),],),

      body: Container( width: MediaQuery.of(context).size.width,
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
                                  Visibility(
                                    visible: _images.length<3,
                                    child: GestureDetector(
                                      onTap: ()=>_showBottomSheet(context),
                                      child: Container(
                                        decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(20)),
                                        width: double.infinity,
                                        padding:const EdgeInsets.all(20),
                                        child: const Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.ads_click,size: 60,),
                                          Text("Click to choose picture (Optional)", textAlign: TextAlign.center ,style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),),
                                        ],
                                      ),)),
                                  ),
                                    _images.isEmpty
                ?const  Padding(
                  padding:  EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text('No images selected.',textAlign: TextAlign.center,style: TextStyle(fontSize: 17),)),
                )
                : Column(
                  children: [
                  const  SizedBox(height: 15,),
                   const Text("Selected Photos",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                        children: _images.asMap().entries.map((entry) {
                          int index = entry.key;
                          File image = entry.value;
                          return GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(image, width: 100, height: 100),
                            ),
                          );
                        }).toList(),
                      ),
                 const     SizedBox(
                        width: double.infinity,
                        child: Text('Click on the photo to remove it',textAlign: TextAlign.center,style: TextStyle(fontSize: 14),))
                  ],
                ),

             const   SizedBox(height: 50,),
  const   Text('Header Text',
              style:  TextStyle(
                    
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
          TextField(
         controller: _headerController,
            decoration:const InputDecoration(
                focusColor:  Color.fromARGB(255, 34, 126, 167),
                border:  UnderlineInputBorder(),
                hintText: 'Header Text',
                
                ),
               
          ),
          const SizedBox(
            height: 30,
          ),
  const   Text('Body Text',
              style:  TextStyle(
                    
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
          TextField(
         controller: _bodyController,
            decoration:const InputDecoration(
                focusColor:  Color.fromARGB(255, 34, 126, 167),
                border:  UnderlineInputBorder(),
                hintText: 'Body Text',
                
                ),
               maxLines :5
          ),
        const SizedBox(
            height: 30,
          ),
           GestureDetector(
            onTap: (){
              _processData(_mainModel, _userModel);
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
                          child: Text('Send Post',
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

                                ],
                              ),
                            ),
                            ),
                            
    );
  }

 /*void _processData(MainViewModel _mainModel, UserViewModel _userModel) async {
  if (_headerController.text.isEmpty || _bodyController.text.isEmpty) {
    _showAlertDialog('Uyarı', 'Header ve Body boş olamaz!');
  } else {
    List<String> base64Images = [];
    for (var image in _images) {
      Uint8List bytes = await image.readAsBytes();
      String base64Image = base64Encode(bytes);
      base64Images.add("data:image/png;base64,$base64Image");
    }
    
    _mainModel.sendPost(_headerController.text,_bodyController.text,base64Images,_userModel.user.username);
     Navigator.pushNamedAndRemoveUntil(
          context,
          '/homepage',
          (Route<dynamic> route) => false,
        );
  }
}*/

void _processData(MainViewModel _mainModel, UserViewModel _userModel) async {
  if (_headerController.text.isEmpty || _bodyController.text.isEmpty) {
    _showAlertDialog('Warning', 'Header and Body cannot be empty!');
  } else {
    List<String> imagePaths = [];
    for (var image in _images) {
      final appDir = await getApplicationDocumentsDirectory();
      String fileName = image.path.split('/').last; // Dosya adını alalım
      String newPath = '${appDir.path}/$fileName';

      // Dosyayı uygulamanın özel klasörüne kopyalayalım
      await image.copy(newPath);
      
      // Yeni yolunu listeye ekleyelim
      imagePaths.add(newPath);
    }
    
    _mainModel.sendPost(_headerController.text, _bodyController.text, imagePaths, _userModel.user.username);
    
    // Ana sayfaya yönlendirme
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/homepage',
      (Route<dynamic> route) => false,
    );
  }
}

void _showAlertDialog(String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(message)),
        actions: <Widget>[
          TextButton(
            child:const Text('Okey'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


}