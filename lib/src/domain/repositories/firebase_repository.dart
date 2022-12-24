

import '../entities/request_entity.dart';
import '../entities/user_entity.dart';

abstract class FirebaseRepository{
  Future<bool> isSignIn();
  Future<void> signIn(UserEntity user);
  Future<void> signUp(UserEntity user);
  Future<void> signOut();
  Future<String> getCurrentUId();
  Future<UserEntity> getCurrentUserInfo();
  Future<void> getCreateCurrentUser(UserEntity user);
  Future<void> addNewRequest(RequestEntity r);
  //Future<void> addNewNote(NoteEntity note);
  //Future<void> updateNote(NoteEntity note);
  //Future<void> deleteNote(NoteEntity note);
  Stream<List<RequestEntity>> getRequests(String uid);
}