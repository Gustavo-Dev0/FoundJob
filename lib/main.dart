import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:work_app/src/constants.dart';
import 'package:work_app/src/presentation/cubit/auth/auth_cubit.dart';
import 'package:work_app/src/presentation/cubit/profile/profile_cubit.dart';
import 'package:work_app/src/presentation/cubit/request/request_cubit.dart';
import 'package:work_app/src/presentation/cubit/user/user_cubit.dart';
import 'package:work_app/src/presentation/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:work_app/src/presentation/pages/main_page.dart';
import 'package:work_app/src/presentation/pages/main_page_professional.dart';
import 'package:work_app/src/presentation/pages/register_google_page.dart';
import 'package:work_app/src/presentation/pages/register_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  }

  else{
    await Firebase.initializeApp();
  }
  //await Firebase.initializeApp();
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(create: (_) => di.sl<AuthCubit>()..appStarted()),
          BlocProvider<UserCubit>(create: (_) => di.sl<UserCubit>()),
          BlocProvider<ProfileCubit>(create: (_) => di.sl<ProfileCubit>()),
          BlocProvider<RequestCubit>(create: (_)=> di.sl<RequestCubit>()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          /*initialRoute: LoginPage.id,*/
          initialRoute: '/',
          /*routes: {
            LoginPage.id: (context) => LoginPage()
          },*/
          //onGenerateRoute:OnGenerateRoute.route,
          routes: {
            "/": (context){
              return BlocBuilder<AuthCubit,AuthState>(builder:(context,authState){

                if (authState is Authenticated){
                  /*Logger().wtf("ESto debe ser main");
                  String role = "iniital value";
                  BlocProvider.of<ProfileCubit>(context).getCurrentUserInfoDirect().then((value) {
                    role = value.role!;
                    Logger().wtf("ESto debe ser primero -> "+value.role!);
                  });
                  Logger().wtf("El rol es "+role);*/
                  //Logger().w(authState.profile.role);
                  if(authState.profile.role == "cliente") {
                    return MainPage(uid: authState.uid);
                  }
                  return MainProfessionalPage(uid: authState.uid);
                }
                if (authState is UnAuthenticated){
                  return LoginPage();
                }
                if (authState is AuthenticatedWithoutRegister){
                  return RegisterGooglePage();
                }

                return const CircularProgressIndicator();
              });
            }
          },
        ),
    );
  }
}


