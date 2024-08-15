import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tutor_platform/sign_in_up/domain/model/login_credentials.dart';

class RememberMeDataSource {
  final FlutterSecureStorage storage;

  RememberMeDataSource(this.storage);

  Future<void> delete() async {
    await storage.delete(key: 'email');
    await storage.delete(key: 'refreshToken');
  }

  Future<void> save(String email, String refreshToken) async {
    delete();
    await storage.write(key: 'email', value: email);
    await storage.write(key: 'refreshToken', value: refreshToken);
  }

  Future<LoginCredentials?> read() async {
    final String? email = await storage.read(key: 'email');
    final String? refreshToken = await storage.read(key: 'refreshToken');
    if (email != null && refreshToken != null) {
      return LoginCredentials(email: email, refreshToken: refreshToken);
    } else {
      return null;
    }
  }
}