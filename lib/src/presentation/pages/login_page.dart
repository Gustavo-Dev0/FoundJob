import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:toggle_switch/toggle_switch.dart';
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
                    /*if(authState.profile.status == "trabajador"){
                      return MainProfessionalPage();
                    }else{*/
                    //String role = "wefwefwefwefwefwefwefwefwefwef";
                    //BlocProvider.of<ProfileCubit>(context).getCurrentUserInfoDirect().then((value) {
                     // role = value.role!;
                      //Logger().wtf("ESto debe ser primero");
                    //});
                    //Logger().wtf(role);
                    //return _bodyWidget();
                    if(authState.profile.role == "cliente")
                      return MainPage(uid: authState.uid);
                    return MainProfessionalPage();
                    /*}*/
                    return _bodyWidget();

                  }else{
                    return _bodyWidget();
                  }
                });
              }
              return _bodyWidget();
            },
            listener: (context,userState){
              if (userState is UserSuccess){

                //Logger().wtf(userState.props.isEmpty);


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
                //snackBarError(msg: "invalid email",scaffoldState: _scaffoldGlobalKey);
                /*Fluttertoast.showToast(
                    msg: "invalid email",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*/
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
          onPressed: () {
            submitSignIn();
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
  Widget _buttonLogin2() {
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
          onPressed: () {
            BlocProvider.of<AuthCubit>(context).loggedOut();
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainProfessionalPage()),
            );*/
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
            child: const Text('Ingresar Profesional', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          ),
        );
      },
    );
  }


  void submitSignIn() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      BlocProvider.of<UserCubit>(context).submitSignIn(user: UserEntity(
        email: _emailController.text,
        password: _passwordController.text,
      ));

    }
  }
}
