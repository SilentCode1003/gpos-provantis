import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/features/setup/domain/setup_model.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/services/sync/initial_sync.dart';

part 'setup_controller.g.dart';

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

  void setAddress(String value) {
    state = state.copyWith(address: value, errorMessage: null);
    _recomposeDomain();
  }

  void setPort(String value) {
    state = state.copyWith(port: value, errorMessage: null);
    _recomposeDomain();
  }

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

  void setProtocol(String protocol) {
    state = state.copyWith(protocol: protocol);
    _recomposeDomain();
  }

  String? validatePort(String? value) {
    final port = (value ?? '').trim();
    if (port.isEmpty) return null;

    if (!_portPattern.hasMatch(port)) {
      return 'Port must be numbers only';
    }
    final portNum = int.parse(port);
    if (portNum < 1 || portNum > 65535) {
      return 'Port must be between 1 and 65535';
    }
    return null;
  }

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
      debugPrint('🔧 saveSetup: saving domain="$domain"');
      await ref.read(domainConfigDaoProvider).saveDomain(domain);
      debugPrint('🔧 saveSetup: domain write committed');

      ref.invalidate(activeDomainProvider);
      ref.invalidate(apiClientProvider);
      final confirmedDomain = await ref
          .read(domainConfigDaoProvider)
          .getDomain();
      debugPrint(
        '🔧 saveSetup: confirmedDomain (direct read) = "$confirmedDomain"',
      );

      if (confirmedDomain != domain) {
        throw Exception('Domain did not save correctly. Please try again.');
      }
      debugPrint('🔧 saveSetup: domain confirmed, starting sync');

      final syncResult = await ref
          .read(initialSyncServiceProvider)
          .run(branchId: branchId, posId: posId);

      if (!syncResult.success) {
        debugPrint(
          '🔥 saveSetup: syncResult failed: ${syncResult.errorMessage}',
        );
        state = state.copyWith(
          isLoading: false,
          errorMessage:
              syncResult.errorMessage ??
              'Sync already in progress, please wait.',
        );
        return false;
      }

      debugPrint('🔧 saveSetup: sync succeeded');
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e, st) {
      debugPrint('🔥 saveSetup: caught in outer try/catch: $e');
      debugPrint('$st');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to save configuration. Please try again.',
      );
      return false;
    }
  }
}
