

import 'package:file_picker/file_picker.dart';

import '../entities/request_entity.dart';
import '../repositories/firebase_repository.dart';

class SaveCVUseCase {

  final FirebaseRepository repository;

  SaveCVUseCase({required this.repository});

  Future<void> call(PlatformFile cvPdf, String uid)async{
    return repository.saveCVFromProfessional(cvPdf, uid);
  }
}