import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'main_page.dart';

class RequestsPage extends StatefulWidget {
  static String id = 'requests_page';

  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  TextEditingController dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          //backgroundColor: Colors.red,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Text("Solicitud de servicio", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            const SizedBox(height: 8.0),
            Text("Especifica el tipo de profesional que buscas", style: TextStyle(fontSize: 12.0)),
            const SizedBox(height: 15.0),
            CustomDropdownButton(),
            const SizedBox(height: 15.0),
            _datebirthTextField(dateController),
            const SizedBox(height: 15.0),
            _buttonUbication(),
            const SizedBox(height: 15.0),
            _detailTextField(),
            const SizedBox(height: 15.0),
            _buttonRequest()

          ],
        ),
      ),
      ),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              },
            ),
          ],
        ),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          },
        );
      },
    );
  }


  Widget _datebirthTextField(dateController) {
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
                controller: dateController,
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
                      dateController.text = formattedDate; //set foratted date to TextField value.
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













}

const List<String> list = <String>['Profesor', 'Carpinero', 'Pintor'];

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




