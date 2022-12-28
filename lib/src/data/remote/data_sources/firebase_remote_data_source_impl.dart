import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/src/platform_file.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:work_app/src/data/remote/models/applicant_model.dart';
import 'package:work_app/src/domain/entities/applicant_entity.dart';
import 'package:work_app/src/domain/entities/request_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../models/request_model.dart';
import '../models/user_model.dart';
import 'firebase_remote_data_source.dart';
import 'dart:io';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  FirebaseRemoteDataSourceImpl({required this.auth, required this.firestore});

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
        role: user.role,
        degreeCode: user.degreeCode,
        professions: user.professions
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
    return noteCollectionRef.snapshots().map((querySnap) {
      return querySnap.docs.map((docSnap) => RequestModel.fromSnapshot(docSnap))
          .toList();
    });
  }

  @override
  Future<List<RequestEntity>> getRequestsByProfession(List<String> professions) async {
    List<RequestEntity> l = [];
    UserEntity userP = await getCurrentUserInfo();
    Logger().wtf(professions.toString());
    var p1 = await firestore.collection("users").get();
    for(var e in p1.docs){
      var p2 = await firestore.collection("users").doc(e.id).collection('requests').where('profession', whereIn: userP.professions).get();
      if(p2.size == 0)  continue;
      for(var element in p2.docs){
        l.add(RequestModel.fromSnapshot(element));
      }
    }
    return l;
  }
  
  @override
  Future<bool> isSignIn() async => auth.currentUser?.uid !=null;

  @override
  Future<void> signIn(UserEntity user) async {
    var x = auth;
    try {
      await auth.signInWithEmailAndPassword(email: user.email!, password: user.password!);
    } on FirebaseAuthException catch(e){
      var code = e.code;
        Logger().i(code.toString());
        return Future.error(code.toString());
    }
  }


  @override
  Future<void> signOut()  async {
    auth.signOut();
    GoogleSignIn().signOut();
  }


  @override
  Future<void> signUp(UserEntity user) async =>
      auth.createUserWithEmailAndPassword(email: user.email!, password: user.password!);

  @override
  Future<UserEntity> getCurrentUserInfo() async {
    final userCollectionRef = firestore.collection("users");
    final uid= await getCurrentUId();
    final userRef = await userCollectionRef.doc(uid).get();
    if (!userRef.exists){
      return Future<UserEntity>.value(UserModel(uid: "0000000000"));
    }
    return  Future<UserEntity>.value(UserModel.fromSnapshot(userRef));
  }

  @override
  Future<void> addNewRequest(RequestEntity requestEntity) async {
    final requestCollectionRef =
    firestore.collection("users").doc(requestEntity.uid).collection("requests");

    final username = await firestore.collection("users").doc(requestEntity.uid).get();
    var nyx = username.get("name").toString();

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
        description: requestEntity.description,
        clientName: nyx,
      ).toDocument();

      if (!request.exists) {

        requestCollectionRef.doc(requestId).set(newRequest);

      }
      return;
    });
  }

  @override
  Future<void> addNewApplicant(ApplicantEntity applicantEntity, RequestEntity requestEntity) async {
    if(requestEntity.applicantsList!.contains(applicantEntity.workerId))  return;

    final applicantCollectionRef = firestore.collection("applicants");
    final applicantId = applicantCollectionRef.doc().id;

    final username = await firestore.collection("users").doc(applicantEntity.workerId).get();
    var nyx = username.get("name").toString();

    final newApplicant = ApplicantModel(
        status: applicantEntity.status,
        availability: applicantEntity.availability,
        clientId: applicantEntity.clientId,
        description: applicantEntity.description,
        profession: applicantEntity.profession,
        requestId: applicantEntity.requestId,
        salary: applicantEntity.salary,
        workerId: applicantEntity.workerId,
        aid: applicantId,
        date: DateTime.now().toString(),
      clientName: applicantEntity.clientName,
      workerName: nyx
    ).toDocument();

    await applicantCollectionRef.doc(applicantId).set(newApplicant);


    //Logger().wtf("Mission 1 complete");

    Map<String,dynamic> requestMap = {};

    final requestCollectionRef = firestore.collection('users')
        .doc(requestEntity.uid)
        .collection('requests');
        //.doc(requestEntity.requestId);

    if (requestEntity.applicantsList != null) {
      requestMap['applicantsList'] = [...?requestEntity.applicantsList, applicantEntity.workerId];
    }

    await requestCollectionRef.doc(requestEntity.requestId).update(requestMap);
    requestEntity.applicantsList!.add(applicantEntity.workerId!);
    //Logger().wtf("Mission 2 complete");
  }

  @override
  Future<void> saveCVFromProfessional(PlatformFile cvPdf, String uid) async {
    final path = 'cv/$uid.pdf';
    final file = File(cvPdf.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
    return ;
  }

  @override
  Future<List<ApplicantEntity>> getApplicantsByUserId(String userId) async {
    List<ApplicantEntity> l = [];
    var p1 = await firestore.collection("users").doc(userId).collection('requests').get();
    List<String> requestIdFromuserList = [];
    for(var k in p1.docs){
      requestIdFromuserList.add(k.id);
    }
    if(requestIdFromuserList.isEmpty){
      return l;
    }

    var p2 = await firestore.collection("applicants").where("requestId", whereIn: requestIdFromuserList).get();
    for(var d in p2.docs){
      ApplicantEntity temp = ApplicantModel.fromSnapshot(d);
      l.add(temp);
    }
    return l;
  }

  @override
  Future<List<ApplicantEntity>> getChatsFromApplicants(String userId) async {
    List<ApplicantEntity> l = [];
    var p1 = await firestore.collection("applicants").where("clientId", isEqualTo: userId).where('status', isEqualTo: 'C').get();
    var p2 = await firestore.collection("applicants").where("workerId", isEqualTo: userId).where('status', isEqualTo: 'C').get();

    for(var d in p1.docs){
      ApplicantEntity temp = ApplicantModel.fromSnapshot(d);
      l.add(temp);
    }
    for(var d in p2.docs){
      ApplicantEntity temp = ApplicantModel.fromSnapshot(d);
      l.add(temp);
    }
    return l;
  }

  @override
  Future<void> contactApplicant(ApplicantEntity applicantEntity) async {
    final applicantCollectionRef =
    firestore.collection("applicants");

    Map<String,dynamic> applicantMap = {};
    applicantMap['status'] = "C";
    await applicantCollectionRef.doc(applicantEntity.aid).update(applicantMap);
  }

}