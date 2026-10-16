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

  // Starts checkout and clears any leftover customer draft from a canceled payment.
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

  // Saves the customer info entered for the current sale until it is completed.
  void saveDraft(CustomerDraft draft) {
    ref.read(customerServiceProvider).setDraft(draft);
    state = CustomerUiState(
      showPurchaseOrder: state.showPurchaseOrder,
      draft: draft,
    );
  }

  // Clears the saved customer if the cashier chooses to proceed without one.
  void skip() {
    ref.read(customerServiceProvider).clearDraft();
    state = CustomerUiState(showPurchaseOrder: state.showPurchaseOrder);
  }
}
