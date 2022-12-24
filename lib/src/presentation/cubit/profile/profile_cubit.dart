import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:work_app/src/domain/entities/user_entity.dart';

import '../../../domain/use_cases/get_current_user_info_usecase.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetCurrentUserInfoUseCase getCurrentUserInfoUseCase;
  ProfileCubit({required this.getCurrentUserInfoUseCase}) : super(ProfileInitial());


  Future<void> getCurrentUserInfo()async{
    emit(ProfileLoading());
    try{
      final userProfile = await getCurrentUserInfoUseCase.call();
      emit(ProfileLoaded(userProfile: userProfile));
    }on SocketException catch(_){
      emit(ProfileFailure());
    }catch(_){
      emit(ProfileFailure());
    }
  }

  Future<UserEntity> getCurrentUserInfoDirect() async {
    return await getCurrentUserInfoUseCase.call();
  }

}