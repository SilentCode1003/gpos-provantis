import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/database/domain/customer_dto.dart';
import 'package:gpos_provantis/src/services/customer_service.dart';
import 'package:gpos_provantis/src/shared/widgets/toast_emitter.dart';

part 'customer_controller.g.dart';

class CustomerUiState {
  const CustomerUiState({this.showPurchaseOrder = false, this.draft});

  /// Whether the Purchase Order field belongs in the prompt (a store setting).
  final bool showPurchaseOrder;

  /// What the cashier entered for the sale in progress.
  final CustomerDraft? draft;

  bool get hasCustomer => draft != null;
}

// Kept alive: the prompt, the cart and the sale completing in the dashboard
// controller all touch the same pending customer.
@Riverpod(keepAlive: true)
class CustomerController extends _$CustomerController {
  @override
  CustomerUiState build() => const CustomerUiState();

  /// Called when Charge is tapped. Forgets any customer left over from a
  /// payment that was cancelled, then says whether the customer prompt should
  /// be shown at all (a store setting).
  Future<bool> beginCheckout() async {
    final service = ref.read(customerServiceProvider);
    final toast = ref.read(toastEmitterProvider);

    service.clearDraft();
    state = const CustomerUiState();

    try {
      final settings = await service.loadSettings();
      state = CustomerUiState(showPurchaseOrder: settings.purchaseOrderEnabled);
      return settings.promptEnabled;
    } catch (e) {
      // Without this, tapping Charge would just appear to do nothing.
      toast.error(
        'Could not start checkout: '
        '${e.toString().replaceFirst('Exception: ', '')}',
      );
      rethrow;
    }
  }

  /// The cashier filled the customer in. It is held until the sale completes.
  void saveDraft(CustomerDraft draft) {
    ref.read(customerServiceProvider).setDraft(draft);
    state = CustomerUiState(
      showPurchaseOrder: state.showPurchaseOrder,
      draft: draft,
    );
  }

  /// The cashier chose to go on without a customer.
  void skip() {
    ref.read(customerServiceProvider).clearDraft();
    state = CustomerUiState(showPurchaseOrder: state.showPurchaseOrder);
  }
}
