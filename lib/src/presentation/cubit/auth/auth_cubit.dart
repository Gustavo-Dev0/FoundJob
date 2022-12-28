import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:work_app/src/domain/entities/user_entity.dart';
import 'package:work_app/src/domain/use_cases/get_create_current_user_usecase.dart';
import 'package:work_app/src/domain/use_cases/get_current_user_info_usecase.dart';

import '../../../domain/use_cases/get_current_uid_usecase.dart';
import '../../../domain/use_cases/is_sign_in_usecase.dart';
import '../../../domain/use_cases/sign_out_usecase.dart';
import '../profile/profile_cubit.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final GetCurrentUidUseCase getCurrentUidUseCase;
  final GetCurrentUserInfoUseCase getCurrentUserInfoUseCase;
  final IsSignInUseCase isSignInUseCase;
  final SignOutUseCase signOutUseCase;
  AuthCubit({required this.getCurrentUserInfoUseCase, required this.isSignInUseCase,required this.signOutUseCase,required this.getCurrentUidUseCase}) : super(AuthInitial());

  Future<void> appStarted()async{
    try{
      final isSignIn=await isSignInUseCase.call();
      if (isSignIn){

        //final uid=await getCurrentUidUseCase.call();
        final userProfile = await getCurrentUserInfoUseCase.call();
        if(userProfile.uid == "0000000000"){
          emit(AuthenticatedWithoutRegister());
        }else{
          emit(Authenticated(uid: userProfile.uid!, profile: userProfile));
        }
        //Logger().wtf("resultadoa: "+uid+"  "+userProfile.role!);
        /*final userProfile = await getCurrentUserInfoUseCase.call();*/

      }else{
        emit(UnAuthenticated());
      }


    }on SocketException catch(_){
      emit(UnAuthenticated());
    }


  }


  Future<void> loggedIn()async{
    try{
      final uid=await getCurrentUidUseCase.call();
      /*final userProfile = await getCurrentUserInfoUseCase.call();*/
      final userProfile = await getCurrentUserInfoUseCase.call();
      Logger().wtf("resultadoIngreso: "+uid+"  "+userProfile.role!);
      emit(Authenticated(uid: uid, profile: userProfile));
    }on SocketException catch(_){
      emit(UnAuthenticated());
    }

  }
  Future<void> loggedOut()async{
    try{
      await signOutUseCase.call();
      emit(UnAuthenticated());
    }on SocketException catch(_){
      emit(UnAuthenticated());
    }

  }
}