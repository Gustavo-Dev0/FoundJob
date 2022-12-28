

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/entities/applicant_entity.dart';
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
  Stream<List<RequestEntity>> getRequests(String uid);
  Future<List<RequestEntity>> getRequestsByProfession(List<String> professions);
  Future<void> saveCVFromProfessional(PlatformFile cvPdf, String uid);
  Future<void> addNewApplicant(ApplicantEntity applicantEntity, RequestEntity requestEntity);
  Future<List<ApplicantEntity>> getApplicantsByUserId(String userId);
  Future<List<ApplicantEntity>> getChatsFromApplicants(String userId);
  Future<void> contactApplicant(ApplicantEntity applicantEntity);

}