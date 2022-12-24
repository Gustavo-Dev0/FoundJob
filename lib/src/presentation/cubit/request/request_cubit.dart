import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:work_app/src/domain/use_cases/add_new_request_usecase.dart';

import '../../../domain/entities/request_entity.dart';
import '../../../domain/use_cases/get_requests_usercase.dart';

part 'request_state.dart';

class RequestCubit extends Cubit<RequestState> {
  //final UpdateNoteUseCase updateNoteUseCase;
  //final DeleteNoteUseCase deleteNoteUseCase;
  final GetRequestsUseCase getRequestsUseCase;
  final AddNewRequestUseCase addNewRequestUseCase;
  RequestCubit({required this.getRequestsUseCase,/*required this.deleteNoteUseCase,required this.updateNoteUseCase,*/required this.addNewRequestUseCase}) : super(RequestInitial());


  Future<void> addRequest({required RequestEntity note})async{
    try{
      await addNewRequestUseCase.call(note);
    }on SocketException catch(_){
      emit(RequestFailure());
    }catch(_){
      emit(RequestFailure());
    }
  }

  /*Future<void> deleteNote({required RequestEntity note})async{
    try{
      await deleteNoteUseCase.call(note);
    }on SocketException catch(_){
      emit(NoteFailure());
    }catch(_){
      emit(NoteFailure());
    }
  }
  Future<void> updateNote({required NoteEntity note})async{
    try{
      await updateNoteUseCase.call(note);
    }on SocketException catch(_){
      emit(NoteFailure());
    }catch(_){
      emit(NoteFailure());
    }
  }*/

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

}