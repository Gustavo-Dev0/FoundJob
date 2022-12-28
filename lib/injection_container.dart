import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:work_app/src/data/remote/data_sources/firebase_remote_data_source.dart';
import 'package:work_app/src/data/remote/data_sources/firebase_remote_data_source_impl.dart';
import 'package:work_app/src/data/repositories/firebase_repository_impl.dart';
import 'package:work_app/src/domain/repositories/firebase_repository.dart';
import 'package:work_app/src/domain/use_cases/add_new_applicant_usecase.dart';
import 'package:work_app/src/domain/use_cases/add_new_request_usecase.dart';
import 'package:work_app/src/domain/use_cases/contact_applicant_usercase.dart';
import 'package:work_app/src/domain/use_cases/get_applicants_by_user_id_usercase.dart';
import 'package:work_app/src/domain/use_cases/get_chats_from_applicants_usercase.dart';
import 'package:work_app/src/domain/use_cases/get_create_current_user_usecase.dart';
import 'package:work_app/src/domain/use_cases/get_current_uid_usecase.dart';
import 'package:work_app/src/domain/use_cases/get_current_user_info_usecase.dart';
import 'package:work_app/src/domain/use_cases/get_requests_by_professions_usercase.dart';
import 'package:work_app/src/domain/use_cases/get_requests_usercase.dart';
import 'package:work_app/src/domain/use_cases/is_sign_in_usecase.dart';
import 'package:work_app/src/domain/use_cases/save_cv_usercase.dart';
import 'package:work_app/src/domain/use_cases/sign_in_usecase.dart';
import 'package:work_app/src/domain/use_cases/sign_out_usecase.dart';
import 'package:work_app/src/domain/use_cases/sign_up_usecase.dart';
import 'package:work_app/src/presentation/cubit/auth/auth_cubit.dart';
import 'package:work_app/src/presentation/cubit/profile/profile_cubit.dart';
import 'package:work_app/src/presentation/cubit/request/request_cubit.dart';
import 'package:work_app/src/presentation/cubit/user/user_cubit.dart';


GetIt sl = GetIt.instance;

Future<void> init() async {
  //Cubit/Bloc
  sl.registerFactory<AuthCubit>(() => AuthCubit(
    getCurrentUserInfoUseCase: sl.call(),
      isSignInUseCase: sl.call(),
      signOutUseCase: sl.call(),
      getCurrentUidUseCase: sl.call()));
  sl.registerFactory<UserCubit>(() => UserCubit(
    getCreateCurrentUserUseCase: sl.call(),
    signInUseCase: sl.call(),
    signUPUseCase: sl.call(),
    getCurrentUidUseCase: sl.call(),
    saveCVUseCase: sl.call()
  ));
  sl.registerFactory<RequestCubit>(() => RequestCubit(
    addNewRequestUseCase: sl.call(),
    getRequestsUseCase: sl.call(),
    getRequestsByProfessionUseCase: sl.call(),
    addNewApplicantUseCase: sl.call(),
    getApplicantsByUserIdUseCase: sl.call(),
    getChatsFromApplicantsUseCase: sl.call(),
    contactApplicantUserCase: sl.call()
  ));
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(
    getCurrentUserInfoUseCase: sl.call(),
  ));




  sl.registerLazySingleton<AddNewRequestUseCase>(
          () => AddNewRequestUseCase(repository: sl.call()));
  /*sl.registerLazySingleton<DeleteNoteUseCase>(
          () => DeleteNoteUseCase(repository: sl.call()));*/
  sl.registerLazySingleton<GetCreateCurrentUserUsecase>(
          () => GetCreateCurrentUserUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetCurrentUidUseCase>(
          () => GetCurrentUidUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetCurrentUserInfoUseCase>(
          () => GetCurrentUserInfoUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetRequestsUseCase>(
          () => GetRequestsUseCase(repository: sl.call()));
  sl.registerLazySingleton<IsSignInUseCase>(
          () => IsSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignInUseCase>(
          () => SignInUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignOutUseCase>(
          () => SignOutUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignUPUseCase>(
          () => SignUPUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetRequestsByProfessionUseCase>(
          () => GetRequestsByProfessionUseCase(repository: sl.call()));
  sl.registerLazySingleton<SaveCVUseCase>(
          () => SaveCVUseCase(repository: sl.call()));
  sl.registerLazySingleton<AddNewApplicantUseCase>(
      () => AddNewApplicantUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetApplicantsByUserIdUseCase>(
          () => GetApplicantsByUserIdUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetChatsFromApplicantsUseCase>(
          () => GetChatsFromApplicantsUseCase(repository: sl.call()));

  sl.registerLazySingleton<ContactApplicantUseCase>(
          () => ContactApplicantUseCase(repository: sl.call()));
  /*sl.registerLazySingleton<UpdateNoteUseCase>(
          () => UpdateNoteUseCase(repository: sl.call()));*/

  //repository
  sl.registerLazySingleton<FirebaseRepository>(
          () => FirebaseRepositoryImpl(remoteDataSource: sl.call()));

  //data source
  sl.registerLazySingleton<FirebaseRemoteDataSource>(() =>
      FirebaseRemoteDataSourceImpl(auth: sl.call(), firestore: sl.call()));

  //External
  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => fireStore);
}