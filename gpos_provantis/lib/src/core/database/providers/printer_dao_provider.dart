// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gpos_provantis/src/core/database/daos/printer_dao.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:gpos_provantis/src/core/database/app_database.dart';

// part 'printer_dao_provider.g.dart';

// @Riverpod(keepAlive: true)
// PrinterDao printerDao(Ref ref) {
//   final db = ref.watch(appDatabaseProvider);
//   return PrinterDao(db);
// }

// final printerProvider =
//     StreamNotifierProvider<PrinterNotifier, List<PrinterTableData>>(
//       PrinterNotifier.new,
//     );

// class PrinterNotifier extends StreamNotifier<List<PrinterTableData>> {
//   @override
//   Stream<List<CategoriesTableData>> build() {
//     final dao = ref.watch(printerDaoProvider);
//     return dao.watchAllPrinters();
//   }
// }
