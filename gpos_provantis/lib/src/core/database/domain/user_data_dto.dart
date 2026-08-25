class UserDataDto {
  final String employeeId;
  final String fullName;
  final int position;
  final String contactInfo;
  final String dateHired;
  final int userCode;
  final int accessType;
  final String status;
  final String apk;

  UserDataDto({
    required this.employeeId,
    required this.fullName,
    required this.position,
    required this.contactInfo,
    required this.dateHired,
    required this.userCode,
    required this.accessType,
    required this.status,
    required this.apk,
  });

  factory UserDataDto.fromJson(Map<String, dynamic> json) {
    return UserDataDto(
      employeeId: (json['employeeid'] ?? '').toString(),
      fullName: (json['fullname'] ?? '').toString(),
      position: (json['position'] ?? 0).toInt(),
      contactInfo: (json['contactinfo'] ?? '').toString(),
      dateHired: (json['datehired'] ?? '').toString(),
      userCode: (json['usercode'] ?? 0).toInt(),
      accessType: (json['accesstype'] ?? 0).toInt(),
      status: (json['status'] ?? '').toString(),
      apk: (json['APK'] ?? '').toString(),
    );
  }
}
