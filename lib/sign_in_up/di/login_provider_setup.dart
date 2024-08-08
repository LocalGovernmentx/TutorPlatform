import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tutor_platform/sign_in_up/data/data_source/login_api_data_source.dart';
import 'package:tutor_platform/sign_in_up/data/data_source/remember_me_data_source.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/login_api_repository.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/remember_me_repository.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/perform_login.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/remove_remember_me.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/retrieve_remember_me.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/write_remember_me.dart';
import 'package:tutor_platform/sign_in_up/presentation/login/login_view_model.dart';
import 'package:tutor_platform/sign_in_up/data/repository_impl/login_api_repository_impl.dart';
import 'package:tutor_platform/sign_in_up/data/repository_impl/remember_me_repository_impl.dart';

Future<List<SingleChildWidget>> getProvidersLogin() async {
  LoginApiDataSource loginApiDataSource = LoginApiDataSource(http.Client());
  RememberMeDataSource rememberMeDataSource =
      RememberMeDataSource(const FlutterSecureStorage());
  LoginApiRepository loginApiRepository =
      LoginApiRepositoryImpl(loginApiDataSource);
  RememberMeRepository rememberMeRepository =
      RememberMeRepositoryImpl(rememberMeDataSource);
  LoginViewModel loginViewModel = LoginViewModel(
    performLogin: PerformLogin(loginApiRepository),
    writeRememberMe: WriteRememberMe(rememberMeRepository),
    retrieveRememberMe: RetrieveRememberMe(rememberMeRepository),
    removeRememberMe: RemoveRememberMe(rememberMeRepository),
  );
  return [
    ChangeNotifierProvider(create: (_) => loginViewModel),
  ];
}
