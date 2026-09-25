class SetupState {
  final String branchId;
  final String posId;

  final String protocol;

  final String address;

  final String port;

  final String domain;

  final bool isLoading;
  final String? errorMessage;

  const SetupState({
    this.branchId = '',
    this.posId = '',
    this.protocol = 'https://',
    this.address = '',
    this.port = '',
    this.domain = '',
    this.isLoading = false,
    this.errorMessage,
  });

  SetupState copyWith({
    String? branchId,
    String? posId,
    String? protocol,
    String? address,
    String? port,
    String? domain,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SetupState(
      branchId: branchId ?? this.branchId,
      posId: posId ?? this.posId,
      protocol: protocol ?? this.protocol,
      address: address ?? this.address,
      port: port ?? this.port,
      domain: domain ?? this.domain,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
