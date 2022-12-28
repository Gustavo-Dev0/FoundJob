import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_app/src/domain/entities/applicant_entity.dart';

import '../../../domain/entities/request_entity.dart';

class ApplicantModel extends ApplicantEntity{
  ApplicantModel({
    final String? profession,
    final String? clientId,
    final String? requestId,
    final String? workerId,
    final String? status,
    final String? date,
    final String? description,
    final String? salary,
    final String? availability,
    final String? aid,
    final String? clientName,
    final String? workerName,
  }):super(
      profession: profession,
      clientId: clientId,
      requestId: requestId,
      workerId: workerId,
      status: status,
      date: date,
      description: description,
      salary: salary,
      availability: availability,
      aid: aid,
    clientName: clientName,
    workerName: workerName
  );

  factory ApplicantModel.fromSnapshot(DocumentSnapshot documentSnapshot){
    return ApplicantModel(
        profession: documentSnapshot.get('profession'),
        clientId: documentSnapshot.get('clientId'),
        requestId: documentSnapshot.get('requestId'),
        workerId: documentSnapshot.get('workerId'),
        date: documentSnapshot.get('date'),
        description: documentSnapshot.get('description'),
        salary: documentSnapshot.get('salary'),
        availability: documentSnapshot.get('availability'),
        status: documentSnapshot.get('status'),
        aid: documentSnapshot.get('aid'),
      workerName: documentSnapshot.get('workerName'),
      clientName: documentSnapshot.get('clientName'),
    );
  }

  Map<String,dynamic> toDocument(){
    return {
      "profession":profession,
      "clientId":clientId,
      "requestId":requestId,
      "workerId":workerId,
      "date":date,
      "description":description,
      "salary": salary,
      "availability": availability,
      "status": status,
      "aid": aid,
      "clientName": clientName,
      "workerName": workerName,
    };
  }

}