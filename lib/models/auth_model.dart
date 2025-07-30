class User {
  final String fullName;
  final String email;
  final String nis;

  User({
    required this.fullName,
    required this.email,
    required this.nis,
  });
}

class AuthService {
  // Simulasi login
  static Future<bool> signIn(String nisOrEmail, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    // Ganti sesuai data dummy kamu
    if (nisOrEmail == '1001' && password == '1234') {
      return true;
    }

    return false;
  }

  // Simulasi register
  static Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return fullName.isNotEmpty && 
           email.contains('@') && 
           password.length >= 6;
  }
}
