import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:work_app/src/data/remote/models/user_model.dart';

import 'messages_container.dart';

class ChatBodyPage extends StatefulWidget {
  String email;
  String applicantId;
  bool isClient;
  ChatBodyPage({required this.email, required this.applicantId, required this.isClient});
  @override
  _ChatBodyPageState createState() => _ChatBodyPageState(email: email, applicantId: applicantId);
}

class _ChatBodyPageState extends State<ChatBodyPage> {
  String email;
  String applicantId;
  _ChatBodyPageState({required this.email, required this.applicantId});

  final fs = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final TextEditingController message = new TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? nameOwn;

  @override
  void initState() {
    fs.collection('users').doc(email).get().then((value) {
      //UserModel.fromSnapshot(value);
      setState(() {
        nameOwn = value['name'];
      });
      //().wtf(nameOwn);
    });
    //nameOwn = x[0].name;
    //Logger().wtf(nameOwn);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('BuscaChamba'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
      ),
      body: nameOwn != null ? Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded( flex: 1,child: Container(
              //height: MediaQuery.of(context).size.height,
              child: MessagesContainer(
                email: email,
                applicantId: applicantId,
                scrollController: _scrollController,
                isClient: widget.isClient,
              ),
            ),),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: message,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.orange[100],
                      hintText: 'message',
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.orange),
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: new BorderSide(color: Colors.orange),
                        borderRadius: new BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {},
                    onSaved: (value) {
                      message.text = value!;
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (message.text.isNotEmpty) {
                      fs.collection("applicants").doc(applicantId).collection('messages').doc().set({
                        'message': message.text.trim(),
                        'time': DateTime.now(),
                        'email': email,
                        'name': nameOwn,
                      });

                      message.clear();
                      setState(() {
                        _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.fastOutSlowIn
                        );
                      });
                      setState(() {
                        _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.fastOutSlowIn
                        );
                      });
                    }
                  },
                  icon: Icon(Icons.send_sharp),
                ),
              ],
            )
          ],
        ),
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}