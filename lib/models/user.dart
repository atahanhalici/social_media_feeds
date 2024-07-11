import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String password;

  User(this.username, this.email, this.password);
    @override
  String toString() {
    return 'User{username: $username, email: $email, password: $password}';
  }
}