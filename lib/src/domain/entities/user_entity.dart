import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  String? name;
  String? email;
  final String? uid;
  final String? status;
  final String? role;
  final String? password;
  final String? degreeCode;
  final List<String>? professions;

  UserEntity({
    this.name,
    this.email,
    this.uid,
    this.status = "H",
    this.role,
    this.password,
    this.degreeCode,
    this.professions
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    name,
    email,
    uid,
    status,
    password,
    degreeCode,
    professions
  ];
}