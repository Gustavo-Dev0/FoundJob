import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/user_entity.dart';

class UserModel extends UserEntity{
  UserModel({
    final String? name,
    final String? email,
    final String? uid,
    final String? status,
    final String? password,
    final String? role,
  }):super(
      uid: uid,
      name: name,
      email: email,
      password: password,
      status: status,
      role: role
  );

  factory UserModel.fromSnapshot(DocumentSnapshot documentSnapshot){
    return UserModel(
      status: documentSnapshot.get('status'),
      name: documentSnapshot.get('name'),
      uid: documentSnapshot.get('uid'),
      email: documentSnapshot.get('email'),
      role: documentSnapshot.get('role')
    );
  }

  Map<String,dynamic> toDocument(){
    return {
      "status":status,
      "uid":uid,
      "email":email,
      "name":name,
      "role":role
    };
  }

}