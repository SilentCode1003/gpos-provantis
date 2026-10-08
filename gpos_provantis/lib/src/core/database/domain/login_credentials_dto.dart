import '../app_database.dart';

class LoginCredentialsDto {
  final String username;
  final String passwordHash;
  final String salt;

  const LoginCredentialsDto({
    required this.username,
    required this.passwordHash,
    required this.salt,
  });

  factory LoginCredentialsDto.fromRow(LoginCredentialsTableData row) {
    return LoginCredentialsDto(
      username: row.username,
      passwordHash: row.passwordHash,
      salt: row.salt,
    );
  }
}
