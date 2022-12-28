import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:work_app/src/domain/use_cases/get_current_uid_usecase.dart';
import 'package:work_app/src/domain/use_cases/save_cv_usercase.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/use_cases/get_create_current_user_usecase.dart';
import '../../../domain/use_cases/sign_in_usecase.dart';
import '../../../domain/use_cases/sign_up_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final SignInUseCase signInUseCase;
  final SignUPUseCase signUPUseCase;
  final GetCreateCurrentUserUsecase getCreateCurrentUserUseCase;
  final GetCurrentUidUseCase getCurrentUidUseCase;
  final SaveCVUseCase saveCVUseCase;
  UserCubit({required this.signUPUseCase,required this.signInUseCase,required this.getCreateCurrentUserUseCase,required this.getCurrentUidUseCase ,required this.saveCVUseCase}) : super(UserInitial());

  Future<void> submitSignIn({required UserEntity user})async{
    emit(UserLoading());
    try {
      await signInUseCase.call(user);
      emit(UserSuccess());
    }on SocketException catch(_){
      emit(UserFailure(error: _.toString()));
    } catch(_){
      emit(UserFailure(error: _.toString()));
    }
  }
  Future<void> submitSignUp({required UserEntity user, required PlatformFile file2})async{
    emit(UserLoading());
    try {
      await signUPUseCase.call(user);
      await getCreateCurrentUserUseCase.call(user);
      if(user.role == "trabajador"){
        String uid = await getCurrentUId();
        await saveCVUseCase.call(file2, uid);
      }
      emit(UserSuccess());
    }on SocketException catch(_){
      Logger().w(_);
      emit(UserFailure(error: _.toString()));
    } catch(_){
      Logger().w(_);
      emit(UserFailure(error: _.toString()));
    }

  }

  Future<void> saveCV({required PlatformFile cvPdf, required String uid})async{
    emit(UserLoading());
    try {
      await saveCVUseCase.call(cvPdf, uid);
      emit(UserSuccess());
    }on SocketException catch(_){
      Logger().w(_);
      emit(UserFailure(error: _.toString()));
    } catch(_){
      Logger().w(_);
      emit(UserFailure(error: _.toString()));
    }

  }

  Future<String> getCurrentUId(){
    return getCurrentUidUseCase.call();
  }

  Future<void> submitGoogleSignIn() async {
    emit(UserLoading());

    try {
      //final idCurrent = await getCurrentUidUseCase.call();
      final isSignIn= FirebaseAuth.instance.currentUser?.uid !=null;
      if (isSignIn) {
        emit(UserSuccess());
      }else{
        emit(UserFailure(error: "Error en inicio de sesión con Google"));
      }
    }on SocketException catch(_){
      emit(UserFailure(error: _.toString()));
    } catch(_){
      emit(UserFailure(error: _.toString()));
    }
  }


  Future<void> submitGoogleSignUp({required UserEntity user, required PlatformFile file2})async{
    emit(UserLoading());
    try {
      user.name = FirebaseAuth.instance.currentUser?.displayName!;
      user.email = FirebaseAuth.instance.currentUser?.email!;
      await getCreateCurrentUserUseCase.call(user);
      if(user.role == "trabajador"){
        String uid = await getCurrentUId();
        await saveCVUseCase.call(file2, uid);
      }
      emit(UserSuccess());
    }on SocketException catch(_){
      Logger().w(_);
      emit(UserFailure(error: _.toString()));
    } catch(_){
      Logger().w(_);
      emit(UserFailure(error: _.toString()));
    }

  }

  submitFacebookSignIn() {}
}