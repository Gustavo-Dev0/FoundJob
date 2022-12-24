import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../domain/entities/user_entity.dart';
import '../cubit/auth/auth_cubit.dart';
import '../cubit/user/user_cubit.dart';
import 'main_page.dart';
import 'main_page_professional.dart';

class RegisterPage extends StatefulWidget {
  static String id = 'login_page';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isProfessional = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
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
                    if(authState.profile.role == "cliente")
                      return MainPage(uid: authState.uid);
                    return MainProfessionalPage();
                  }else{
                    /*Fluttertoast.showToast(
                        msg: "Usuario no autenticado",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );*/
                    return _bodyWidget();
                  }
                });
              }
                return _bodyWidget();
              },
              listener: (context,userState){
                if (userState is UserSuccess){
                  BlocProvider.of<AuthCubit>(context).loggedIn();
                  Fluttertoast.showToast(
                      msg: "Usuario registrado",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
                if (userState is UserFailure){
                  //snackBarError(msg: "invalid email",scaffoldState: _scaffoldGlobalKey);
                  Fluttertoast.showToast(
                      msg: "error",
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

  _bodyWidget(){
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 80.0),
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
            SizedBox(height: 15.0),
            Image.asset('assets/images/logo.png', height: 140),
            SizedBox(height: 15.0),
            SizedBox(
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
                initialLabelIndex: _isProfessional ? 1 : 0,
                totalSwitches: 2,
                labels: ['Busco ayuda', 'Soy profesional'],
                radiusStyle: true,
                onToggle: (index) {
                  setState(() => _isProfessional = !_isProfessional);
                },
              ),
            ),
            const SizedBox(height: 15.0),
            const SizedBox(height: 15.0),
            _nameTextField(),
            const SizedBox(height: 15.0),
            _userTextField(),
            const SizedBox(height: 15.0),
            _passwordTextField(),
            const SizedBox(height: 20.0),
            _buttonRegister(),
            const SizedBox(height: 20.0),
            Row(
                children: const [
                  Expanded(
                      child: Divider(
                          thickness: 2,
                          color: Colors.black,
                          indent: 40
                      )
                  ),
                  Text("   O   "),
                  Expanded(
                      child: Divider(
                          thickness: 2,
                          color: Colors.black,
                          endIndent: 40
                      )
                  ),
                ]
            ),
            const SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Continuar con Google. ', textAlign: TextAlign.right, ),
              ],
            ),

          ],
        ),
      ),
    );
  }


  Widget _nameTextField() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Nombres', textAlign: TextAlign.left, textScaleFactor: 1.2,),
                SizedBox(height: 8.0),
                TextField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Nombres',
                    //labelText: "Correo",
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(40.0),
                      ),
                    ),
                  ),
                  controller: _nameController,
                ),

              ],
            ));
      },
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
                Text('Correo Electrónico', textAlign: TextAlign.left, textScaleFactor: 1.2,),
                SizedBox(height: 8.0),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    prefixIcon: Icon(Icons.email),
                    hintText: 'ejemplo@com.com',
                    //labelText: "Correo",
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
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
              Text('Contraseña', textAlign: TextAlign.left, textScaleFactor: 1.2,),
              SizedBox(height: 8.0),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: Icon(Icons.remove_red_eye_sharp),
                    hintText: 'Contraseña',
                    //labelText: "Contraseña"
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(40.0),
                      ),
                    ),
                ),
                controller: _passwordController,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buttonRegister() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ElevatedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
            child: Text('Registrarme', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          ),
          style: ElevatedButton.styleFrom(
            //padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),
            backgroundColor: Colors.orange,
          ),
          onPressed: () {
            submitSignUp();
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );*/
          },
        );
      },
    );
  }

  Future<void> submitSignUp() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      await BlocProvider.of<UserCubit>(context).submitSignUp(user: UserEntity(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: _isProfessional ? "trabajador" : "cliente" ,
      ));


    }
  }
}
