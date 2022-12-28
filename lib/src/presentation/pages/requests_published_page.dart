import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:work_app/src/domain/entities/request_entity.dart';
import 'package:work_app/src/presentation/pages/requests_published_detail_page.dart';

import '../cubit/auth/auth_cubit.dart';
import '../cubit/request/request_cubit.dart';
import 'main_page.dart';

class RequestsPublishedPage extends StatefulWidget {
  static String id = 'requests_page';
  final String uId;

  const RequestsPublishedPage(this.uId, {super.key});

  @override
  _RequestsPublishedPageState createState() => _RequestsPublishedPageState();
}

class _RequestsPublishedPageState extends State<RequestsPublishedPage> {
  late List<RequestJobPublished> listRequestsJob;

  @override
  void initState() {
    //Logger().wtf(widget.uid);
    BlocProvider.of<RequestCubit>(context).getRequestsByProfession(professions: []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    listRequestsJob = [
      RequestJobPublished("15/10/20", "Cusco - Perú", "Roberto Fir"),
      RequestJobPublished("16/10/20", "Cusco - Perú", "Adela Perez"),
    ];
    return SafeArea(
        child: Scaffold(
          //backgroundColor: Colors.red,
          body: BlocBuilder<RequestCubit, RequestState>(
            builder: (context, RequestState requestState){
              //Logger().wtf(requestState.requests.length);
              if(requestState is RequestLoaded){
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20.0),
                      const Text("Solicitudes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                      const SizedBox(height: 8.0),
                      const Text("Solicitudes de servicio cercanas", style: TextStyle(fontSize: 12.0)),
                      const SizedBox(height: 20.0),
                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: requestState.requests.length,
                          itemBuilder: (context, index) {
                            return CardRequest(requestState.requests[index], widget.uId);
                          }
                      ),
                    ],
                  ),
                );
              }
              if(requestState is RequestFailure){
                Logger().wtf("ERROR");
              }
              return Center(child: CircularProgressIndicator());
            },
          ),

        ));
  }


}

const List<String> list = <String>['Profesor', 'Carpinero', 'Pintor'];

class CardRequest extends StatefulWidget {
  final RequestEntity itemRJ;
  final String userId;

  const CardRequest(this.itemRJ, this.userId, {super.key});
  //const CardRequest({Key? key}) : super(key: key);

  @override
  State<CardRequest> createState() => _CardRequestState();
}

class _CardRequestState extends State<CardRequest> {
  String dropdownValue = list.first;
  String ubic = "";

  @override
  Widget build(BuildContext context) {
    if(ubic == ""){
      getAddress(widget.itemRJ.ubication!);
    }



    return Container(
      padding: EdgeInsets.fromLTRB(20,10,20,0),
      height: 140,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        color: Color(0xffF3E8D7),
        child: Row(
          children: [
            Expanded(
              flex: 1, // 20%
              child: CircleAvatar(
                backgroundColor: Colors.grey,

                child: Text("HG"),
              )
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
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.itemRJ.profession!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                                  Text(widget.itemRJ.clientName!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),),
                                  Text(widget.itemRJ.date!)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(flex: 1,child: Text(ubic, )),
                                  Expanded(flex: 1,child: TextButton(
                                      onPressed: ()=>{
                                        //BlocProvider.of<AuthCubit>(context).loggedOut()
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => RequestsPublishedDetailPage(widget.itemRJ, widget.userId)),)
                                      },
                                      child: Text("Ver mas detalles", style: TextStyle(decoration: TextDecoration.underline,),)
                                  )),
                                  /*Text(ubic, ),
                                  TextButton(
                                      onPressed: ()=>{
                                      //BlocProvider.of<AuthCubit>(context).loggedOut()
                                        Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => RequestsPublishedDetailPage(widget.itemRJ, widget.userId)),)
                                      },
                                      child: Text("Ver mas detalles", style: TextStyle(decoration: TextDecoration.underline,),)
                                  ),*/
                                ],
                              ),



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
      ubic = "${placemarks[0].country!},${placemarks[0].administrativeArea!}\n${placemarks[0].street!}";
    });
  }
}

class RequestJobPublished {
  String date = "-";
  String ubication = "-";
  String nameClient = "-";
  String? detail = "-";

  RequestJobPublished(this.date, this.ubication, this.nameClient);
}


