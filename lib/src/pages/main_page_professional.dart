import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:work_app/src/pages/register_page.dart';
import 'package:work_app/src/pages/requests_accepted_page.dart';
import 'package:work_app/src/pages/requests_made_page.dart';
import 'package:work_app/src/pages/requests_page.dart';
import 'package:work_app/src/pages/requests_published_page.dart';

class MainProfessionalPage extends StatefulWidget {
  static String id = 'login_page';

  @override
  _MainProfessionalPageState createState() => _MainProfessionalPageState();
}

class _MainProfessionalPageState extends State<MainProfessionalPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Text(
      'Perfil de professional',
      style: optionStyle,
    ),
    RequestsPublishedPage(),
    Text(
      'Index 3: Configuración',
      style: optionStyle,
    ),
  ];

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
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
            //backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: 'Solicitudes',
            //backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuracion',
            //backgroundColor: Colors.purple,
          ),
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