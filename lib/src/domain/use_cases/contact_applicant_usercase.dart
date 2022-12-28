

import 'package:file_picker/file_picker.dart';
import 'package:work_app/src/domain/entities/applicant_entity.dart';

import '../entities/request_entity.dart';
import '../repositories/firebase_repository.dart';

class ContactApplicantUseCase {

  final FirebaseRepository repository;

  ContactApplicantUseCase({required this.repository});

  Future<void> call(ApplicantEntity applicantEntity)async{
    return repository.contactApplicant(applicantEntity);
  }
}