
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:work_app/src/domain/entities/applicant_entity.dart';
import 'package:work_app/src/domain/entities/request_entity.dart';
import 'package:work_app/src/presentation/cubit/request/request_cubit.dart';

class RequestsPublishedDetailPage extends StatefulWidget {
  static String id = 'requests_page';
  final RequestEntity itemRJ;
  final String uId;

  //RequestsPublishedDetailPage(RequestJobPublished itemRJ);

  const RequestsPublishedDetailPage(this.itemRJ,this.uId, {super.key});


  @override
  _RequestsPublishedDetailPageState createState() => _RequestsPublishedDetailPageState();
}

class _RequestsPublishedDetailPageState extends State<RequestsPublishedDetailPage> {
  late String availabilityDropdownValue;
  List<String> listDisponibility = ['Inmediata', 'Baja', 'Negociable'];
  TextEditingController _salary = TextEditingController();
  TextEditingController _commentController = TextEditingController();
  bool acepted = false;
 
  late GoogleMapController mapController;
  Marker marker = Marker(
    markerId: MarkerId('1'),
    position: LatLng(45.497240543179444, -122.65883076936007),
    //icon: BitmapDescriptor.,
    infoWindow: InfoWindow(
      title: 'title',
      snippet: 'address',
    ),
  );

  LatLng _center = const LatLng(0, 0);


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    if(_center.latitude == 0 && _center.longitude == 0){
      setState(() {
        _center = LatLng(widget.itemRJ.ubication!.latitude, widget.itemRJ.ubication!.longitude);
      });

    }
    availabilityDropdownValue = listDisponibility.first;
    acepted = widget.itemRJ.applicantsList!.contains(widget.uId);
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
              title: const Text('FoundJob'),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.orange,
            ),
          body: Column(
            children: [
              SingleChildScrollView(
                child: Container(
                    color: Colors.white70,
                    padding: EdgeInsets.fromLTRB(20,10,20,0),
                    width: double.maxFinite,
                    child: Column(
                      children: [
                        const SizedBox(height: 20.0),
                        Text("Detalle de la solicitud de "+widget.itemRJ.clientName!,textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                        const SizedBox(height: 8.0),
                        Card(
                          elevation: 5,

                          child: Row(
                            children: [
                              Expanded(
                                  flex: 6,
                                  child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const SizedBox(height: 20.0),
                                                const Text('Profesión/Oficio requerido:', textAlign: TextAlign.left, textScaleFactor: 1.2,),
                                                Text(widget.itemRJ.profession!, textAlign: TextAlign.left, textScaleFactor: 1.4,style: TextStyle(fontWeight: FontWeight.bold)),
                                                const SizedBox(height: 8.0),
                                                const Text('Fecha', textAlign: TextAlign.left, textScaleFactor: 1.2,),
                                                const SizedBox(height: 8.0),
                                                Text(widget.itemRJ.date!, textAlign: TextAlign.left, textScaleFactor: 1.4,style: TextStyle(fontWeight: FontWeight.bold)),
                                                const SizedBox(height: 20.0),
                                                const Text('Dirección', textAlign: TextAlign.left, textScaleFactor: 1.2,),
                                                const SizedBox(height: 8.0),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    //padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10.0)
                                                    ),
                                                    backgroundColor: Colors.orangeAccent,
                                                  ),
                                                  onPressed: () => showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        Marker mim = Marker(
                                                          markerId: const MarkerId('2'),
                                                          position: LatLng(widget.itemRJ.ubication!.latitude, widget.itemRJ.ubication!.longitude),
                                                          //icon: BitmapDescriptor.,
                                                          infoWindow: const InfoWindow(
                                                            title: 'title',
                                                            snippet: 'address',
                                                          ),
                                                        );

                                                        return AlertDialog(

                                                          content: StatefulBuilder(
                                                            builder: (context, setState){
                                                              return Container(
                                                                height: 350,
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    const Text('Ubicación de trabajo:', textAlign: TextAlign.left, textScaleFactor: 1.2,),
                                                                    Container(
                                                                      height: 300,
                                                                      width: 300,
                                                                      child: GoogleMap(
                                                                        onMapCreated: _onMapCreated,
                                                                        initialCameraPosition: CameraPosition(
                                                                          target: _center,
                                                                          zoom: 11.0,
                                                                        ),
                                                                        markers: {
                                                                          mim
                                                                        },

                                                                      ),
                                                                    ),
                                                                    const Text("Dirección aproximada: ", textAlign: TextAlign.left, textScaleFactor: 1.2,),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                          actions: <Widget>[
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(10.0)
                                                                ),
                                                                backgroundColor: Colors.green,
                                                              ),
                                                              onPressed: () => Navigator.pop(context, 'OK'),
                                                              child: const Text('Aceptar', style: TextStyle(fontWeight: FontWeight.bold,),),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                  )
                                                  ,
                                                  child: Wrap(
                                                    //padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                                                    crossAxisAlignment: WrapCrossAlignment.center,
                                                    verticalDirection: VerticalDirection.down,
                                                    children: const [
                                                      Text('Ver ubicación', style: TextStyle(color: Colors.black),),
                                                      SizedBox(width: 10.0),
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Colors.red,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 15.0),
                                                const Text('Detalles', textAlign: TextAlign.left, textScaleFactor: 1.2,),
                                                const SizedBox(height: 8.0),
                                                TextField(
                                                  decoration: const InputDecoration(
                                                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                                    //labelText: "Correo",
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0),
                                                      ),
                                                    ),
                                                  ),
                                                  onChanged: (value) {},
                                                  maxLines: 8,
                                                  controller: TextEditingController()..text = widget.itemRJ.description!,
                                                  enabled: false,
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
                        const SizedBox(height: 20.0),
                        acepted ? Text("Ya aceptaste este trabajo")
                        : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            //padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () => showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              //Widget okButton = TextButton(onPressed: (){Logger().w("fwef");}, child: Text("ok"));
                              return AlertDialog(
                              content: StatefulBuilder(
                                builder: (context, setState){
                                  return Container(
                                    height: 300,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Disponibilidad', textAlign: TextAlign.left, textScaleFactor: 1.2,),
                                          const SizedBox(height: 8.0),
                                          InputDecorator(
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value: availabilityDropdownValue,
                                                  icon: const Icon(Icons.arrow_drop_down),
                                                  //elevation: 16,
                                                  onChanged: (String? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      availabilityDropdownValue = value!;
                                                    });
                                                  },
                                                  borderRadius: const BorderRadius.all(
                                                      Radius.circular(10.0)),
                                                  items: listDisponibility.map<DropdownMenuItem<String>>((String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                )
                                            ),
                                          ),
                                          const SizedBox(height: 20.0),
                                          const Text('Monto estimado', textAlign: TextAlign.left, textScaleFactor: 1.2,),
                                          const SizedBox(height: 8.0),
                                          TextField(
                                            maxLength: 5,
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                              hintText: 'Salario tentativo',

                                              //labelText: "Correo",
                                              border: OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                              ),
                                            ),
                                            controller: _salary,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                              FilteringTextInputFormatter.digitsOnly],
                                          ),
                                          //const SizedBox(height: 8.0),
                                          const Text('Comentario', textAlign: TextAlign.left, textScaleFactor: 1.2,),
                                          const SizedBox(height: 8.0),
                                          TextField(
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                              hintText: 'Comentario(agrega detalles como tu número para contactarte)',
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                              ),
                                            ),
                                            maxLines: 6,
                                            controller: _commentController,

                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),

                              actions: <Widget>[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0)
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context, 'OK');
                                    },
                                  child: const Text('Cancelar', style: TextStyle(fontWeight: FontWeight.bold,),),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    //padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0)
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                  onPressed: ()  async {
                                    if(_salary.text == ""){
                                      Fluttertoast.showToast(
                                          msg: "Ingrese un salario estimado",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
                                      return;
                                    }
                                    if(_commentController.text == ""){
                                      Fluttertoast.showToast(
                                          msg: "Ingrese comentario",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
                                      return;
                                    }
                                    await addApplicant();
                                    widget.itemRJ.applicantsList!.add(widget.uId);
                                    setState(() {
                                      acepted = true;
                                    });
                                    Navigator.pop(context, 'OK');
                                  },
                                  child: const Text('Confirmar', style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                              ],
                          );},
                        ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                            child: const Text('Aceptar trabajo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                          ),
                        ),
                      ],
                    )

                )
            )
            ]
        )));
  }

  Widget _dropdownDisponibility() {
    return Container(
        //padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: InputDecorator(
          decoration: const InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          ),
          child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: availabilityDropdownValue,
                icon: const Icon(Icons.arrow_drop_down),
                //elevation: 16,
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    availabilityDropdownValue = value!;
                  });
                },
                borderRadius: const BorderRadius.all(
                    Radius.circular(10.0)),
                items: listDisponibility.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )
          ),
        ),


    );

  }

  Future<void> addApplicant() async {

    var newApp = ApplicantEntity(
      workerId: widget.uId,
      salary: _salary.text,
      profession: widget.itemRJ.profession,
      requestId: widget.itemRJ.requestId,
      clientId: widget.itemRJ.uid,
      availability: availabilityDropdownValue,
      status: "P",
      description: _commentController.text,
      clientName: widget.itemRJ.clientName,
    );
    await BlocProvider.of<RequestCubit>(context).addApplicant(
        applicantEntity: newApp,
        requestEntity: widget.itemRJ);
  }


}

