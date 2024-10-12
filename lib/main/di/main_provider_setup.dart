import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tutor_platform/core/main_view_model.dart';
import 'package:http/http.dart' as http;

List<SingleChildWidget> globalProvidersMain = [
  ...independentModelsMain,
  ...dependentModelsMain,
  ...viewModelsMain,
];

List<SingleChildWidget> independentModelsMain = [
  Provider<http.Client>(
    create: (_) => http.Client(),
  ),
];

List<SingleChildWidget> dependentModelsMain = [];

List<SingleChildWidget> viewModelsMain = [
  ChangeNotifierProvider<MainViewModel>(
    create: (context) => MainViewModel(context.read<http.Client>()),
  ),
];