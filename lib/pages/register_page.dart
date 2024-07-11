
// ignore_for_file: unused_element, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, non_constant_identifier_names, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_media_feeds/models/user.dart';
import 'package:social_media_feeds/viewmodels/user_viewmodel.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _gizli = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController=TextEditingController();
      final Box<User> userBox = Hive.box<User>('users');


   void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:const Text('Error'),
          content: Text(message),
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

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:const Text('Successful'),
          content: Text(message),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/login_background.jpg'),
            fit: BoxFit.cover,
          )),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height < 700
                        ? 50
                        : MediaQuery.of(context).size.height < 800
                            ? 150
                            : MediaQuery.of(context).size.height < 900
                                ? 250
                                : MediaQuery.of(context).size.height < 1000
                                    ? 350
                                    : MediaQuery.of(context).size.height <
                                            1100
                                        ? 450
                                        : MediaQuery.of(context).size.height <
                                                1200
                                            ? 550
                                            : 650,
                    left: 50,
                  ),
                  child: const Text('Register',
                      style:  TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    right: 0,
                    bottom: 20,
                    left: 20,
                  ),
                  child: LayerOne(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  // ignore: non_constant_identifier_names
  Widget LayerThree(BuildContext context) {
  UserViewModel _userModel =
        Provider.of<UserViewModel>(context, listen: true);

    const Color hintText = Color(0xFFB4B4B4);

    return Container(
      height: 500,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(
        left: 30,
        right: 30,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        const  SizedBox(height: 20,)
,            const   Text('Username',
              style:  TextStyle(
                    
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
          TextField(
         controller: _usernameController,
            decoration:const InputDecoration(
                focusColor:  Color.fromARGB(255, 34, 126, 167),
                border:  UnderlineInputBorder(),
                hintText: 'Username',
                hintStyle:  TextStyle(color: hintText),
                ),
               
          ),
          const SizedBox(
            height: 20,
          ),
       const   Text('E-Mail',
              style:  TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
          TextField(
         controller: _emailController,
            decoration:const InputDecoration(
                focusColor:  Color.fromARGB(255, 34, 126, 167),
                border:  UnderlineInputBorder(),
                hintText: 'E-Mail',
                hintStyle:  TextStyle(color: hintText),
                ),
                keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 20,
          ),
        const  Text('Password',
              style:  TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
          TextField(
            obscureText: _gizli,
             controller: _passwordController,
            decoration: InputDecoration(
              focusColor: const Color.fromARGB(255, 34, 126, 167),
              border: const UnderlineInputBorder(),
              hintText: 'Password',
              hintStyle:  const TextStyle(color: hintText),
              
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _gizli = !_gizli;
                    });
                  },
                  icon: !_gizli
                      ? const Icon(Icons.visibility, color: Colors.grey)
                      : const Icon(Icons.visibility_off, color: Colors.grey)),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
         
        
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
             
              GestureDetector(
              onTap: ()async{
                  String email = _emailController.text;
    String password = _passwordController.text;
    String username=_usernameController.text;

    if(email!=""&&password!=""&&username!=""){
     var sonuc=  await _userModel.signUp(email,password,username);
       if(sonuc==true){
  Navigator.pushNamedAndRemoveUntil(
                                      context, "/homepage", (route) => false);
       }else{
        _showErrorDialog(_userModel.metin);
       }
    }else{
      _showErrorDialog("Not All Fields Filled!");
    }
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 34, 126, 167),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child:const Padding(
                    padding:
                         EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: Text('Register',
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                  ),
                ),
              ),
            ],
          ),
       const   SizedBox(height: 30,),
    GestureDetector(
      onTap:(){
        Navigator.pop(context);
      },
      child: const  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Already Have an Account?',
                              textAlign: TextAlign.center,
                              style:  TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                               Text(' Login Now!',
                              textAlign: TextAlign.center,
                              style:  TextStyle(
                                    color: Color.fromARGB(255, 34, 126, 167),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
          ],
        ),
    ),
        ],
      ),
    );
  }

  Widget LayerOne(BuildContext context) {
    const Color layerOneBg = Color(0x80FFFFFF);
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: layerOneBg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60.0),
          bottomLeft: Radius.circular(60.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 30, left: 30),
        child: LayerTwo(context),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget LayerTwo(BuildContext context) {
    const Color layerTwoBg = Color.fromARGB(255, 233, 254, 255);
    return Container(
      width: 399,
      decoration: const BoxDecoration(
        color: layerTwoBg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60.0),
          bottomLeft: Radius.circular(60.0),
        ),
      ),
      child: LayerThree(context),
    );
  }
}