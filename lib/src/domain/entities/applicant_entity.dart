import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ApplicantEntity extends Equatable {
  final String? profession;
  final String? clientId;
  final String? requestId;
  final String? workerId;
  String? status;
  final String? date;
  final String? description;
  final String? salary;
  final String? availability;
  final String? aid;
  final String? clientName;
  final String? workerName;


  ApplicantEntity({
      this.profession,
      this.clientId,
      this.requestId,
      this.workerId,
      this.status,
      this.date,
      this.description,
      this.salary,
      this.availability,
      this.aid,
    this.clientName,
    this.workerName
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    profession,
    clientId,
    requestId,
    workerId,
    status,
    date,
    description,
    salary,
    availability,
    aid,
    workerName,
    clientName
  ];
}