import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:work_app/src/presentation/pages/requests_published_detail_page.dart';

import '../cubit/auth/auth_cubit.dart';
import 'main_page.dart';

class RequestsPublishedPage extends StatefulWidget {
  static String id = 'requests_page';

  @override
  _RequestsPublishedPageState createState() => _RequestsPublishedPageState();
}

class _RequestsPublishedPageState extends State<RequestsPublishedPage> {
  late List<RequestJobPublished> listRequestsJob;
  @override
  Widget build(BuildContext context) {
    listRequestsJob = [
      RequestJobPublished("15/10/20", "Cusco - Perú", "Roberto Fir"),
      RequestJobPublished("16/10/20", "Cusco - Perú", "Adela Perez"),
    ];
    return SafeArea(
        child: Scaffold(
          //backgroundColor: Colors.red,
          body: Column(
            children: [ SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  Text("Solicitudes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                  const SizedBox(height: 8.0),
                  Text("Solicictudes de servicio cercanas", style: TextStyle(fontSize: 12.0)),
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
            ),]
          ),
        ));
  }


}

const List<String> list = <String>['Profesor', 'Carpinero', 'Pintor'];

class CardRequest extends StatefulWidget {
  final RequestJobPublished itemRJ;

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
      height: 110,
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
                                  Text(widget.itemRJ.nameClient, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                                  Text(widget.itemRJ.date)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.itemRJ.ubication),
                                  TextButton(
                                      onPressed: ()=>{
                                      //BlocProvider.of<AuthCubit>(context).loggedOut()
                                        Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => RequestsPublishedDetailPage(widget.itemRJ)),)
                                      },
                                      child: Text("Ver mas detalles", style: TextStyle(decoration: TextDecoration.underline,),)
                                  ),
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

}

class RequestJobPublished {
  String date = "-";
  String ubication = "-";
  String nameClient = "-";
  String? detail = "-";

  RequestJobPublished(this.date, this.ubication, this.nameClient);
}


