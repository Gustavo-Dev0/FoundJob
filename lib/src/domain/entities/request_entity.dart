import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RequestEntity extends Equatable {
  final String? profession;
  final GeoPoint? ubication;
  final String? uid;
  final String? status;
  final String? date;
  final String? trabajadorUid;
  final String? requestId;
  final String? description;
  final String? clientName;
  final List<String>? applicantsList;


  RequestEntity({
      this.profession,
      this.ubication,
      this.uid,
      this.status="P",
      this.date,
      this.trabajadorUid,
      this.requestId,
      this.description,
      this.clientName,
      this.applicantsList = const []
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    profession,
    ubication,
    uid,
    status,
    date,
    trabajadorUid,
    requestId,
    description,
    clientName,
    applicantsList
  ];
}