/// Thrown when a sale is saved with a receipt (detail) id that already belongs
/// to a *different* sale.
///
/// Saving the same sale twice is not an error: the save is simply skipped. But
/// if the id is taken by another sale, the server would answer "already exist"
/// to the new one and it would be marked as uploaded without ever being sent,
/// so the sale would be lost. Failing here lets the caller take a fresh id.
class DuplicateDetailIdException implements Exception {
  const DuplicateDetailIdException(this.detailId);

  final String detailId;

  String get message =>
      'Receipt number $detailId is already used by another sale.';

  @override
  String toString() => 'DuplicateDetailIdException: $message';
}
