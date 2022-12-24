import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:work_app/src/presentation/pages/requests_published_page.dart';

import 'main_page.dart';

class RequestsPublishedDetailPage extends StatefulWidget {
  static String id = 'requests_page';
  final RequestJobPublished itemRJ;

  //RequestsPublishedDetailPage(RequestJobPublished itemRJ);

  const RequestsPublishedDetailPage(this.itemRJ, {super.key});


  @override
  _RequestsPublishedDetailPageState createState() => _RequestsPublishedDetailPageState();
}

class _RequestsPublishedDetailPageState extends State<RequestsPublishedDetailPage> {
  late String dropdownValue;
  List<String> listDisponibility = ['Inmediata', 'Baja', 'Negociable'];
  @override
  Widget build(BuildContext context) {
    dropdownValue = listDisponibility.first;
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
                        Text("Detalle de la solicitud de "+widget.itemRJ.nameClient,textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
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
                                                const Text('Fecha', textAlign: TextAlign.left, textScaleFactor: 1.2,),
                                                const SizedBox(height: 8.0),
                                                Text(widget.itemRJ.date),
                                                const SizedBox(height: 20.0),
                                                const Text('Dirección', textAlign: TextAlign.left, textScaleFactor: 1.2,),
                                                const SizedBox(height: 8.0),
                                                ElevatedButton(
                                                  child: Wrap(
                                                    //padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                                                    crossAxisAlignment: WrapCrossAlignment.center,
                                                    verticalDirection: VerticalDirection.down,
                                                    children: [
                                                      Text('Ver ubicación', style: TextStyle(color: Colors.black),),
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
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                const SizedBox(height: 15.0),
                                                const Text('Detalles', textAlign: TextAlign.left, textScaleFactor: 1.2,),
                                                const SizedBox(height: 8.0),
                                                TextField(
                                                  decoration: const InputDecoration(
                                                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                                    //labelText: "Correo",
                                                    border: OutlineInputBorder(
                                                      borderRadius: const BorderRadius.all(
                                                        Radius.circular(10.0),
                                                      ),
                                                    ),
                                                  ),
                                                  onChanged: (value) {},
                                                  maxLines: 8,
                                                  controller: TextEditingController()..text = 'Estucado de segundo piso',
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
                        ElevatedButton(
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
                            builder: (BuildContext context) => AlertDialog(
                              content: Container(
                              height: 220,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Disponibilidad', textAlign: TextAlign.left, textScaleFactor: 1.2,),
                                  const SizedBox(height: 8.0),
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
                                  const SizedBox(height: 20.0),
                                ],
                              ),
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
                          ),
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


}

