import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tutor_platform/sign_in_up/domain/model/login_credentials.dart';

class RememberMeDataSource {
  final FlutterSecureStorage storage;

  RememberMeDataSource(this.storage);

  Future<void> save(String email, String password) async {
    await storage.delete(key: 'email');
    await storage.delete(key: 'password');
    await storage.write(key: 'email', value: email);
    await storage.write(key: 'password', value: password);
  }

  Future<LoginCredentials?> read() async {
    final String? email = await storage.read(key: 'email');
    final String? password = await storage.read(key: 'password');
    if (email != null && password != null) {
      return LoginCredentials(email: email, password: password);
    } else {
      return null;
    }
  }
}