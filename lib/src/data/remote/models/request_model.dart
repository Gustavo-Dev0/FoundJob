import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/request_entity.dart';

class RequestModel extends RequestEntity{
  RequestModel({
    final String? profession,
    final GeoPoint? ubication,
    final String? uid,
    final String? status,
    final String? date,
    final String? trabajadorUid,
    final String? requestId,
    final String? description,
    final String? clientName,
    final List<String>? applicantsList
  }):super(
    profession: profession,
    ubication: ubication,
    uid: uid,
    status: status,
    date: date,
    trabajadorUid: trabajadorUid,
    requestId: requestId,
    description: description,
    clientName: clientName,
    applicantsList: applicantsList
  );

  factory RequestModel.fromSnapshot(DocumentSnapshot documentSnapshot){
    return RequestModel(
      profession: documentSnapshot.get('profession'),
      ubication: documentSnapshot.get('ubication'),
      uid: documentSnapshot.get('uid'),
      status: documentSnapshot.get('status'),
      date: documentSnapshot.get('date'),
      trabajadorUid: documentSnapshot.get('trabajadorUid'),
      requestId: documentSnapshot.get('requestId'),
      description: documentSnapshot.get('description'),
      clientName: documentSnapshot.get('clientName'),
      applicantsList: documentSnapshot.get('applicantsList') == null ? [] : List.from(documentSnapshot.get('applicantsList')),
    );
  }

  Map<String,dynamic> toDocument(){
    return {
      "profession":profession,
      "ubication":ubication,
      "uid":uid,
      "status":status,
      "date":date,
      "trabajadorUid":trabajadorUid,
      "requestId": requestId,
      "description": description,
      "clientName": clientName,
      "applicantsList": applicantsList
    };
  }

}