import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
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
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _detailTextController = TextEditingController();
  TextEditingController _professionEditingController = TextEditingController();
  late GoogleMapController mapController;
  String _professionValue = "";
  Marker? marker = null;
  LatLng _center = const LatLng(-16.404214, -71.541073);
  bool isFineLocation = true;
  String _dropdownValue = list.first;


  @override
  void initState() {
    super.initState();
    var x = getUserCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    if(isFineLocation){
      var x = getUserCurrentLocation();
      x.then((value) {
        //Logger().w(value.toString());
        setState(() {
          _center = LatLng(value.latitude, value.longitude);
          isFineLocation = false;
        });
      });
    }
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
                //const SizedBox(height: 15.0),
                //_professionDropdown(),
                const SizedBox(height: 15.0),
                _dateJobTextField(),
                const SizedBox(height: 15.0),
                _professionAutocompleteTextField(),
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

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR"+error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _add(LatLng ubication) {
    //Logger().wtf(ubication.toString());
    Marker tmp = Marker(
      markerId: MarkerId('9'),
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
    Logger().wtf(marker?.position.toString());
  }


  Widget _professionAutocompleteTextField() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Seleccione profesion:', textAlign: TextAlign.left, textScaleFactor: 1.2,),
                const SizedBox(height: 8.0),
                Autocomplete<String>(

                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return _professionOptions.where((String option) {
                      //Logger().wtf(option);
                      return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (String selection) {
                    _professionEditingController.text = selection;
                    setState(() {
                      _professionValue = selection;
                    });
                  },
                  fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController,
                      FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
                    _professionEditingController = fieldTextEditingController;
                    return
                      TextField(
                        //style: const TextStyle(fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Buscar profesiones...',
                          //labelText: "Correo",
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(40.0),
                            ),
                          ),

                        ),
                        autofocus: false,
                        controller: fieldTextEditingController,
                        focusNode: fieldFocusNode,
                      );
                  },
                  /*optionsViewBuilder: (context, onSelect, options){
                    return Material(
                      elevation: 4,
                      child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index){
                            final option = options.elementAt(index);
                            return ListTile(title: Text(option.toString()),contentPadding: EdgeInsets.all(8),);
                          },
                          separatorBuilder: (contex, index) => Divider(),
                          itemCount: options.length),
                    );
                  },*/
                ),
                const SizedBox(height: 15.0),
                Text("Profesión requerida: "+_professionValue, textScaleFactor: 1.2,),
              ],
            ));
      },
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
                /*Row(
                  children: [
                    Checkbox(value: false, onChanged: (value)=>{}, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,),
                    Text('No adjuntas archivos (fotos)')
                  ],
                ),*/
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
                  Marker mim;
                  LatLng center;
                  Set<Marker> _markers = {};
                  center = _center;
                  if(marker != null){
                    _markers.add(marker!);
                    center = marker!.position;
                  }
                  //Logger().wtf(center.toString());

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
                                      target: center,
                                      zoom: 11.0,
                                    ),
                                    markers: _markers,
                                    onTap: (ubi){
                                      setState(
                                        () {
                                          mim = Marker(
                                            markerId: MarkerId('9'),
                                            position: ubi,
                                            //icon: BitmapDescriptor.,
                                            infoWindow: const InfoWindow(
                                              title: 'Ubicacion',
                                              snippet: 'seleccionada',
                                            ),
                                          );
                                          _markers.add(mim);
                                        },
                                      );
                                      _add(ubi);
                                    },

                                  ),
                              ),
                              const Text("", textAlign: TextAlign.left, textScaleFactor: 1.2,),
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
              ),
              child: Wrap(
                //padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                crossAxisAlignment: WrapCrossAlignment.center,
                verticalDirection: VerticalDirection.down,
                children: const [
                  Text('Seleccionar ubicación', style: TextStyle(color: Colors.black),),
                  SizedBox(width: 10.0),
                  Icon(
                    Icons.location_on,
                    color: Colors.red,
                  )
                ],
              )
            ),
          ],
        ),
        );
      },
    );
  }

  Widget _dateJobTextField() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Fecha', textAlign: TextAlign.left, textScaleFactor: 1.2,),
              const SizedBox(height: 8.0),
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
                      firstDate: DateTime.now(), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime.now().add(Duration(days: 700))
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
          style: ElevatedButton.styleFrom(
            //padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),
            backgroundColor: Colors.orange,
          ),
          onPressed: () {

            if(_dateController.text == ""){
              Fluttertoast.showToast(
                  msg: "Seleccione fecha",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              return;
            }

            if(_professionValue == ""){
              Fluttertoast.showToast(
                  msg: "Seleccione una profesion",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              return;
            }

            if(marker == null){
              Fluttertoast.showToast(
                  msg: "Seleccione ubicación",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              return;
            }

            if(_detailTextController.text == ""){
              Fluttertoast.showToast(
                  msg: "Agregue una descripción",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              return;
            }


            BlocProvider.of<AuthCubit>(context).getCurrentUidUseCase().then((uuid) => {
              BlocProvider.of<RequestCubit>(context).addRequest(note: RequestEntity(
              uid: uuid,
              ubication: GeoPoint(marker!.position.latitude, marker!.position.longitude),
              profession: _professionValue,
              date: _dateController.text,
              description:  _detailTextController.text
              ),).then((value) => {
                widget.showRequests()
              })
            });

          },
          child: const Text('Solicitar servicio', style: TextStyle(fontWeight: FontWeight.bold,),),
        );
      },
    );
  }

  static const List<String> _professionOptions = <String>[
    'Abogado',
    'Actor/Actriz',
    'Administrador',
    'Agricultor',
    'Albañil',
    'Animador',
    'Antropólogo',
    'Archivólogo',
    'Arqueólogo',
    'Arquitecto',
    'Artesano',
    'Asistente de tienda',
    'Barbero',
    'Barrendero',
    'Bibliotecario',
    'Bibliotecólogo',
    'Biólogo',
    'Bombero',
    'Botánico',
    'Cajero',
    'Carnicero',
    'Carpintero',
    'Cartero',
    'Cerrajero',
    'Chofer o conductor',
    'Científicos',
    'Cocinero',
    'Computista',
    'Conductor de autobús',
    'Conductor de taxi',
    'Contador',
    'Deshollinador',
    'Ecólogo',
    'Economista',
    'Editor',
    'Electricista',
    'Electricista',
    'Electricista',
    'Enfermera',
    'Enfermero',
    'Escritor',
    'Escultor',
    'Exterminador',
    'Farmacólogo',
    'Filólogo',
    'Filósofo',
    'Físico',
    'Florista',
    'Fontanero o plomero',
    'Frutero',
    'Ganadero',
    'Geógrafo',
    'Granjero',
    'Guardián de tráfico',
    'Herrero',
    'Historiador',
    'Impresor',
    'Informático',
    'Ingeniero',
    'Jardinero',
    'Lavandero',
    'Lechero',
    'Lector de noticias',
    'Leñador',
    'Limpiador de ventanas',
    'Limpiador',
    'Lingüista',
    'Locutor',
    'Matemático',
    'Mecánico',
    'Mecánico',
    'Médico cirujano',
    'Mesero / Camarera',
    'Modelo',
    'Músico',
    'Obrero',
    'Óptico',
    'Paleontólogo',
    'Panadero',
    'Panadero',
    'Paramédico',
    'Peletero',
    'Peluquero',
    'Periodista',
    'Pescador',
    'Pintor de brocha gorda',
    'Pintor',
    'Pintor',
    'Plomero',
    'Policía',
    'Politólogo',
    'Profesor',
    'Psicoanalista',
    'Psicólogo',
    'Químico',
    'Radiólogo',
    'Recepcionista',
    'Recolector de basura',
    'Repartidor',
    'Salvavidas',
    'Sastre',
    'Sastre',
    'Secretaria',
    'Secretario',
    'Sociólogo',
    'Soldado',
    'Soldador',
    'Técnico de sonido',
    'Técnico en turismo',
    'Terapeuta',
    'Tornero',
    'Trabajador de fábrica',
    'Vendedor',
    'Vigilante',

  ];


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


