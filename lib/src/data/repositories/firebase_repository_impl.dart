
import 'package:work_app/src/domain/entities/request_entity.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/firebase_repository.dart';
import '../remote/data_sources/firebase_remote_data_source.dart';

class FirebaseRepositoryImpl extends FirebaseRepository{
  final FirebaseRemoteDataSource remoteDataSource;

  FirebaseRepositoryImpl({required this.remoteDataSource});
  /*@override
  Future<void> addNewNote(NoteEntity note) async =>
      remoteDataSource.addNewNote(note);

  @override
  Future<void> deleteNote(NoteEntity note) async =>
      remoteDataSource.deleteNote(note);
*/
  @override
  Future<void> getCreateCurrentUser(UserEntity user) async =>
      remoteDataSource.getCreateCurrentUser(user);

  @override
  Future<String> getCurrentUId() async =>
      remoteDataSource.getCurrentUId();

  /*@override
  Stream<List<NoteEntity>> getNotes(String uid) =>
      remoteDataSource.getNotes(uid);
*/
  @override
  Future<bool> isSignIn() async =>
      remoteDataSource.isSignIn();

  @override
  Future<void> signIn(UserEntity user) async =>
      remoteDataSource.signIn(user);

  @override
  Future<void> signOut() async =>
      remoteDataSource.signOut();

  @override
  Future<void> signUp(UserEntity user) async =>
      remoteDataSource.signUp(user);

  @override
  Future<UserEntity> getCurrentUserInfo() {

    return remoteDataSource.getCurrentUserInfo();

  }

  @override
  Future<void> addNewRequest(RequestEntity r) =>
      remoteDataSource.addNewRequest(r);

  @override
  Stream<List<RequestEntity>> getRequests(String uid) =>
      remoteDataSource.getRequests(uid);
  /*@override
  Future<void> updateNote(NoteEntity note) async =>
      remoteDataSource.updateNote(note);
*/
}