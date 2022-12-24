

import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/entities/request_entity.dart';
import '../../../domain/entities/user_entity.dart';

abstract class FirebaseRemoteDataSource{
  Future<bool> isSignIn();
  Future<void> signIn(UserEntity user);
  Future<void> signUp(UserEntity user);
  Future<void> signOut();
  Future<String> getCurrentUId();
  Future<void> getCreateCurrentUser(UserEntity user);

  Future<UserEntity> getCurrentUserInfo();

  Future<void> addNewRequest(RequestEntity note);
  //Future<void> addNewNote(NoteEntity note);
  //Future<void> updateNote(NoteEntity note);
  //Future<void> deleteNote(NoteEntity note);
  Stream<List<RequestEntity>> getRequests(String uid);
  //Stream<List<RequestEntity>> getRequestsByProfession(List<String> professions);
}