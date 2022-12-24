

import '../entities/request_entity.dart';
import '../repositories/firebase_repository.dart';

class AddNewRequestUseCase {

  final FirebaseRepository repository;

  AddNewRequestUseCase({required this.repository});

  Future<void> call(RequestEntity r)async{
    return repository.addNewRequest(r);
  }
}