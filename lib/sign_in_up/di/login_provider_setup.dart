import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tutor_platform/sign_in_up/data/data_source/login_api_data_source.dart';
import 'package:tutor_platform/sign_in_up/data/data_source/remember_me_data_source.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/login_api_repository.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/remember_me_repository.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/change_password.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/perform_login.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/remove_remember_me.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/retrieve_remember_me.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/send_request_email.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/send_verification_code.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/write_remember_me.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/find_password_view_model.dart';
import 'package:tutor_platform/sign_in_up/presentation/login/login_view_model.dart';
import 'package:tutor_platform/sign_in_up/data/repository_impl/login_api_repository_impl.dart';
import 'package:tutor_platform/sign_in_up/data/repository_impl/remember_me_repository_impl.dart';

List<SingleChildWidget> globalProvidersLogin = [
  ...independentModelsLogin,
  ...dependentModelsLogin,
  ...viewModelsLogin,
];

List<SingleChildWidget> independentModelsLogin = [
  // http.Client는 최상단 core 디렉토리의 di 안의 independentModelsMain에 정의됨
  Provider<FlutterSecureStorage>(
    create: (_) => const FlutterSecureStorage(),
  ),
];

List<SingleChildWidget> dependentModelsLogin = [
  // data_source 정의
  ProxyProvider<http.Client, LoginApiDataSource>(
    update: (context, client, _) => LoginApiDataSource(client),
  ),
  ProxyProvider<FlutterSecureStorage, RememberMeDataSource>(
    update: (context, storage, _) => RememberMeDataSource(storage),
  ),

  // repository 정의
  ProxyProvider<LoginApiDataSource, LoginApiRepository>(
    update: (context, dataSource, _) => LoginApiRepositoryImpl(dataSource),
  ),
  ProxyProvider<RememberMeDataSource, RememberMeRepository>(
    update: (context, dataSource, _) => RememberMeRepositoryImpl(dataSource),
  ),

  // use_case 정의
  ProxyProvider<LoginApiRepository, PerformLogin>(
    update: (context, repository, _) => PerformLogin(repository),
  ),
  ProxyProvider<RememberMeRepository, WriteRememberMe>(
    update: (context, repository, _) => WriteRememberMe(repository),
  ),
  ProxyProvider<RememberMeRepository, RetrieveRememberMe>(
    update: (context, repository, _) => RetrieveRememberMe(repository),
  ),
  ProxyProvider<RememberMeRepository, RemoveRememberMe>(
    update: (context, repository, _) => RemoveRememberMe(repository),
  ),
  ProxyProvider<LoginApiRepository, SendRequestEmail>(
    update: (context, repository, _) => SendRequestEmail(repository),
  ),
  ProxyProvider<LoginApiRepository, SendVerificationCode>(
    update: (context, repository, _) => SendVerificationCode(repository),
  ),
  ProxyProvider<LoginApiRepository, ChangePassword>(
    update: (context, repository, _) => ChangePassword(repository),
  ),
];

List<SingleChildWidget> viewModelsLogin = [
  ChangeNotifierProvider<LoginViewModel>(
    create: (context) => LoginViewModel(
      performLogin: context.read<PerformLogin>(),
      writeRememberMe: context.read<WriteRememberMe>(),
      retrieveRememberMe: context.read<RetrieveRememberMe>(),
      removeRememberMe: context.read<RemoveRememberMe>(),
    ),
  ),
  ChangeNotifierProvider<FindPasswordViewModel>(
    create: (context) => FindPasswordViewModel(
      context.read<SendRequestEmail>(),
      context.read<SendVerificationCode>(),
      context.read<ChangePassword>(),
    ),
  ),
];
