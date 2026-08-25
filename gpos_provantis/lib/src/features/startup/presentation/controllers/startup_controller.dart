import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';

part 'startup_controller.g.dart';

/// Where the splash screen should navigate to once startup checks finish.
enum StartupDestination {
  /// A domain has already been saved from a previous run — skip setup.
  login,

  /// No domain saved yet — this is a fresh install or setup was never
  /// completed.
  setup,
}

@riverpod
class StartupController extends _$StartupController {
  @override
  Future<StartupDestination> build({bool enforceMinDuration = true}) async {
    // Run the domain-cache check and the minimum splash duration at the
    // same time, so the total wait is whichever takes longer — not the
    // sum of both. On a fast device the DB read finishes almost
    // instantly, so this mostly just waits out the 1.2s below; on a slow
    // first launch, the splash naturally stays up until the check
    // actually finishes instead of cutting it short.
    //
    // enforceMinDuration is false when we're re-entering /startup right
    // after Setup completes (see SetupScreen._handleSubmit). That pass
    // isn't a cold boot — there's nothing to visually settle — so the
    // artificial 1.2s hold would just look like a redundant extra splash
    // screen between Setup and Login rather than a deliberate wait.
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
    // Waits for the one-time startup DB read that populates the domain
    // cache — see DomainConfigDao.cacheReady. Without this, a restarted
    // app could be checked before the cache has loaded, incorrectly
    // sending an already-set-up device back to /setup.
    await dao.cacheReady;

    final hasDomain = dao.cachedDomain != null && dao.cachedDomain!.isNotEmpty;
    return hasDomain ? StartupDestination.login : StartupDestination.setup;
  }
}
