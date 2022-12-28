import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:work_app/src/presentation/pages/requests_published_page.dart';

import '../cubit/auth/auth_cubit.dart';
import 'chat_page.dart';

class MainProfessionalPage extends StatefulWidget {
  static String id = 'main_page_pro';
  final String uid;
  const MainProfessionalPage({Key? key,required this.uid}) : super(key: key);

  @override
  _MainProfessionalPageState createState() => _MainProfessionalPageState();
}

class _MainProfessionalPageState extends State<MainProfessionalPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  /*static List<Widget> _widgetOptions = <Widget>[
    Text(
      'Perfil de professional',
      style: optionStyle,
    ),
    RequestsPublishedPage(),
    Text(
      'Index 3: Configuración',
      style: optionStyle,
    ),
  ];*/

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FoundJob'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        actions: [
          TextButton(
            style: ButtonStyle(
              //backgroundColor: MaterialStatePropertyAll<Color>(Colors.red),
            ),

            onPressed: () {
              BlocProvider.of<AuthCubit>(context).loggedOut();
            },
            child: const Text('Cerrar sesión', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),),
          ),
        ],
      ),
      body: <Widget>[
        /*Text(
          'Perfil de professional',
          style: optionStyle,
        ),*/
        RequestsPublishedPage(widget.uid),
        ChatPage(uid : widget.uid, isClient: false),
        /*Text(
          'Index 3: Configuración',
          style: optionStyle,
        )*/
      ][_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          /*BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
            //backgroundColor: Colors.red,
          ),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: 'Solicitudes',
            //backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger),
            label: 'Chats',
            //backgroundColor: Colors.purple,
          ),
          /*BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuracion',
            //backgroundColor: Colors.purple,
          ),*/
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        //backgroundColor: Colors.yellow,

      ),
    );
  }
}