import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tutor_platform/sign_in_up/data/data_source/login_api_data_source.dart';
import 'package:tutor_platform/sign_in_up/data/data_source/remember_me_data_source.dart';
import 'package:tutor_platform/sign_in_up/data/repository_impl/login_api_repository_impl.dart';
import 'package:tutor_platform/sign_in_up/data/repository_impl/remember_me_repository_impl.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/login_api_repository.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/remember_me_repository.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/change_password_without_login.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/check_nickname.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/perform_autologin.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/perform_login.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/remove_remember_me.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/request_email_verification_yes_duplicate.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/retrieve_remember_me.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/request_email_verification_no_duplicate.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/send_verification_find_password.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/send_verification_sign_up.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/sign_up.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/write_remember_me.dart';
import 'package:tutor_platform/sign_in_up/presentation/auto_login_view_model.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/change_password/find_password_change_password_view_model.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/send_code/find_password_send_code_view_model.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/send_email/find_password_send_email_view_model.dart';
import 'package:tutor_platform/sign_in_up/presentation/login/login_view_model.dart';
import 'package:tutor_platform/sign_in_up/presentation/sign_up/email_password/sign_up_email_password_view_model.dart';
import 'package:tutor_platform/sign_in_up/presentation/sign_up/user_info/sign_up_user_info_view_model.dart';

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
  ProxyProvider<http.Client, LoginApiDataSource>(
    update: (context, client, _) => LoginApiDataSource(client),
  ),
  ProxyProvider<FlutterSecureStorage, RememberMeDataSource>(
    update: (context, storage, _) => RememberMeDataSource(storage),
  ),
  ProxyProvider<LoginApiDataSource, LoginApiRepository>(
    update: (context, dataSource, _) => LoginApiRepositoryImpl(dataSource),
  ),
  ProxyProvider<RememberMeDataSource, RememberMeRepository>(
    update: (context, dataSource, _) => RememberMeRepositoryImpl(dataSource),
  ),
  ProxyProvider<LoginApiRepository, CheckNickname>(
    update: (context, repository, _) => CheckNickname(repository),
  ),
  ProxyProvider<LoginApiRepository, PerformLogin>(
    update: (context, repository, _) => PerformLogin(repository),
  ),
  ProxyProvider<LoginApiRepository, RequestEmailVerificationNoDuplicate>(
    update: (context, repository, _) => RequestEmailVerificationNoDuplicate(repository),
  ),

  ProxyProvider<LoginApiRepository, RequestEmailVerificationYesDuplicate>(
    update: (context, repository, _) => RequestEmailVerificationYesDuplicate(repository),
  ),
  ProxyProvider<LoginApiRepository, SendVerificationSignUp>(
    update: (context, repository, _) => SendVerificationSignUp(repository),
  ),
  ProxyProvider<RememberMeRepository, RemoveRememberMe>(
    update: (context, repository, _) => RemoveRememberMe(repository),
  ),
  ProxyProvider<RememberMeRepository, RetrieveRememberMe>(
    update: (context, repository, _) => RetrieveRememberMe(repository),
  ),
  ProxyProvider<RememberMeRepository, WriteRememberMe>(
    update: (context, repository, _) => WriteRememberMe(repository),
  ),
  ProxyProvider2<LoginApiRepository, RememberMeRepository, PerformAutologin>(
    update: (context, loginApiRepository, rememberMeRepository, _) =>
        PerformAutologin(loginApiRepository, rememberMeRepository),
  ),
  ProxyProvider<LoginApiRepository, SignUp>(
    update: (context, repository, _) => SignUp(repository),
  ),
  ProxyProvider<LoginApiRepository, SendVerificationFindPassword>(
    update: (context, repository, _) => SendVerificationFindPassword(repository),
  ),
  ProxyProvider<LoginApiRepository, ChangePasswordWithoutLogin>(
    update: (context, repository, _) => ChangePasswordWithoutLogin(repository),
  ),
];

List<SingleChildWidget> viewModelsLogin = [
  ChangeNotifierProvider<LoginViewModel>(
    create: (context) => LoginViewModel(
      context.read<PerformLogin>(),
      context.read<WriteRememberMe>(),
    ),
  ),
  ChangeNotifierProvider<AutoLoginViewModel>(
    create: (context) => AutoLoginViewModel(
      context.read<PerformAutologin>(),
      context.read<RemoveRememberMe>(),
    ),
  ),
  ChangeNotifierProvider<SignUpEmailPasswordViewModel>(
    create: (context) => SignUpEmailPasswordViewModel(
      context.read<RequestEmailVerificationNoDuplicate>(),
      context.read<SendVerificationSignUp>(),
    ),
  ),
  ChangeNotifierProvider<SignUpUserInfoViewModel>(
    create: (context) => SignUpUserInfoViewModel(
      context.read<CheckNickname>(),
      context.read<SignUp>(),
    ),
  ),
  ChangeNotifierProvider<FindPasswordSendEmailViewModel>(
    create: (context) => FindPasswordSendEmailViewModel(
      context.read<RequestEmailVerificationYesDuplicate>(),
    ),
  ),
  ChangeNotifierProvider<FindPasswordSendCodeViewModel>(
    create: (context) => FindPasswordSendCodeViewModel(
      context.read<SendVerificationFindPassword>(),
    ),
  ),
  ChangeNotifierProvider<FindPasswordChangePasswordViewModel>(
    create: (context) => FindPasswordChangePasswordViewModel(
      context.read<ChangePasswordWithoutLogin>(),
    ),
  ),
];
