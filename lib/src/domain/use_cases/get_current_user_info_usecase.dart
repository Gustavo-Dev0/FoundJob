

import 'package:work_app/src/domain/entities/user_entity.dart';

import '../repositories/firebase_repository.dart';

class GetCurrentUserInfoUseCase {

  final FirebaseRepository repository;

  GetCurrentUserInfoUseCase({required this.repository});

  Future<UserEntity> call()async{
    return repository.getCurrentUserInfo();
  }
}