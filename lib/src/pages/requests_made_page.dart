import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'main_page.dart';

class RequestsMadePage extends StatefulWidget {
  static String id = 'requests_page';

  @override
  _RequestsMadePageState createState() => _RequestsMadePageState();
}

final List<RequestJob> list2 = {
  RequestJob("C", "15/10/20", "Cusco - Perú", "Albañil"),
  RequestJob("A", "16/10/20", "Cusco - Perú", "Pintor"),
  RequestJob("P", "17/10/20", "Cusco - Perú", "Gasfitero"),
  RequestJob("A", "20/10/20", "Cusco - Perú", "Albañil"),

} as List<RequestJob>;

class _RequestsMadePageState extends State<RequestsMadePage> {
  late List<RequestJob> listRequestsJob;
  @override
  Widget build(BuildContext context) {
    listRequestsJob = [
      RequestJob("C", "15/10/20", "Cusco - Perú", "Albañil"),
      RequestJob("A", "16/10/20", "Cusco - Perú", "Pintor"),
      RequestJob("P", "17/10/20", "Cusco - Perú", "Gasfitero"),
      RequestJob("A", "20/10/20", "Cusco - Perú", "Albañil")
    ];
    return SafeArea(
        child: Scaffold(
          //backgroundColor: Colors.red,
          body: Column(
            children: [SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  Text("Solicitudes realizadas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                  const SizedBox(height: 8.0),
                  Text("Personas que solicitaste", style: TextStyle(fontSize: 12.0)),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Disponibilidad: ", style: TextStyle(fontSize: 10.0)),
                      Icon(Icons.circle, color: Colors.green,),
                      Text("Atendido", style: TextStyle(fontSize: 10.0)),
                      Icon(Icons.circle, color: Colors.yellow,),
                      Text("Pendiente", style: TextStyle(fontSize: 10.0)),
                      Icon(Icons.circle, color: Colors.red,),
                      Text("Cancelado", style: TextStyle(fontSize: 10.0)),
                    ],
                  ),

                  const SizedBox(height: 20.0),
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: listRequestsJob.length,
                      itemBuilder: (context, index) {
                        return CardRequest(listRequestsJob[index]);
                      }
                      ),
                ],
              ),
            )],
          ),
        ));
  }


}

const List<String> list = <String>['Profesor', 'Carpinero', 'Pintor'];

class CardRequest extends StatefulWidget {
  final RequestJob itemRJ;

  const CardRequest(this.itemRJ, {super.key});
  //const CardRequest({Key? key}) : super(key: key);

  @override
  State<CardRequest> createState() => _CardRequestState();
}

class _CardRequestState extends State<CardRequest> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20,10,20,0),
      height: 90,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        color: Color(0xffF3E8D7),
        child: Row(
          children: [
            Expanded(
              flex: 1, // 20%
              child: _buildState()
            ),
            Expanded(
                flex: 6,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.itemRJ.profesion, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                                  Text(widget.itemRJ.date)
                                ],
                              ),
                              Text(widget.itemRJ.ubication)
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

    );

  }

  Widget _buildState(){
    if (widget.itemRJ.status == "A") {
      return Icon(Icons.circle, color: Colors.green,);
    }

    if (widget.itemRJ.status == "P") {
      return Icon(Icons.circle, color: Colors.yellow,);
    }

    return Icon(Icons.circle, color: Colors.red,);
  }
}

class RequestJob {
  String status = "-";
  String date = "-";
  String ubication = "-";
  String profesion = "-";

  RequestJob(this.status, this.date, this.ubication, this.profesion);
}


