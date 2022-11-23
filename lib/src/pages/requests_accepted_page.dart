import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'main_page.dart';

class RequestsAcceptedPage extends StatefulWidget {
  static String id = 'requests_page';

  @override
  _RequestsAcceptedPageState createState() => _RequestsAcceptedPageState();
}

class _RequestsAcceptedPageState extends State<RequestsAcceptedPage> {
  late List<Professional> listRequestsJob;
  @override
  Widget build(BuildContext context) {
    listRequestsJob = [
      Professional("I", "1000", "Cusco - Perú", "Juan Quispe", "956324152"),
      Professional("B", "1050", "Cusco - Perú", "Mario Paredes", "948561234"),
      Professional("N", "2000", "Cusco - Perú", "Luis García", "987456123"),
    ];
    return SafeArea(
        child: Scaffold(
          //backgroundColor: Colors.red,
          body: Column(
            children:[ SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  Text("Solicitudes aceptadas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                  const SizedBox(height: 8.0),
                  Text("Personas que aceptaron ayudarte", style: TextStyle(fontSize: 12.0)),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Disponibilidad: ", style: TextStyle(fontSize: 10.0)),
                      Icon(Icons.circle, color: Colors.green,),
                      Text("Inmediata", style: TextStyle(fontSize: 10.0)),
                      Icon(Icons.circle, color: Colors.yellow,),
                      Text("Baja", style: TextStyle(fontSize: 10.0)),
                      Icon(Icons.circle, color: Colors.red,),
                      Text("Negociable", style: TextStyle(fontSize: 10.0)),
                    ],
                  ),

                  const SizedBox(height: 20.0),
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: listRequestsJob.length,
                      itemBuilder: (context, index) {
                        return CardProfessional(listRequestsJob[index]);
                      }
                      ),
                ],
              ),
            )],
          ),
        ));
  }


}

class CardProfessional extends StatefulWidget {
  final Professional itemP;

  const CardProfessional(this.itemP, {super.key});
  //const CardRequest({Key? key}) : super(key: key);

  @override
  State<CardProfessional> createState() => _CardProfessionalState();
}

class _CardProfessionalState extends State<CardProfessional> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20,10,20,0),
      height: 160,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        color: Color(0xffF3E8D7),
        child: Column(
          children: [
            Expanded(
                child: Row(
                  children: [
                    Expanded(
                        flex: 1, // 20%
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(

                                children: [
                                  Container(
                                    child: CircleAvatar(
                                        radius: 30.0,
                                        backgroundImage: AssetImage('assets/images/logo.png'),
                                        backgroundColor: Colors.transparent,
                                    ),
                                    margin: EdgeInsets.all(8.0),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: _buildState()
                                  )
                                ],
                              ),
                              Text(widget.itemP.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                              Text(widget.itemP.ubication),
                            ],
                          )
                        ),
                      ),
                    Expanded(
                        flex: 1,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("S/. "+widget.itemP.price, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.green), ),
                                      Text(widget.itemP.telephone),
                                      ElevatedButton(
                                        child: Text('Contactar', style: TextStyle(fontWeight: FontWeight.bold),),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0)
                                          ),
                                          backgroundColor: Colors.orange,
                                        ),
                                        onPressed: () {
                                          Fluttertoast.showToast(
                                              msg: "Click",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                        },
                                      )
                                    ],
                                  )
                                  ,)
                              ],
                            )
                        )
                    ),
                  ],
                ),
            ),
          ],
        )
      ),

    );

  }

  Widget _buildState(){
    if (widget.itemP.type == "I") {
      return Icon(Icons.circle, color: Colors.green,);
    }

    if (widget.itemP.type == "B") {
      return Icon(Icons.circle, color: Colors.yellow,);
    }

    return Icon(Icons.circle, color: Colors.red,);
  }
}

class Professional {
  String type = "-";
  String price = "-";
  String ubication = "-";
  String name = "-";
  String telephone = "-";

  Professional(this.type, this.price, this.ubication, this.name, this.telephone);
}


