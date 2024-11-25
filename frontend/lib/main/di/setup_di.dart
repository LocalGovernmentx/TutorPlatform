import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tutor_platform/core/models/jwt_token.dart';
import 'package:tutor_platform/core/models/user_info.dart';
import 'package:tutor_platform/main/data/data_source/category_api_data_source.dart';
import 'package:tutor_platform/main/data/data_source/dibs_api_data_source.dart';
import 'package:tutor_platform/main/data/data_source/file_manager_data_source.dart';
import 'package:tutor_platform/main/data/data_source/image_api.dart';
import 'package:tutor_platform/main/data/data_source/lecture_api_data_source.dart';
import 'package:tutor_platform/main/data/repository_impl/category_repository_impl.dart';
import 'package:tutor_platform/main/data/repository_impl/dibs_file_manager_impl.dart';
import 'package:tutor_platform/main/data/repository_impl/image_api_repo.dart';
import 'package:tutor_platform/main/data/repository_impl/lecture_api_repository_impl.dart';
import 'package:tutor_platform/main/domain/repository/category_repository.dart';
import 'package:tutor_platform/main/domain/repository/dibs_api_repository.dart';
import 'package:tutor_platform/main/domain/repository/lecture_api_repository.dart';
import 'package:tutor_platform/main/domain/use_case/dibs/dibs_lecture.dart';
import 'package:tutor_platform/main/domain/use_case/handle_categories.dart';
import 'package:tutor_platform/main/domain/use_case/handle_ongoing_lecture.dart';
import 'package:tutor_platform/main/domain/use_case/handling_user_info.dart';
import 'package:http/http.dart' as http;
import 'package:tutor_platform/main/domain/use_case/make_lecture.dart';
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
      update: (context, client, _) => LectureApiDataSource(client, jwtToken, userInfo),
    ),
    ProxyProvider<http.Client, DibsApiDataSource>(
      update: (context, client, _) => DibsApiDataSource(client, jwtToken),
    ),
    ProxyProvider<http.Client, CategoryApiDataSource>(
      update: (context, client, _) => CategoryApiDataSource(client, jwtToken),
    ),
    ProxyProvider<http.Client, ImageApi>(
      update: (context, client, _) => ImageApi(client, jwtToken),
    ),

    ProxyProvider2<LectureApiDataSource, FileManagerDataSource, LectureApiRepository>(
      update: (context, dataSource, fm, _) => LectureApiRepositoryImpl(dataSource, fm),
    ),
    ProxyProvider2<FileManagerDataSource, LectureApiDataSource, DibsApiRepository>(
      update: (context, fm, dataSource, _) => DibsFileManagerImpl(fm, dataSource),
    ),
    ProxyProvider2<FileManagerDataSource, CategoryApiDataSource, CategoryRepository>(
      update: (context, fm, api, _) =>
          CategoryRepositoryImpl(fm, api),
    ),
    ProxyProvider<ImageApi, ImageApiRepo> (
      update: (context, imageApi, _) => ImageApiRepo(imageApi),
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
    ProxyProvider2<LectureApiRepository, ObtainLecture, HandleOngoingLecture>(
      update: (context, lectureApiRepo, obtainLecture, _) =>
          HandleOngoingLecture(lectureApiRepo, obtainLecture),
    ),
    ProxyProvider2<LectureApiRepository, ImageApiRepo, MakeLecture>(
      update: (context, lectureApiRepo, imageApiRepo, _) =>
          MakeLecture(lectureApiRepo, imageApiRepo),
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
