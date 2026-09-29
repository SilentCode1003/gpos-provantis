class EmployeesDto {
  final int employeeId;
  final String fullName;
  final int position;
  final String contactInfo;
  final String dateHired;
  final String status;
  final String createdBy;
  final String createdDate;

  EmployeesDto({
    required this.employeeId,
    required this.fullName,
    required this.position,
    required this.contactInfo,
    required this.dateHired,
    required this.status,
    required this.createdBy,
    required this.createdDate,
  });

  factory EmployeesDto.fromJson(Map<String, dynamic> json) {
    return EmployeesDto(
      employeeId: (json['employeeid'] ?? 0).toInt(),
      fullName: (json['fullname'] ?? '').toString(),
      position: (json['position'] ?? 0).toInt(),
      contactInfo: (json['contactinfo'] ?? '').toString(),
      dateHired: (json['datehired'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      createdBy: (json['createdby'] ?? '').toString(),
      createdDate: (json['createddate'] ?? '').toString(),
    );
  }
}
