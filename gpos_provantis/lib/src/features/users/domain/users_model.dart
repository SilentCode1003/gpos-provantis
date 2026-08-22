class UsersModel {
  final String id;
  final String empId;
  final String username;
  final String password;
  final String createdBy;
  final String updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  UsersModel({
    required this.id,
    required this.empId,
    required this.username,
    required this.password,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });
}
