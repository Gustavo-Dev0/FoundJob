import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:work_app/src/domain/entities/request_entity.dart';
import 'package:work_app/src/presentation/cubit/request/request_cubit.dart';

import 'main_page.dart';

class RequestsMadePage extends StatefulWidget {
  static String id = 'requests_page';
  final String uid;
  const RequestsMadePage({Key? key,required this.uid}) : super(key: key);

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
  void initState() {
    //Logger().wtf(widget.uid);
    BlocProvider.of<RequestCubit>(context).getRequests(uid: widget.uid);
    super.initState();
  }



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
          body: BlocBuilder<RequestCubit, RequestState>(
            builder: (context, requestState){
              if(requestState is RequestLoaded){
                //Logger().wtf(requestState.requests.length);
                return Column(
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
                        requestState.requests.isEmpty?_noRequestsWidget():ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: requestState.requests.length,
                            itemBuilder: (context, index) {
                              return CardRequest(requestState.requests[index]);
                            }
                        ),
                      ],
                    ),
                  )],
                );
              }

              return Center(child: CircularProgressIndicator());
            },
          )
        ));
  }

  Widget _noRequestsWidget(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 80,
              child: Image.asset('assets/images/notebook.png'),),
          SizedBox(
            height: 10,
          ),
          Text("No notes here yet"),
        ],
      ),
    );
  }

}

const List<String> list = <String>['Profesor', 'Carpinero', 'Pintor'];

class CardRequest extends StatefulWidget {
  final RequestEntity itemRJ;

  const CardRequest(this.itemRJ, {super.key});
  //const CardRequest({Key? key}) : super(key: key);

  @override
  State<CardRequest> createState() => _CardRequestState();
}

class _CardRequestState extends State<CardRequest> {
  String dropdownValue = list.first;
  String ubic = "";

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.fromLTRB(20,10,20,0),
      height: 110,
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
                                  Text(widget.itemRJ.profession!+"", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                                  Text(widget.itemRJ.date!+"")
                                ],
                              ),
                              Text(ubic)

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


    getAddress(GeoPoint u) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(u.latitude, u.longitude);
    //Logger().wtf(placemarks.toString());
    setState(() {
      ubic = placemarks[0].country! + ","+placemarks[0].administrativeArea! + "\n" +placemarks[0].street!;
    });
  }

  Widget _buildState(){
    getAddress(widget.itemRJ.ubication!);
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


