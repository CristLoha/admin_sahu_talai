class Routes {
  static Future<String> get initialRoute async {
    return admin;
  }

  static const admin = '/admin';
  static const home = '/home';
  static const login = '/login';
  static const add_words = '/add-words';
}
