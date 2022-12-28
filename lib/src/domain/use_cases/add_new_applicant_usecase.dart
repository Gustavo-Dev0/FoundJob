

import '../entities/applicant_entity.dart';
import '../entities/request_entity.dart';
import '../repositories/firebase_repository.dart';

class AddNewApplicantUseCase {

  final FirebaseRepository repository;

  AddNewApplicantUseCase({required this.repository});

  Future<void> call(ApplicantEntity applicantEntity, RequestEntity requestEntity)async{
    return repository.addNewApplicant(applicantEntity, requestEntity);
  }
}