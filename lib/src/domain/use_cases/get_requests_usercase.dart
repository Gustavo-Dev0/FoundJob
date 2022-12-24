

import '../entities/request_entity.dart';
import '../repositories/firebase_repository.dart';

class GetRequestsUseCase {

  final FirebaseRepository repository;

  GetRequestsUseCase({required this.repository});

  Stream<List<RequestEntity>> call(String uid){
    return repository.getRequests(uid);
  }
}