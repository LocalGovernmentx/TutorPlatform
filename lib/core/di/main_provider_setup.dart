import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tutor_platform/core/main_view_model.dart';

Future <List<SingleChildWidget>> getProvidersMain() async {
  MainViewModel mainViewModel = MainViewModel();
  return [ChangeNotifierProvider(create: (_) => mainViewModel)];
}