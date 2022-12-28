import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:work_app/src/presentation/pages/requests_accepted_page.dart';
import 'package:work_app/src/presentation/pages/requests_made_page.dart';
import 'package:work_app/src/presentation/pages/requests_page.dart';

import '../cubit/auth/auth_cubit.dart';
import 'chat_page.dart';

class MainPage extends StatefulWidget {
  static String id = 'main_page';
  final String uid;
  const MainPage({Key? key,required this.uid}) : super(key: key);


  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  int AXB = 5;

  static const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  /*List<Widget> _widgetOptions = <Widget>[
    RequestsPage(
      showRequests: () {
        setState(() {
          setState(() {
            _selectedIndex = 2
          });
        });
      },
    ),
    RequestsAcceptedPage(),
    RequestsMadePage(),
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
  void initState() {
    //BlocProvider.of<NoteCubit>(context).getNotes(uid: widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BuscaChamba'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        actions: <Widget>[
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
      //body: _widgetOptions.elementAt(_selectedIndex),
      body: [
        RequestsPage(
        showRequests: () {
          setState(() {
            setState(() {
              _selectedIndex = 2;
            });
          });
        },
      ),
        RequestsAcceptedPage(userId: widget.uid,),
        RequestsMadePage(uid: widget.uid),
        ChatPage(uid : widget.uid, isClient: true),
        /*Text(
          'Index 3: Configuración',
          style: optionStyle,
        )*/][_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Home',
            //backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: 'Solicitudes',
            //backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Propuestas',
            //backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger),
            label: 'Chats',
            //backgroundColor: Colors.purple,
          ),
          /*BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuracion',
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