class EmployeesDto {
  final String fullName;

  EmployeesDto({required this.fullName});

  factory EmployeesDto.fromJson(Map<String, dynamic> json) {
    return EmployeesDto(fullName: (json['fullName'] ?? '').toString());
  }
}
