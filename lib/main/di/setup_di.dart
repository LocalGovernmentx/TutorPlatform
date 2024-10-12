import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tutor_platform/core/models/jwt_token.dart';
import 'package:tutor_platform/core/models/user_info.dart';
import 'package:tutor_platform/main/data/data_source/category_api_data_source.dart';
import 'package:tutor_platform/main/data/data_source/dibs_api_data_source.dart';
import 'package:tutor_platform/main/data/data_source/file_manager_data_source.dart';
import 'package:tutor_platform/main/data/data_source/lecture_api_data_source.dart';
import 'package:tutor_platform/main/data/repository_impl/category_repository_impl.dart';
import 'package:tutor_platform/main/data/repository_impl/dibs_api_repository_impl.dart';
import 'package:tutor_platform/main/data/repository_impl/dibs_file_manager_impl.dart';
import 'package:tutor_platform/main/data/repository_impl/lecture_api_repository_impl.dart';
import 'package:tutor_platform/main/domain/repository/category_repository.dart';
import 'package:tutor_platform/main/domain/repository/dibs_api_repository.dart';
import 'package:tutor_platform/main/domain/repository/lecture_api_repository.dart';
import 'package:tutor_platform/main/domain/use_case/dibs/dibs_lecture.dart';
import 'package:tutor_platform/main/domain/use_case/handle_categories.dart';
import 'package:tutor_platform/main/domain/use_case/handling_user_info.dart';
import 'package:http/http.dart' as http;
import 'package:tutor_platform/main/domain/use_case/obtain_lecture.dart';
import 'package:tutor_platform/main/presentation/components/page_controller_provider.dart';
import 'package:tutor_platform/main/presentation/temp/my_page_view_model.dart';

List<SingleChildWidget> setupDi(
    JwtToken jwtToken, UserInfo userInfo, bool isTutor) {
  List<SingleChildWidget> independentModels = [
    Provider<HandlingUserInfo>(
      create: (_) => HandlingUserInfo(jwtToken, userInfo, isTutor),
    ),
    Provider(create: (_) => FileManagerDataSource()),
  ];

  List<SingleChildWidget> dependentModels = [
    ProxyProvider<http.Client, LectureApiDataSource>(
      update: (context, client, _) => LectureApiDataSource(client, jwtToken),
    ),
    ProxyProvider<http.Client, DibsApiDataSource>(
      update: (context, client, _) => DibsApiDataSource(client, jwtToken),
    ),
    ProxyProvider<http.Client, CategoryApiDataSource>(
      update: (context, client, _) => CategoryApiDataSource(client, jwtToken),
    ),

    ProxyProvider2<LectureApiDataSource, FileManagerDataSource, LectureApiRepository>(
      update: (context, dataSource, fm, _) => LectureApiRepositoryImpl(dataSource, fm),
    ),
    ProxyProvider<FileManagerDataSource, DibsApiRepository>(
      update: (context, fm, _) => DibsFileManagerImpl(fm),
    ),
    ProxyProvider2<FileManagerDataSource, CategoryApiDataSource, CategoryRepository>(
      update: (context, fm, api, _) =>
          CategoryRepositoryImpl(fm, api),
    ),

    ProxyProvider<DibsApiRepository, DibsLectureUseCase>(
      update: (context, apiRepo, _) => DibsLectureUseCase(apiRepo),
    ),
    ProxyProvider2<LectureApiRepository, DibsLectureUseCase, ObtainLecture>(
      update: (context, lectureApiRepo, dibsLectureUseCase, _) =>
          ObtainLecture(lectureApiRepo, dibsLectureUseCase),
    ),
    ProxyProvider<CategoryRepository, HandleCategories>(
      update: (context, categoryRepo, _) => HandleCategories(categoryRepo),
    ),
  ];

  List<SingleChildWidget> viewModels = [
    ChangeNotifierProvider<MyPageViewModel>(
      create: (context) => MyPageViewModel(
        context.read<HandlingUserInfo>(),
      ),
    ),
    ChangeNotifierProvider<PageControllerProvider>(
      create: (_) => PageControllerProvider(isTutor),
    ),
  ];

  List<SingleChildWidget> globalProviders = [
    ...independentModels,
    ...dependentModels,
    ...viewModels,
  ];

  return globalProviders;
}
