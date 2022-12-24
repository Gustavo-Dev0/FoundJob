part of 'request_cubit.dart';

abstract class RequestState extends Equatable {
  const RequestState();
}

class RequestInitial extends RequestState {
  @override
  List<Object> get props => [];
}

class RequestLoading extends RequestState {
  @override
  List<Object> get props => [];
}

class RequestFailure extends RequestState {
  @override
  List<Object> get props => [];
}

class RequestLoaded extends RequestState {
  final List<RequestEntity> requests;

  RequestLoaded({required this.requests});
  @override
  List<Object> get props => [requests];
}