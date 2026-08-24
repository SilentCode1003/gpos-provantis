class SetupState {
  final String branchId;
  final String posId;

  /// URL protocol prefix, e.g. 'https://' or 'http://'. Stored in state
  /// (not just locally in the screen) so every recompose of [domain] uses
  /// the user's actual selection instead of silently falling back to a
  /// default.
  final String protocol;

  /// Raw host/address input, e.g. 'domain.server.com' (no protocol, no port).
  final String address;

  /// Raw port input, e.g. '8080'. Optional — empty string means "no port".
  final String port;

  /// The fully composed URL actually saved to DomainConfigTable, e.g.
  /// 'https://domain.server.com:8080/' or 'https://domain.server.com/'.
  /// Built from protocol + address + port by the screen/controller
  /// whenever any of those three change.
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
