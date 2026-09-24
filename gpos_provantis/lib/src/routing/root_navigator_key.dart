// Location: src/routing/root_navigator_key.dart
//
// A single, app-lifetime GlobalKey<NavigatorState> for the router's
// root Navigator. Exists so code that needs to show a dialog/snackbar
// from somewhere that doesn't have a *stable* BuildContext of its own
// — e.g. a tile inside a bottom sheet that's mid-close, or a callback
// that outlives the widget that started it — can reach a context that
// is guaranteed alive for as long as the app is running, instead of
// reusing a context tied to a route that's being torn down.
//
// This is exactly the bug `pos_restart_service.dart` hit: it was
// given the BuildContext of an OthersSheet list tile, then that sheet
// was popped one line before the context got reused for a second
// dialog. The moment `Navigator.pop()` runs, that tile's context starts
// being disposed as part of the sheet's closing animation, so a
// dialog opened against it a moment later can silently fail to show.
// Using `rootNavigatorKey.currentContext!` instead sidesteps that: the
// root Navigator this key points at outlives every route pushed on
// top of it, sheets included.
//
// Wired in by passing `navigatorKey: rootNavigatorKey` into the
// GoRouter(...) constructor in app_router.dart — GoRouter forwards
// this to the Navigator widget it builds internally, so
// `rootNavigatorKey.currentContext` resolves to that Navigator's own
// context once the app has built its first frame.
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
