import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tutor_platform/sign_in_up/data/data_source/remember_me_data_source.dart';
import 'package:tutor_platform/sign_in_up/domain/model/login_credentials.dart';

import 'remember_me_data_source_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
void main() {
  test(
    'remember_me_data_source가 (FlutterSecureStorage가 잘 된다는 가정 하에) 토큰 정보를 제대로 가져와야 한다',
    () async {
      final storage = MockFlutterSecureStorage();
      final rememberMeDataSource = RememberMeDataSource(storage);
      String? emailStorage;
      String? passwordStorage;

      when(storage.delete(key: 'email')).thenAnswer((_) async {emailStorage = null;});
      when(storage.delete(key: 'password')).thenAnswer((_) async {passwordStorage = null;});

      when(storage.write(key: 'email', value: '1234')).thenAnswer((_) async {emailStorage = '1234';});
      when(storage.write(key: 'password', value: '1234')).thenAnswer((_) async {passwordStorage = '1234';});

      when(storage.read(key: 'email')).thenAnswer((_) async => emailStorage);
      when(storage.read(key: 'password')).thenAnswer((_) async => passwordStorage);

      rememberMeDataSource.save('1234', '1234');
      LoginCredentials? result = await rememberMeDataSource.read();
      expect(result, const LoginCredentials(email: '1234', password: '1234'));

      rememberMeDataSource.delete();
      result = await rememberMeDataSource.read();
      expect(result, null);

    },
  );
}
