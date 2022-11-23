import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:work_app/src/pages/main_page_professional.dart';
import 'package:work_app/src/pages/register_page.dart';

import 'main_page.dart';

class LoginPage extends StatefulWidget {
  static String id = 'login_page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          //backgroundColor: Colors.red,
      body: Center(
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
                initialLabelIndex: 1,
                totalSwitches: 2,
                labels: ['Busco ayuda', 'Soy profesional'],
                radiusStyle: true,
                onToggle: (index) {
                  print('switched to: $index');
                },
              ),
            ),
            const SizedBox(height: 15.0),
            _userTextField(),
            const SizedBox(height: 15.0),
            _passwordTextField(),
            const SizedBox(height: 20.0),
            _buttonLogin(),
            _buttonLogin2(),
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
      ),
    ));
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
                  onChanged: (value) {},
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
                onChanged: (value) {},
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
            child: const Text('Ingresar Cliente', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainProfessionalPage()),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
            child: const Text('Ingresar Profesional', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          ),
        );
      },
    );
  }
}
