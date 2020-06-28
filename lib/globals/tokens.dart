import 'package:news/globals/storage.dart';
import 'package:news/models/token.dart';

Token token = new Token(accessToken: null, refreshToken: null);

Future<void> loadTokenFromLocalStorage() async {
  token.accessToken = await storage.read(key: 'access');
  token.refreshToken = await storage.read(key: 'refresh');
}

Future<void> storeTestData() async {
  await storage.write(key: 'access', value: 'access_token');
  await storage.write(key: 'refresh', value: 'refresh_token');
}

Future<void> removeTokens() async {
  await storage.delete(key: 'access');
  await storage.delete(key: 'refresh');
}

Future<void> storeToken(Token tkn) async {
  await storage.write(key: 'access', value: tkn.accessToken);
  await storage.write(key: 'refresh', value: tkn.refreshToken);
}
