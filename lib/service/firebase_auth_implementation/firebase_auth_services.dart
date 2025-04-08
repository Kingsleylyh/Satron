import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 登录方法（2025年推荐使用新的错误处理方式）
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e.code);
    }
  }

  // 注册方法（包含用户名存储示例）
  Future<User?> signUpWithEmailAndPassword(
      String email,
      String password,
      ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2025年推荐：在Firestore中存储额外用户数据
      await credential.user?.updateDisplayName(email.split('@')[0]);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e.code);
    }
  }

  // 错误处理（国际化适配）
  String _handleAuthError(String code) {
    switch (code) {
      case 'invalid-email':
        return '邮箱格式错误';
      case 'user-disabled':
        return '账户已禁用';
      case 'user-not-found':
        return '用户不存在';
      case 'wrong-password':
        return '密码错误';
      case 'email-already-in-use':
        return '邮箱已被注册';
      default:
        return '操作失败 [$code]';
    }
  }
}