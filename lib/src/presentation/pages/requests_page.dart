import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:work_app/src/presentation/cubit/request/request_cubit.dart';

import '../../domain/entities/request_entity.dart';
import '../cubit/auth/auth_cubit.dart';
import 'main_page.dart';

class RequestsPage extends StatefulWidget {
  static String id = 'requests_page';
  final Function showRequests;

  const RequestsPage({Key? key, required this.showRequests}) : super(key: key);

  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _detailTextController = TextEditingController();
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
  final LatLng _center = const LatLng(45.521563, -122.677433);


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _add(LatLng ubication) {
    //Logger().wtf(ubication.toString());
    Marker tmp = Marker(
      markerId: MarkerId('2'),
      position: ubication,
      //icon: BitmapDescriptor.,
      infoWindow: InfoWindow(
        title: 'title',
        snippet: 'address',
      ),
    );
    setState(() {
      marker=tmp;
    });
    Logger().wtf(marker.position.toString());
  }

  int _indexProfessionSelected = 0;
  String _dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          //backgroundColror: Colors.red,
      body: SingleChildScrollView(
            child: Column(
              children: [


                const SizedBox(height: 20.0),
                Text("Solicitud de servicio", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                const SizedBox(height: 8.0),
                Text("Especifica el tipo de profesional que buscas", style: TextStyle(fontSize: 12.0)),
                const SizedBox(height: 15.0),
                _professionDropdown(),
                const SizedBox(height: 15.0),
                _datebirthTextField(),
                const SizedBox(height: 15.0),
                _buttonUbication(),
                const SizedBox(height: 15.0),
                _detailTextField(),
                const SizedBox(height: 15.0),
                _buttonRequest()

              ],
            ),
          )




      )
      );
  }
  Widget _detailTextField() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Detalles', textAlign: TextAlign.left, textScaleFactor: 1.2,),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Checkbox(value: false, onChanged: (value)=>{}, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,),
                    Text('No adjuntas archivos (fotos)')
                  ],
                ),
                SizedBox(height: 8.0),
                TextField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    hintText: 'Digite detalles del trabajo',
                    //labelText: "Correo",
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                  onChanged: (value) {},
                  maxLines: 8,
                  controller: _detailTextController,
                ),

              ],
            ));
      },
    );
  }

  Widget _buttonUbication() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            Text('Dirección', textAlign: TextAlign.left, textScaleFactor: 1.2,),
            SizedBox(height: 8.0),
            ElevatedButton(
              child: Wrap(
                //padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                crossAxisAlignment: WrapCrossAlignment.center,
                verticalDirection: VerticalDirection.down,
                children: [
                  Text('Seleccionar ubicación', style: TextStyle(color: Colors.black),),
                  SizedBox(width: 10.0),
                  Icon(
                    Icons.location_on,
                    color: Colors.red,
                  )
                ],
              ),

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
                  Marker mim = const Marker(
                    markerId: MarkerId('2'),
                    position: LatLng(45.497240543179444, -122.65883076936007),
                    //icon: BitmapDescriptor.,
                    infoWindow: InfoWindow(
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
                            const Text('Seleccione ubicación:', textAlign: TextAlign.left, textScaleFactor: 1.2,),
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
                                  onTap: (ubi){
                                    setState(
                                      () {
                                        mim = Marker(
                                          markerId: MarkerId('2'),
                                          position: ubi,
                                          //icon: BitmapDescriptor.,
                                          infoWindow: const InfoWindow(
                                            title: 'title',
                                            snippet: 'address',
                                          ),
                                        );
                                      },
                                    );
                                    _add(ubi);
                                  },

                                ),
                            ),
                            const Text("ef", textAlign: TextAlign.left, textScaleFactor: 1.2,),

        /*const SizedBox(height: 8.0),
                        _dropdownDisponibility(),
                        const SizedBox(height: 20.0),
                        const Text('Monto estimado', textAlign: TextAlign.left, textScaleFactor: 1.2,),
                        const SizedBox(height: 8.0),
                        TextField(
                          maxLength: 5,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                            hintText: 'Precio',

                            //labelText: "Correo",
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                          onChanged: (value) {},
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            FilteringTextInputFormatter.digitsOnly],
                        ),
                        const SizedBox(height: 20.0),*/
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
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => Navigator.pop(context, 'OK'),
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
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('Confirmar', style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ],
                );
              }
              )
            ),
          ],
        ),
        );
      },
    );
  }

  Widget _datebirthTextField() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Fecha', textAlign: TextAlign.left, textScaleFactor: 1.2,),
              SizedBox(height: 8.0),
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  prefixIcon: Icon(Icons.calendar_month_outlined),
                  hintText: 'Fecha',
                  //labelText: "Contraseña"
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                onChanged: (value) {},
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //get today's date
                      firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101)
                  );

                  if(pickedDate != null ){
                    print(pickedDate);  //get the picked date in the format => 2022-07-04 00:00:00.000
                    String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                    print(formattedDate); //formatted date output using intl package =>  2022-07-04
                    //You can format date as per your need
                    setState(() {
                      _dateController.text = formattedDate; //set foratted date to TextField value.
                    });
                  }else{
                    print("Date is not selected");
                  }
                },
                readOnly: true,
              ),
              //InputDatePickerFormField(firstDate: DateTime.now(), lastDate: DateTime.utc(2023)),
              //CalendarDatePicker(firstDate: DateTime.now(),initialDate: DateTime.now(),lastDate: DateTime.utc(2023),
              //onDateChanged: (DateTime a) =>{},)
            ],
          ),
        );
      },
    );
  }

  Widget _professionDropdown() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Profesión', textAlign: TextAlign.left, textScaleFactor: 1.2,),
                const SizedBox(height: 8.0),
                InputDecorator(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      prefixIcon: Icon(Icons.work)
                  ),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _dropdownValue,
                        icon: const Icon(Icons.arrow_drop_down),
                        //elevation: 16,
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            _dropdownValue = value!;
                          });
                        },
                        borderRadius: const BorderRadius.all(
                            Radius.circular(40.0)),
                        items: list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                  ),
                ),
              ],
            )


        );
      },
    );
  }

  Widget _buttonRequest() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ElevatedButton(
          child: Container(
            //padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text('Solicitar servicio', style: TextStyle(fontWeight: FontWeight.bold,),),
          ),
          style: ElevatedButton.styleFrom(
            //padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),
            backgroundColor: Colors.orange,
          ),
          onPressed: () {
            Logger().d(_dropdownValue + " " + _detailTextController.text + " " +
                _dateController.text);
            BlocProvider.of<AuthCubit>(context).getCurrentUidUseCase().then((uuid) => {
              BlocProvider.of<RequestCubit>(context).addRequest(note: RequestEntity(
              uid: uuid,
              ubication: GeoPoint(marker.position.latitude, marker.position.longitude),
              profession: _dropdownValue,
              date: _dateController.text,
              description:  _detailTextController.text


              ),).then((value) => {
                widget.showRequests()
              })
            });


            /*Future.delayed(Duration(seconds: 1),(){
              Navigator.pop(context);
            });*/
          },
        );
      },
    );
  }


}

const List<String> list = <String>['Profesor', 'Carpinero', 'Pintor'];










/*
class CustomDropdownButton extends StatefulWidget {
  const CustomDropdownButton({super.key});

  @override
  State<CustomDropdownButton> createState() => _DropdownButtonState();
}

class _DropdownButtonState extends State<CustomDropdownButton> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Profesión', textAlign: TextAlign.left, textScaleFactor: 1.2,),
          const SizedBox(height: 8.0),
          InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              prefixIcon: Icon(Icons.work)
            ),
            child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  //elevation: 16,
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  borderRadius: const BorderRadius.all(
                      Radius.circular(40.0)),
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
            ),
          ),
        ],
      )


    );

  }
}

*/


