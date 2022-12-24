import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:work_app/src/domain/entities/request_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../models/request_model.dart';
import '../models/user_model.dart';
import 'firebase_remote_data_source.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  FirebaseRemoteDataSourceImpl({required this.auth, required this.firestore});

  /*@override
  Future<void> addNewNote(NoteEntity noteEntity) async{
    final noteCollectionRef =
    firestore.collection("users").doc(noteEntity.uid).collection("notes");

    final noteId = noteCollectionRef.doc().id;

    noteCollectionRef.doc(noteId).get().then((note) {
      final newNote = NoteModel(
        uid: noteEntity.uid,
        noteId: noteId,
        note: noteEntity.note,
        time: noteEntity.time,
      ).toDocument();

      if (!note.exists) {

        noteCollectionRef.doc(noteId).set(newNote);

      }
      return;
    });
  }

  @override
  Future<void> deleteNote(NoteEntity noteEntity)async {
    final noteCollectionRef =
    firestore.collection("users").doc(noteEntity.uid).collection("notes");


    noteCollectionRef.doc(noteEntity.noteId).get().then((note) {
      if (note.exists){
        noteCollectionRef.doc(noteEntity. noteId).delete();
      }
      return;
    });

  }
*/
  @override
  Future<void> getCreateCurrentUser(UserEntity user) async{
    final userCollectionRef = firestore.collection("users");
    final uid=await getCurrentUId();
    await userCollectionRef.doc(uid).get().then((value) async {
      final newUser=UserModel(
        uid:uid ,
        status: user.status,
        email: user.email,
        name: user.name,
        role: user.role
      ).toDocument();
      if (!value.exists){
        await userCollectionRef.doc(uid).set(newUser);
      }
      return;
    });

  }

  Future<void> _createUserRegistered(UserEntity user) async{
    final userCollectionRef = firestore.collection("users");

    final newUser=UserModel(
      uid: user.uid ,
      status: user.status,
      email: user.email,
      name: user.name,
    ).toDocument();
    userCollectionRef.doc(user.uid).set(newUser).then((value) => Logger().d("Usuario guardado en firestore"));

  }

  @override
  Future<String> getCurrentUId() async => auth.currentUser!.uid;

  @override
  Stream<List<RequestEntity>> getRequests(String uid) {
    final noteCollectionRef=firestore.collection("users").doc(uid).collection("requests");


    final noteCollectionRef2=firestore.collection("users").where('role', isEqualTo: 'cliente');

    return noteCollectionRef2.snapshots().map((event){
      var a = event.docs.map((e) => e.get('uid')).toList();
      List<RequestModel> l = [];
      //Logger().wtf(a.toString());
      /*var x = 1;
      a.forEach((element) {
        //Logger().wtf(element);
        var a2 = firestore.collection("users").doc(element).collection("requests").snapshots().map((querySnap) {
          return querySnap.docs.map((docSnap) => RequestModel.fromSnapshot(docSnap)).toList();
        });

      while(true){
        if(x == 0){
          return l;
        }
      }*/
      var x = a.forEach((element) {
        //Logger().wtf(element);
        var a2 = firestore.collection("users").doc(element).collection("requests").snapshots().map((querySnap) {
          return querySnap.docs.map((docSnap) => RequestModel.fromSnapshot(docSnap)).toList();
        });

        Logger().wtf(a2.length);
        l.addAll(a2);
        /*a2.docs.forEach((element) {

          var b = RequestModel.fromSnapshot(element);
          Logger().wtf(b.date);
          l.add(b);
        });*/

        /*await a2.docs.map((valued){
          Logger().wtf("yjuyyu");
          //var b = valued.docs.map((docSnap) => RequestModel.fromSnapshot(docSnap)).toList();
          var b = RequestModel.fromSnapshot(valued);
          l.add(b);
        });*/
        //Logger().wtf(firestore.collection("users").doc(element).collection("requests").snapshots().length);
      });
      Logger().wtf("fwef");
      return l;
    });

    /*get().then((value) {
      return value.docs.forEach((doc) {
        firestore.collection("users").doc(doc.id).collection("requests").snapshots().map((valued){
          return valued.docs.map((docSnap) => RequestModel.fromSnapshot(docSnap)).toList();
        });
      });
    });*/

    /*return noteCollectionRef.snapshots().map((querySnap) {
      return querySnap.docs.map((docSnap) => RequestModel.fromSnapshot(docSnap)).toList();
    });*/
  }

  @override
  Future<bool> isSignIn() async => auth.currentUser?.uid !=null;

  @override
  Future<void> signIn(UserEntity user) async =>
      auth.signInWithEmailAndPassword(email: user.email!, password: user.password!);

  @override
  Future<void> signOut()  async =>
      auth.signOut();

  @override
  Future<void> signUp(UserEntity user) async =>
      auth.createUserWithEmailAndPassword(email: user.email!, password: user.password!);

  @override
  Future<UserEntity> getCurrentUserInfo() async {
    final userCollectionRef = firestore.collection("users");
    final uid= await getCurrentUId();
    return userCollectionRef.doc(uid).get().then((value){
      //Logger().wtf(uid+"   "+UserModel.fromSnapshot(value).role!);
      if (!value.exists){
        return throw Error();
      }

      return  Future<UserEntity>.value(UserModel.fromSnapshot(value));
    });
    //return Future<UserEntity>.value(UserEntity());
  }

  @override
  Future<void> addNewRequest(RequestEntity requestEntity) async {
    final requestCollectionRef =
    firestore.collection("users").doc(requestEntity.uid).collection("requests");

    final requestId = requestCollectionRef.doc().id;

    requestCollectionRef.doc(requestId).get().then((request) {
      //Logger().wtf(requestEntity.profession);
      final newRequest = RequestModel(
        requestId: requestId,
        date: requestEntity.date,
        profession: requestEntity.profession,
        status: requestEntity.status,
        trabajadorUid: requestEntity.trabajadorUid,
        ubication: requestEntity.ubication,
        uid: requestEntity.uid,
        description: requestEntity.description
      ).toDocument();

      if (!request.exists) {

        requestCollectionRef.doc(requestId).set(newRequest);

      }
      return;
    });
  }

  /*@override
  Stream<List<RequestEntity>> getRequestsByProfession(List<String> professions) {
    CollectionReference usersRef = firestore.collection("users");
    Query query = usersRef.where('role', isEqualTo: 'cliente');
    
    final noteCollectionRef=firestore.collection("users").doc(uid).collection("requests");
    
    query.get().then((querySnap) {
      querySnap.docs.map((e){
        Logger().wtf(e.data())
      });
    });

    return noteCollectionRef.snapshots().map((querySnap) {
      return querySnap.docs.map((docSnap) => RequestModel.fromSnapshot(docSnap)).toList();
    });
  }*/
      /*{
      auth.createUserWithEmailAndPassword(email: user.email!, password: user.password!).then((value) async => {
        await _createUserRegistered(UserEntity(uid: value.user?.uid, email: user.email, name: user.name, password: user.password, status: user.status))
      })
  };*/



  /*@override
  Future<void> updateNote(NoteEntity note)async {
    Map<String,dynamic> noteMap=Map();
    final noteCollectionRef=firestore.collection("users").doc(note.uid).collection("notes");

    if (note.note!=null) noteMap['note']=note.note;
    if (note.time!=null) noteMap['time'] =note.time;

    noteCollectionRef.doc(note.noteId).update(noteMap);
  }*/
}