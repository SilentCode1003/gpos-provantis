import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/features/setup/domain/setup_model.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/services/sync/initial_sync.dart';

part 'setup_controller.g.dart';

/// Port must be digits only (1-5 of them, covers 0-65535 with a final
/// range check below). This is the actual injection protection: even
/// though the port field accepts free text, only strings matching this
/// get treated as a valid port. Anything else (letters, '/', '?', '#',
/// whitespace, other URL-special characters) is rejected before it ever
/// reaches the composed URL, so it can't be used to smuggle a different
/// host, path, or query into the request.
final RegExp _portPattern = RegExp(r'^[0-9]{1,5}$');

@riverpod
class SetupController extends _$SetupController {
  @override
  SetupState build() {
    return const SetupState();
  }

  void setBranchId(String value) {
    state = state.copyWith(branchId: value, errorMessage: null);
  }

  void setPosId(String value) {
    state = state.copyWith(posId: value, errorMessage: null);
  }

  /// Updates the raw address input and recomposes [SetupState.domain].
  void setAddress(String value) {
    state = state.copyWith(address: value, errorMessage: null);
    _recomposeDomain();
  }

  /// Updates the raw port input and recomposes [SetupState.domain].
  /// Port is optional — an empty string is valid and simply omits the
  /// port segment from the composed URL.
  void setPort(String value) {
    state = state.copyWith(port: value, errorMessage: null);
    _recomposeDomain();
  }

  /// Builds the final domain URL from protocol + address + optional port,
  /// always ending in exactly one trailing slash. Reads protocol from
  /// state (set via [setProtocol]) rather than taking it as a parameter —
  /// previously this defaulted to 'https://' whenever address/port changed
  /// without explicitly re-passing the protocol, silently overwriting the
  /// user's http:// selection on the very next keystroke.
  void _recomposeDomain() {
    final protocol = state.protocol;
    final address = state.address.trim();
    final port = state.port.trim();

    if (address.isEmpty) {
      state = state.copyWith(domain: '');
      return;
    }

    final hostAndPort = port.isNotEmpty ? '$address:$port' : address;
    state = state.copyWith(domain: '$protocol$hostAndPort/');
  }

  /// Called by the screen when the protocol dropdown (http/https) changes,
  /// since that also affects the composed domain.
  void setProtocol(String protocol) {
    state = state.copyWith(protocol: protocol);
    _recomposeDomain();
  }

  /// Validates the port field. Returns null if valid (including empty —
  /// port is optional), or an error string for the form field to display.
  String? validatePort(String? value) {
    final port = (value ?? '').trim();
    if (port.isEmpty) return null; // optional

    if (!_portPattern.hasMatch(port)) {
      return 'Port must be numbers only';
    }
    final portNum = int.parse(port);
    if (portNum < 1 || portNum > 65535) {
      return 'Port must be between 1 and 65535';
    }
    return null;
  }

  /// Saves the domain, then fetches + saves branch and pos config.
  /// Returns true only if every step succeeds — the screen should stay on
  /// setup and show [SetupState.errorMessage] otherwise, so the user can
  /// fix input or retry rather than proceeding with incomplete config.
  Future<bool> saveSetup() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final branchId = state.branchId.trim();
    final posId = state.posId.trim();
    final domain = state.domain.trim();

    if (branchId.isEmpty || posId.isEmpty || domain.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Branch ID, POS ID, and Domain are all required.',
      );
      return false;
    }

    final portError = validatePort(state.port);
    if (portError != null) {
      state = state.copyWith(isLoading: false, errorMessage: portError);
      return false;
    }

    try {
      // 1. Save the domain FIRST and await it. apiClient reads the domain
      //    from the DB via activeDomainProvider, so the branch/pos calls
      //    right after this must see the new value already committed.
      await ref.read(domainConfigDaoProvider).saveDomain(domain);

      // 2. Fetch + save branch and pos config from the server.
      final syncResult = await ref
          .read(initialSyncServiceProvider)
          .run(branchId: branchId, posId: posId);

      if (!syncResult.success) {
        state = state.copyWith(
          isLoading: false,
          errorMessage:
              syncResult.errorMessage ??
              'Sync already in progress, please wait.',
        );
        return false;
      }

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to save configuration. Please try again.',
      );
      return false;
    }
  }
}
