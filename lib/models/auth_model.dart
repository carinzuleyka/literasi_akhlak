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
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Simple validation - in real app, this would be API call
    return nisOrEmail.isNotEmpty && password.isNotEmpty;
  }
  
  // Simulasi register
  static Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Simple validation - in real app, this would be API call
    return fullName.isNotEmpty && 
           email.contains('@') && 
           password.length >= 6;
  }
}