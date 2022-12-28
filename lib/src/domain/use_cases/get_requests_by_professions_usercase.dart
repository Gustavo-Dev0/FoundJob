

import 'package:logger/logger.dart';

import '../entities/request_entity.dart';
import '../repositories/firebase_repository.dart';

class GetRequestsByProfessionUseCase {

  final FirebaseRepository repository;

  GetRequestsByProfessionUseCase({required this.repository});

  Future<List<RequestEntity>> call(List<String> professions){
    return repository.getRequestsByProfession(professions);
  }
}