import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class MessagesContainer extends StatefulWidget {
  String email;
  String applicantId;
  ScrollController scrollController;
  bool isClient;
  MessagesContainer({required this.email, required this.applicantId, required this.scrollController, required this.isClient});
  @override
  _MessagesContainerState createState() => _MessagesContainerState(email: email, applicantId: applicantId);
}

class _MessagesContainerState extends State<MessagesContainer> {
  String email;
  String applicantId;

  _MessagesContainerState({required this.email, required this.applicantId});

  Stream<QuerySnapshot>? _messageStream;
  @override
  void initState() {
    Stream<QuerySnapshot> _messageStreamp = FirebaseFirestore.instance
        .collection('applicants')
        .doc(applicantId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
    setState(() {
      _messageStream = _messageStreamp;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _messageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("something is wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        var r = SingleChildScrollView(
            controller: widget.scrollController,
            child: ListView.builder(
              //controller: widget.scrollController,
              itemCount: snapshot.data!.docs.length,
              //scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              primary: true,
              itemBuilder: (_, index) {
                QueryDocumentSnapshot qs = snapshot.data!.docs[index];
                Timestamp t = qs['time'];
                DateTime d = t.toDate();
                return Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Column(
                    crossAxisAlignment: email == qs['email']
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 300,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Colors.purple,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text(
                            qs['name'],
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 200,
                                child: Text(
                                  qs['message'],
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Text(
                                d.hour.toString() + ":" + d.minute.toString(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },

            )
        );
        return r;

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          physics: ScrollPhysics(),
          shrinkWrap: true,
          primary: true,
          itemBuilder: (_, index) {
            QueryDocumentSnapshot qs = snapshot.data!.docs[index];
            Timestamp t = qs['time'];
            DateTime d = t.toDate();
            print(d.toString());
            return Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: email == qs['email']
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.purple,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(
                        qs['name'],
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200,
                            child: Text(
                              qs['message'],
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Text(
                            d.hour.toString() + ":" + d.minute.toString(),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}