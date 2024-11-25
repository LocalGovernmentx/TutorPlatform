import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/main/data/data_source/after_school_api.dart';
import 'package:tutor_platform/main/data/repository_impl/after_school_repository_impl.dart';
import 'package:tutor_platform/main/domain/repository/after_school_repository.dart';
import 'package:tutor_platform/main/domain/use_case/after_school_scroll.dart';
import 'package:tutor_platform/main/presentation/components/appbar/common_app_bar.dart';
import 'package:tutor_platform/main/presentation/components/lecture_list/infinite_scroll/infinite_scroll_view.dart';
import 'package:http/http.dart' as http;
import 'package:tutor_platform/main/presentation/components/lecture_list/scroll_view_model.dart';

class TutorAfterSchoolDi extends StatelessWidget {
  final PageController pageController;
  const TutorAfterSchoolDi({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ProxyProvider<http.Client, AfterSchoolApiDataSource>(
          update: (context, client, previous) =>
              AfterSchoolApiDataSource(client),
        ),
        ProxyProvider<AfterSchoolApiDataSource, AfterSchoolRepository>(
          update: (context, dataSource, previous) =>
              AfterSchoolRepositoryImpl(dataSource),
        ),
        ProxyProvider<AfterSchoolRepository, AfterSchoolScroll>(
          update: (context, repo, previous) => AfterSchoolScroll(repo),
        ),
        ChangeNotifierProvider<ScrollViewModel>(
          create: (context) =>
              ScrollViewModel(context.read<AfterSchoolScroll>(), null),
        ),
      ],
      child: Scaffold(
        appBar: CommonAppBar(
          title: '방과후 수업',
          actions: const [],
          pageController: pageController,
        ),
        body: const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              InfiniteScrollView(),
            ],
          ),
        ),
      ),
    );
  }
}
