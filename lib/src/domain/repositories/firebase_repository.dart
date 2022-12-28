

import 'package:file_picker/file_picker.dart';

import '../entities/applicant_entity.dart';
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
  Future<List<RequestEntity>> getRequestsByProfession(List<String> professions);
  Future<void> saveCVFromProfessional(PlatformFile cvPdf, String uid);
  Future<void> addNewApplicant(ApplicantEntity applicantEntity, RequestEntity requestEntity);
  Future<List<ApplicantEntity>> getApplicantsByUserId(String userId);
  Future<List<ApplicantEntity>> getChatsFromApplicants(String userId);
  Future<void> contactApplicant(ApplicantEntity applicantEntity);
}