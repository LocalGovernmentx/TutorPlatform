
import 'package:url_launcher/url_launcher_string.dart';

Future<bool> downloadUrl(String url) async {
  // Check if the URL can be launched
  try {
    await launchUrlString(url);
    return true;
  }
  catch (e) {
    print(e);
    return false;
  }
}