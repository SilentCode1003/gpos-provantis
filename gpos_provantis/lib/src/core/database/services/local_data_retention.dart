/// How long the device keeps sales it has already uploaded.
///
/// Once the server has a sale, the local copy is only a cache. Receipts and
/// history are read from the server, so synced sales older than
/// [syncedSalesRetention] are deleted. Sales that are NOT synced yet are never
/// deleted, however old they are.
abstract class LocalDataRetention {
  /// Synced sales older than this are removed from the device.
  static const Duration syncedSalesRetention = Duration(days: 7);

  /// The cleanup runs at most this often (per app session), so it doesn't hit
  /// the database on every sync cycle.
  static const Duration purgeInterval = Duration(hours: 6);

  /// Sales created before this moment are old enough to be removed.
  static DateTime syncedSalesCutoff([DateTime? now]) =>
      (now ?? DateTime.now()).subtract(syncedSalesRetention);
}
