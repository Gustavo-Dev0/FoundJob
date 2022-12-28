import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:work_app/src/domain/entities/applicant_entity.dart';
import 'package:work_app/src/domain/use_cases/add_new_request_usecase.dart';
import 'package:work_app/src/domain/use_cases/get_applicants_by_user_id_usercase.dart';
import 'package:work_app/src/domain/use_cases/get_requests_by_professions_usercase.dart';

import '../../../domain/entities/request_entity.dart';
import '../../../domain/use_cases/add_new_applicant_usecase.dart';
import '../../../domain/use_cases/contact_applicant_usercase.dart';
import '../../../domain/use_cases/get_chats_from_applicants_usercase.dart';
import '../../../domain/use_cases/get_requests_usercase.dart';

part 'request_state.dart';

class RequestCubit extends Cubit<RequestState> {
  //final UpdateNoteUseCase updateNoteUseCase;
  //final DeleteNoteUseCase deleteNoteUseCase;
  final GetRequestsUseCase getRequestsUseCase;
  final GetRequestsByProfessionUseCase getRequestsByProfessionUseCase;
  final GetApplicantsByUserIdUseCase getApplicantsByUserIdUseCase;
  final AddNewRequestUseCase addNewRequestUseCase;
  final AddNewApplicantUseCase addNewApplicantUseCase;
  final GetChatsFromApplicantsUseCase getChatsFromApplicantsUseCase;
  final ContactApplicantUseCase contactApplicantUserCase;
  RequestCubit({
    required this.getRequestsUseCase,
    required this.getRequestsByProfessionUseCase,
    required this.addNewRequestUseCase,
    required this.addNewApplicantUseCase,
    required this.getApplicantsByUserIdUseCase,
    required this.getChatsFromApplicantsUseCase,
    required this.contactApplicantUserCase
  }) : super(RequestInitial());


  Future<void> addRequest({required RequestEntity note})async{
    try{
      await addNewRequestUseCase.call(note);
    }on SocketException catch(_){
      emit(RequestFailure());
    }catch(_){
      emit(RequestFailure());
    }
  }

  Future<void> addApplicant({required ApplicantEntity applicantEntity, required RequestEntity requestEntity})async{
    try{
      await addNewApplicantUseCase.call(applicantEntity, requestEntity);
    }on SocketException catch(e){
      print(e.toString());
      emit(RequestFailure());
    }catch(e){
      print(e.toString());
      emit(RequestFailure());
    }
  }

  Future<void> contactApplicant({required ApplicantEntity applicantEntity})async{
    try{
      await contactApplicantUserCase.call(applicantEntity);
    }on SocketException catch(_){
      emit(RequestFailure());
    }catch(_){
      emit(RequestFailure());
    }
  }

  Future<void> getRequests({required String uid})async{
    emit(RequestLoading());
    try{
      getRequestsUseCase.call(uid).listen((requests) {
        emit(RequestLoaded(requests: requests));
      });
    }on SocketException catch(_){
      emit(RequestFailure());
    }catch(_){
      emit(RequestFailure());
    }
  }


  Future<void> getRequestsByProfession({required List<String> professions})async{
    emit(RequestLoading());
    try{
      var requests = await getRequestsByProfessionUseCase.call(professions);
      emit(RequestLoaded(requests: requests));
    }on SocketException catch(_){
      emit(RequestFailure());
    }catch(_){
      emit(RequestFailure());
    }
  }


  Future<void> getApplicantsByUserId({required String uid})async{
    emit(RequestLoading());
    try{
      var applicants = await getApplicantsByUserIdUseCase.call(uid);
      emit(ApplicantLoaded(applicants: applicants));
    }on SocketException catch(e){
      print(e.toString());
      emit(RequestFailure());
    }catch(e){
      print(e.toString());
      emit(RequestFailure());
    }
  }

  Future<void> getChatsFromApplicants({required String uid})async{
    emit(RequestLoading());
    try{
      var applicants = await getChatsFromApplicantsUseCase.call(uid);
      emit(ApplicantLoaded(applicants: applicants));
    }on SocketException catch(e){
      print(e.toString());
      emit(RequestFailure());
    }catch(e){
      print(e.toString());
      emit(RequestFailure());
    }
  }

}