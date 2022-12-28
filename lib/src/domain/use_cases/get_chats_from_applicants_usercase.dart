

import 'package:logger/logger.dart';
import 'package:work_app/src/domain/entities/applicant_entity.dart';

import '../entities/request_entity.dart';
import '../repositories/firebase_repository.dart';

class GetChatsFromApplicantsUseCase {

  final FirebaseRepository repository;

  GetChatsFromApplicantsUseCase({required this.repository});

  Future<List<ApplicantEntity>> call(String uid){
    return repository.getChatsFromApplicants(uid);
  }
}