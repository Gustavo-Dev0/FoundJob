import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'main_page.dart';

class RegisterPage extends StatefulWidget {
  static String id = 'login_page';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          //backgroundColor: Colors.red,
      body: Center(
        child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.0),
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
                initialLabelIndex: 1,
                totalSwitches: 2,
                labels: ['Busco ayuda', 'Soy profesional'],
                radiusStyle: true,
                onToggle: (index) {
                  print('switched to: $index');
                },
              ),
            ),
            SizedBox(height: 15.0),
            _nameTextField(),
            SizedBox(height: 15.0),
            _userTextField(),
            SizedBox(height: 15.0),
            _passwordTextField(),
            SizedBox(height: 20.0),
            _buttonRegister(),
            const SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Continuar con Google. ', textAlign: TextAlign.right, ),

              ],

            ),

          ],
        ),
        ),
      ),
    ));
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
                    hintText: 'ejemplo@com.com',
                    //labelText: "Correo",
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
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
                onChanged: (value) {},
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          },
        );
      },
    );
  }
}
