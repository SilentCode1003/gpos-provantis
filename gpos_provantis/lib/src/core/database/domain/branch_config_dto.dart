/// Parses one branch record from POST /branch/getbranch.
///
/// NOTE: the exact field names below (branchid, branchname, ...) mirror the
/// lowercase-no-underscore style of the confirmed POS response
/// (posid, posname, createdby, createddate). The real /branch/getbranch
/// payload wasn't provided, so if the server uses different keys, this is
/// the only place that needs to change.
class BranchConfigDto {
  final String branchId;
  final String branchName;
  final String tin;
  final String address;
  final String logo;
  final String status;
  final String createdBy;
  final String createdDate;

  BranchConfigDto({
    required this.branchId,
    required this.branchName,
    required this.tin,
    required this.address,
    required this.logo,
    required this.status,
    required this.createdBy,
    required this.createdDate,
  });

  factory BranchConfigDto.fromJson(Map<String, dynamic> json) {
    return BranchConfigDto(
      branchId: (json['branchid'] ?? '').toString(),
      branchName: (json['branchname'] ?? '').toString(),
      tin: (json['tin'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      logo: (json['logo'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      createdBy: (json['createdby'] ?? '').toString(),
      createdDate: (json['createddate'] ?? '').toString(),
    );
  }
}
