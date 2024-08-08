import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tutor_platform/sign_in_up/data/data_source/login_api_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:tutor_platform/sign_in_up/data/data_source/result.dart';

import 'login_api_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  test(
    'login_api_data_source가 (서버가 제대로 작동한다는 가정 하에) 로그인 정보를 제대로 가져와야 한다',
        () async {
      final client = MockClient();
      final loginApi = LoginApiDataSource(client);

      when(client.get(
          Uri.parse('${LoginApiDataSource.baseUrl}?email=1234&password=1234')))
          .thenAnswer((_) async => http.Response(fakeJsonBody, 200));

      // ToDo : Write test codes here

      // final result = await loginApi.fetch('1234', '1234');
      // expect(result, isA<Success<Map<String, dynamic>>>());
    },
  );
}

String fakeJsonBody = '''
{
  "token": "1234"
}
''';