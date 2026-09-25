import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';

part 'startup_controller.g.dart';

enum StartupDestination { login, setup }

@riverpod
class StartupController extends _$StartupController {
  @override
  Future<StartupDestination> build({bool enforceMinDuration = true}) async {
    if (!enforceMinDuration) {
      return _resolveDestination();
    }

    final results = await Future.wait([
      _resolveDestination(),
      Future.delayed(const Duration(milliseconds: 2400)),
    ]);

    return results[0] as StartupDestination;
  }

  Future<StartupDestination> _resolveDestination() async {
    final dao = ref.read(domainConfigDaoProvider);
    await dao.cacheReady;

    final hasDomain = dao.cachedDomain != null && dao.cachedDomain!.isNotEmpty;
    return hasDomain ? StartupDestination.login : StartupDestination.setup;
  }
}
