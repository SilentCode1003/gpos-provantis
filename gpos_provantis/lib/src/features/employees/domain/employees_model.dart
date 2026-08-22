class EmployeesModel {
  final String id;
  final String employeeId;
  final String fullName;
  final String contactNo;
  final String email;
  final String createdBy;
  final String updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  EmployeesModel({
    required this.id,
    required this.employeeId,
    required this.fullName,
    required this.contactNo,
    required this.email,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });
}
