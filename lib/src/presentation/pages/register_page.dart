import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../domain/entities/user_entity.dart';
import '../cubit/auth/auth_cubit.dart';
import '../cubit/user/user_cubit.dart';
import 'main_page.dart';
import 'main_page_professional.dart';

class RegisterPage extends StatefulWidget {
  static String id = 'login_page';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _degreeCodeController = TextEditingController();
  List<String> _professionList = [];
  TextEditingController _professionEditingController = TextEditingController();
  PlatformFile pickedFile = PlatformFile(name: "", size: 0);
  bool _isProfessional = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          //backgroundColor: Colors.red,
            body: BlocConsumer<UserCubit, UserState>(
              builder: (context, userState){
                if (userState is UserSuccess){
                return BlocBuilder<AuthCubit,AuthState>(builder:(context,authState){

                  if (authState is Authenticated){
                    Navigator.pop(context);
                    if(authState.profile.role == "cliente") {
                      return MainPage(uid: authState.uid);
                    }
                    return MainProfessionalPage(uid: authState.uid);
                  }else{
                    /*Fluttertoast.showToast(
                        msg: "Usuario no autenticado",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );*/
                    return _bodyWidget();
                  }
                });
              }
                return _bodyWidget();
              },
              listener: (context,userState){
                if (userState is UserSuccess){
                  BlocProvider.of<AuthCubit>(context).loggedIn();
                  Fluttertoast.showToast(
                      msg: "Usuario registrado",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
                if (userState is UserFailure){
                  //snackBarError(msg: "invalid email",scaffoldState: _scaffoldGlobalKey);
                  Fluttertoast.showToast(
                      msg: "error",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
              },
            )

        ));
  }

  _bodyWidget(){
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 80.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.orange,
                ),
                height: 50,
                child: const Text(
                  'FoundJob',
                  textScaleFactor: 2,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 15.0),
            Image.asset('assets/images/logo.png', height: 140),
            const SizedBox(height: 15.0),
            SizedBox(
              height: 40,
              child: ToggleSwitch(
                minWidth: 160.0,
                cornerRadius: 20.0,
                activeBgColors: const [
                  [Colors.orange],
                  [Colors.orange]
                ],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                initialLabelIndex: _isProfessional ? 1 : 0,
                totalSwitches: 2,
                labels: ['Busco ayuda', 'Soy profesional'],
                radiusStyle: true,
                onToggle: (index) {
                  setState(() => _isProfessional = !_isProfessional);
                },
              ),
            ),
            const SizedBox(height: 15.0),
            const SizedBox(height: 15.0),
            _nameTextField(),
            const SizedBox(height: 15.0),
            _userTextField(),
            const SizedBox(height: 15.0),
            _passwordTextField(),
            if(_isProfessional) const SizedBox(height: 15.0),
            if(_isProfessional) const SizedBox(height: 15.0),
            if(_isProfessional) _degreeCodeTextField(),
            if(_isProfessional) const SizedBox(height: 15.0),
            if(_isProfessional) _cvFileField(),
            if(_isProfessional) _professionAutocompleteTextField(),
            const SizedBox(height: 20.0),
            _buttonRegister(),
            const SizedBox(height: 20.0),
            Row(
                children: const [
                  Expanded(
                      child: Divider(
                          thickness: 2,
                          color: Colors.black,
                          indent: 40
                      )
                  ),
                  Text("   O   "),
                  Expanded(
                      child: Divider(
                          thickness: 2,
                          color: Colors.black,
                          endIndent: 40
                      )
                  ),
                ]
            ),
            const SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Continuar con Google. ', textAlign: TextAlign.right, ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _professionAutocompleteTextField() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Profesiones', textAlign: TextAlign.left, textScaleFactor: 1.2,),
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
                    _professionEditingController.text = "";
                    if(_professionList.contains(selection)) return;
                    if(_professionList.length > 3 ) {
                      Fluttertoast.showToast(
                          msg: "Máximo 3 profesiones",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      return;
                    }
                    setState(() {
                      _professionList = [..._professionList, selection];
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
                Container(
                    //padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: _professionList.isEmpty ?
                    const Text("No hay ninguna profesión seleccionada")
                        :ListView.builder(
                        padding: EdgeInsets.only(top: 0, left: 0),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _professionList.length,
                        itemBuilder: (context, index) {
                          return Chip(
                            elevation: 20,
                            padding: EdgeInsets.all(8),
                            backgroundColor: Colors.greenAccent[100],
                            shadowColor: Colors.black,
                            avatar: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://thumbs.dreamstime.com/b/tiempo-de-trabajo-logo-icon-design-128547025.jpg"), //NetworkImage
                            ), //CircleAvatar
                            label: Text(
                              _professionList[index],
                              style: TextStyle(fontSize: 14),
                            ),
                            deleteIcon: Icon(Icons.delete),
                            onDeleted: (){
                              _professionList.remove(_professionList[index]);
                              setState(() {
                                _professionList = [..._professionList];
                              });
                            },

                          );//Chi
                        }
                    ),
                    /*Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                      ],
                    )*/),
                ],
            ));
      },
    );
  }


  Widget _nameTextField() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Nombres', textAlign: TextAlign.left, textScaleFactor: 1.2,),
                SizedBox(height: 8.0),
                TextField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Nombres',
                    //labelText: "Correo",
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(40.0),
                      ),
                    ),
                  ),
                  controller: _nameController,
                ),

              ],
            ));
      },
    );
  }
  Widget _degreeCodeTextField() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Código de titulación(Opcional)', textAlign: TextAlign.left, textScaleFactor: 1.2,),
                SizedBox(height: 8.0),
                TextField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Código de titulación (si posee)',
                    //labelText: "Correo",
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(40.0),
                      ),
                    ),
                  ),
                  controller: _degreeCodeController,
                ),

              ],
            ));
      },
    );
  }

  Widget _userTextField() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Correo Electrónico', textAlign: TextAlign.left, textScaleFactor: 1.2,),
                SizedBox(height: 8.0),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    prefixIcon: Icon(Icons.email),
                    hintText: 'ejemplo@com.com',
                    //labelText: "Correo",
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(40.0),
                      ),
                    ),
                  ),
                  controller: _emailController,
                ),

              ],
            ));
      },
    );
  }

  Widget _cvFileField() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('CV (PDF)', textAlign: TextAlign.left, textScaleFactor: 1.2,),
                const SizedBox(height: 8.0),
                /*TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    prefixIcon: Icon(Icons.email),
                    hintText: 'ejemplo@com.com',
                    //labelText: "Correo",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(40.0),
                      ),
                    ),
                  ),
                  controller: _emailController,
                ),*/
                Text(pickedFile!.name),
                ElevatedButton(
                    onPressed: selectFile,
                    child: const Text("Seleccionar archivo")
                )
              ],
            ));
      },
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if(result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Widget _passwordTextField() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Contraseña', textAlign: TextAlign.left, textScaleFactor: 1.2,),
              SizedBox(height: 8.0),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: Icon(Icons.remove_red_eye_sharp),
                    hintText: 'Contraseña',
                    //labelText: "Contraseña"
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(40.0),
                      ),
                    ),
                ),
                controller: _passwordController,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buttonRegister() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ElevatedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
            child: Text('Registrarme', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          ),
          style: ElevatedButton.styleFrom(
            //padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),
            backgroundColor: Colors.orange,
          ),
          onPressed: () {
            submitSignUp();
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );*/
          },
        );
      },
    );
  }

  Future<void> submitSignUp() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      if(_isProfessional){
        if(pickedFile.name == "") {
          Fluttertoast.showToast(
              msg: "Agregue CV",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
          return;
        }else if(_professionList.isEmpty){
          Fluttertoast.showToast(
              msg: "Agregue al menos una profesion/ocupación",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
          return;
        }
      }
      await BlocProvider.of<UserCubit>(context).submitSignUp(user: UserEntity(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: _isProfessional ? "trabajador" : "cliente" ,
        degreeCode: _degreeCodeController.text,
        professions: _professionList

      ), file2: pickedFile);
    }else{
      Fluttertoast.showToast(
          msg: "Llene todos los campos requeridos",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
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
