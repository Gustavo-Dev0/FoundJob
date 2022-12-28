import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:work_app/src/presentation/pages/register_google_page.dart';
import 'package:work_app/src/presentation/pages/register_page.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/use_cases/get_current_user_info_usecase.dart';
import '../cubit/auth/auth_cubit.dart';
import '../cubit/profile/profile_cubit.dart';
import '../cubit/user/user_cubit.dart';
import 'main_page.dart';
import 'main_page_professional.dart';

class LoginPage extends StatefulWidget {
  static String id = 'login_page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          //backgroundColor: Colors.red,
          body: BlocConsumer<UserCubit, UserState>(
            builder: (context, userState){
              if (userState is UserSuccess){
                return BlocBuilder<AuthCubit,AuthState>(builder:(context,authState){

                  if (authState is Authenticated){
                    if(authState.profile.role == "cliente") {
                      Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => MainPage(uid: authState.uid),
                        ),
                      );

                      return MainPage(uid: authState.uid);
                    }
                    Navigator.pushReplacement<void, void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => MainProfessionalPage(uid: authState.uid)
                      ),
                    );
                    return MainProfessionalPage(uid: authState.uid);

                  }
                  if (authState is AuthenticatedWithoutRegister){
                    Navigator.pushReplacement<void, void>(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => RegisterGooglePage()
                      ),
                    );
                    return RegisterGooglePage();
                  }
                  if (authState is UnAuthenticated){
                    return _bodyWidget();
                  }

                  return _bodyWidget();


                });
              }
              return _bodyWidget();
            },
            listener: (context,userState){
              if (userState is UserSuccess){
                BlocProvider.of<AuthCubit>(context).loggedIn();
                /*Fluttertoast.showToast(
                    msg: "Usuario logueado",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*/
              }
              if (userState is UserFailure){

                Fluttertoast.showToast(
                    msg: userState.error,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
            },
          )

    ));
  }

  _bodyWidget() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 80.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.orange,
                ),
                height: 50,
                child: const Text(
                  'FoundJob',
                  textScaleFactor: 2,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 15.0),
            Image.asset('assets/images/logo.png'),
            const SizedBox(height: 15.0),
            /*SizedBox(
              height: 40,
              child: ToggleSwitch(
                minWidth: 160.0,
                cornerRadius: 20.0,
                activeBgColors: const [
                  [Colors.orange],
                  [Colors.orange]
                ],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                initialLabelIndex: 1,
                totalSwitches: 2,
                labels: ['Busco ayuda', 'Soy profesional'],
                radiusStyle: true,
                onToggle: (index) {
                  print('switched to: $index');
                },
              ),
            ),
            const SizedBox(height: 15.0),*/
            _userTextField(),
            const SizedBox(height: 15.0),
            _passwordTextField(),
            const SizedBox(height: 20.0),
            _buttonLogin(),
            const SizedBox(height: 15.0),
            _googleLogin(),
            const SizedBox(height: 10.0),
            _facebookLogin(),
            //_buttonLogin2(),
            const SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No cuento con una cuenta. ', textAlign: TextAlign.right, ),
                TextButton(

                  child: const Text('Registrarme', textAlign: TextAlign.right, style: TextStyle(decoration: TextDecoration.underline, color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                ),
              ],

            ),

          ],
        ),
      ),
    );
  }

  Widget _userTextField() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Correo Electrónico', textAlign: TextAlign.left, textScaleFactor: 1.2,),
                const SizedBox(height: 8.0),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    prefixIcon: Icon(Icons.email),
                    hintText: 'ejemplo@com.com',
                    //labelText: "Correo",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(40.0),
                      ),
                    ),
                  ),
                  controller: _emailController,
                ),

              ],
            ));
      },
    );
  }

  Widget _passwordTextField() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Contraseña', textAlign: TextAlign.left, textScaleFactor: 1.2,),
              const SizedBox(height: 8.0),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: Icon(Icons.remove_red_eye_sharp),
                    hintText: 'Contraseña',
                    //labelText: "Contraseña"
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(40.0),
                      ),
                    ),
                ),
                controller: _passwordController,
              ),
              const SizedBox(height: 8.0),
              const Text('Olvidé mi contraseña', textAlign: TextAlign.right, style: TextStyle(decoration: TextDecoration.underline,),),
            ],
          ),
        );
      },
    );
  }

  Widget _buttonLogin() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            //padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),
            backgroundColor: Colors.orange,
          ),
          onPressed: () async {
            await submitSignIn();
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );*/
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
            child: const Text('Ingresar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          ),
        );
      },
    );
  }

  Widget _googleLogin() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            //padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),
            backgroundColor: Colors.white70,
          ),
          onPressed: () async {
            await submitGoogleSignIn();
          },
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
            child: const Text('Continuar con Google', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),),
          ), icon: Image.network(
            'http://pngimg.com/uploads/google/google_PNG19635.png',
            fit:BoxFit.cover,height: 25,
        ) ,

        );
      },
    );
  }
  Widget _facebookLogin() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            //padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),
            backgroundColor: Colors.lightBlueAccent,
          ),
          onPressed: () async {
            await submitFacebookSign();
          },
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
            child: const Text('Continuar con Facebook', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),),
          ), icon: Image.network(
          'https://cdn.iconscout.com/icon/free/png-256/facebook-logo-2019-1597680-1350125.png',
          fit:BoxFit.cover,height: 25,
        ) ,

        );
      },
    );
  }

  Future<void> submitSignIn() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      await BlocProvider.of<UserCubit>(context).submitSignIn(user: UserEntity(
        email: _emailController.text,
        password: _passwordController.text,
      ));
    }
  }

  Future<void> submitGoogleSignIn() async {

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    var uC = await FirebaseAuth.instance.signInWithCredential(credential);
    try{
      if (true) {
        await BlocProvider.of<UserCubit>(context).submitGoogleSignIn();
        await BlocProvider.of<AuthCubit>(context).appStarted();
      }

    }catch(e){
      Logger().wtf(e.toString());
    }
  }

  Future<void> submitFacebookSign() async {
    // Trigger the sign-in flow
    try{
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if(loginResult.status == LoginStatus.success){
        print(loginResult.accessToken);
      }else{
        print(loginResult.status);
        print(loginResult.message);
      }
      /*final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
      var uC = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      try{
        if (true) {
          await BlocProvider.of<UserCubit>(context).submitFacebookSignIn();
          await BlocProvider.of<AuthCubit>(context).appStarted();
        }

      }catch(e){
        Logger().wtf(e.toString());
      }*/

      // Create a credential from the access token
      /*final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      var f = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);*/
    } catch(_){

    }

  }
}
