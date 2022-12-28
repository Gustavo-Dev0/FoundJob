import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:work_app/src/domain/entities/applicant_entity.dart';
import 'package:work_app/src/domain/entities/request_entity.dart';
import 'package:work_app/src/presentation/cubit/request/request_cubit.dart';
import 'package:work_app/src/presentation/pages/chat_body_page.dart';

import 'main_page.dart';

class ChatPage extends StatefulWidget {
  static String id = 'requests_page';
  final String uid;
  final bool isClient;
  const ChatPage({Key? key,required this.uid, required this.isClient}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

final List<RequestJob> list2 = {
  RequestJob("C", "15/10/20", "Cusco - Perú", "Albañil"),
  RequestJob("A", "16/10/20", "Cusco - Perú", "Pintor"),
  RequestJob("P", "17/10/20", "Cusco - Perú", "Gasfitero"),
  RequestJob("A", "20/10/20", "Cusco - Perú", "Albañil"),

} as List<RequestJob>;

class _ChatPageState extends State<ChatPage> {
  late List<RequestJob> listRequestsJob;

  @override
  void initState() {
    //Logger().wtf(widget.uid);
    BlocProvider.of<RequestCubit>(context).getChatsFromApplicants(uid: widget.uid);
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
            builder: (context, applicantsState){
              if(applicantsState is ApplicantLoaded){
                //Logger().wtf(requestState.requests.length);
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20.0),
                      Text("Chats aceptados", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                      const SizedBox(height: 8.0),
                      Text("Personas que aceptaste", style: TextStyle(fontSize: 12.0)),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Disponibilidad: ", style: TextStyle(fontSize: 10.0)),
                          Icon(Icons.circle, color: Colors.green,),
                          Text("Inmediata", style: TextStyle(fontSize: 10.0)),
                          Icon(Icons.circle, color: Colors.yellow,),
                          Text("Negociable", style: TextStyle(fontSize: 10.0)),
                          Icon(Icons.circle, color: Colors.red,),
                          Text("Baja", style: TextStyle(fontSize: 10.0)),
                        ],
                      ),

                      const SizedBox(height: 20.0),
                      applicantsState.applicants.isEmpty?_noRequestsWidget():ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: applicantsState.applicants.length,
                          itemBuilder: (context, index) {
                            return CardRequest(applicantsState.applicants[index], widget.uid, widget.isClient);
                          }
                      ),
                    ],
                  ),
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
          Text("No hay chats aún"),
        ],
      ),
    );
  }

  void goIntoChat(String chatId){

  }

}

const List<String> list = <String>['Profesor', 'Carpinero', 'Pintor'];

class CardRequest extends StatefulWidget {
  final ApplicantEntity itemRJ;
  final String uId;
  final bool isClient;

  const CardRequest(this.itemRJ, this.uId, this.isClient, {super.key});
  //const CardRequest({Key? key}) : super(key: key);

  @override
  State<CardRequest> createState() => _CardRequestState();
}

class _CardRequestState extends State<CardRequest> {
  String dropdownValue = list.first;
  String ubic = "";

  @override
  Widget build(BuildContext context) {
    DateTime d = DateTime.parse(widget.itemRJ.date!);
    print(d);
    return Container(
      padding: EdgeInsets.fromLTRB(20,10,20,0),
      height: 110,
      width: double.maxFinite,
      child: GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatBodyPage(email: widget.uId, applicantId: widget.itemRJ.aid!,isClient: widget.isClient,)));
        },
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
                                    Text(widget.isClient?widget.itemRJ.workerName!:widget.itemRJ.clientName!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                                    Text(d.day.toString()+"/"+d.month.toString()+"/"+d.year.toString()+" "+d.hour.toString() + ":" + d.minute.toString(),)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //Text(widget.isClient?widget.itemRJ.workerName!:widget.itemRJ.clientName!, style: TextStyle(fontSize: 14.0),),
                                    Text(widget.itemRJ.profession!, style: TextStyle(fontSize: 14.0),),
                                    //Text(d.day.toString()+"/"+d.month.toString()+"/"+d.year.toString()+" "+d.hour.toString() + ":" + d.minute.toString(),)
                                  ],
                                ),
                                //Text(ubic)

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
    //getAddress(widget.itemRJ.ubication!);
    if (widget.itemRJ.availability == "Inmediata") {
      return Icon(Icons.circle, color: Colors.green,);
    }

    if (widget.itemRJ.availability == "Negociable") {
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


