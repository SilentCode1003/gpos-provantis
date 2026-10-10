import 'dart:async' show TimeoutException;
import 'dart:convert';
import 'dart:io' show SocketException;
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/email_dao.dart';
import 'package:gpos_provantis/src/core/database/daos/receipt_history_dao.dart';
import 'package:gpos_provantis/src/core/database/daos/sales_dao.dart';
import 'package:gpos_provantis/src/core/database/daos/split_payment_dao.dart';
import 'package:gpos_provantis/src/core/database/domain/email_dto.dart';
import 'package:gpos_provantis/src/core/database/domain/receipt_history_dto.dart';
import 'package:gpos_provantis/src/core/database/providers/email_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/receipt_history_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/sales_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/split_payment_dao_provider.dart';
import 'templates/ereceipt_template.dart';

part 'mailer_service.g.dart';

// ---- Errors -----------------------------------------------------------------

/// Anything that stops an e-receipt from being sent. Every subclass carries a
/// plain-language [message] the cashier can read.
sealed class EReceiptException implements Exception {
  const EReceiptException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// No sale, split sale or cached receipt has this OR number.
final class ReceiptNotFoundException extends EReceiptException {
  ReceiptNotFoundException(String orNumber)
    : super('No receipt found with OR# $orNumber.');
}

/// The mail account / branch details needed to send are missing.
final class MailerNotConfiguredException extends EReceiptException {
  const MailerNotConfiguredException(super.message);
}

/// The receipt was found but the mail server did not take it.
final class EReceiptSendException extends EReceiptException {
  const EReceiptSendException(super.message);
}

// ---- Configuration ----------------------------------------------------------

/// The mail account the e-receipts are sent from.
class MailerConfig {
  const MailerConfig({
    required this.host,
    required this.username,
    required this.password,
    this.port = 587,
    this.useSsl = false,
    this.supportEmail,
  });

  /// SMTP server, e.g. "smtp.gmail.com".
  final String host;

  /// The sending address. Also used as the SMTP login.
  final String username;
  final String password;

  /// 587 with [useSsl] false means STARTTLS, which is what the old mailer used.
  final int port;
  final bool useSsl;

  /// Shown in the footer ("Questions? Email ..."). Footer line is hidden when
  /// null or empty.
  final String? supportEmail;

  bool get isComplete =>
      host.trim().isNotEmpty &&
      username.trim().isNotEmpty &&
      password.isNotEmpty;
}

typedef MailerConfigLoader = Future<MailerConfig> Function();
typedef EReceiptBranchLoader = Future<EReceiptBranchInfo> Function();

// ---- Service ----------------------------------------------------------------

/// Finds a receipt by its OR number and emails it to a customer.
///
/// Where it looks, in order: sales saved on this device, split-payment sales
/// saved on this device, then the receipt-history cache pulled from the server.
class MailerService {
  MailerService({
    required SalesDao salesDao,
    required SplitPaymentDao splitPaymentDao,
    required ReceiptHistoryDao receiptHistoryDao,
    required MailerConfigLoader loadConfig,
    required EReceiptBranchLoader loadBranch,
    this.timeout = const Duration(seconds: 30),
  }) : _salesDao = salesDao,
       _splitPaymentDao = splitPaymentDao,
       _receiptHistoryDao = receiptHistoryDao,
       _loadConfig = loadConfig,
       _loadBranch = loadBranch;

  final SalesDao _salesDao;
  final SplitPaymentDao _splitPaymentDao;
  final ReceiptHistoryDao _receiptHistoryDao;
  final MailerConfigLoader _loadConfig;
  final EReceiptBranchLoader _loadBranch;

  /// How long to wait for the mail server before giving up.
  final Duration timeout;

  /// Looks the receipt up by [orNumber] (the receipt's detail id).
  /// Throws [ReceiptNotFoundException] if nothing matches.
  Future<EReceiptData> findReceipt(String orNumber) async {
    final or = orNumber.trim();

    final sale = await _salesDao.getSaleByDetailId(or);
    if (sale != null) return _fromSale(or, sale);

    final split = await _splitPaymentDao.getByDetailId(or);
    if (split != null) return _fromSplit(or, split);

    final cached = await _receiptHistoryDao.getByDetailId(or);
    if (cached != null) return _fromHistory(or, cached);

    throw ReceiptNotFoundException(or);
  }

  /// Emails the receipt with OR number [orNumber] to [recipient].
  ///
  /// [pdfAttachment] is optional: the old mailer always attached a PDF copy of
  /// the receipt, and this still can when the caller has the bytes.
  ///
  /// Throws an [EReceiptException] (see its subclasses) when it can't send.
  Future<void> sendEReceipt({
    required String orNumber,
    required String recipient,
    Uint8List? pdfAttachment,
  }) async {
    final receipt = await findReceipt(orNumber);

    final config = await _loadConfig();
    if (!config.isComplete) {
      throw const MailerNotConfiguredException(
        'The email account for sending receipts is not set up yet.',
      );
    }
    final branch = await _loadBranch();

    final message = Message()
      ..from = Address(config.username, branch.name)
      ..recipients.add(recipient.trim())
      ..subject = EReceiptEmail.subject(branch, receipt)
      ..html = EReceiptEmail.html(
        receipt: receipt,
        branch: branch,
        supportEmail: config.supportEmail,
      );

    if (pdfAttachment != null) {
      message.attachments.add(
        StreamAttachment(
          Stream<List<int>>.value(pdfAttachment),
          'application/pdf',
          fileName: '${receipt.orNumber}.pdf',
        ),
      );
    }

    final server = SmtpServer(
      config.host,
      port: config.port,
      ssl: config.useSsl,
      username: config.username,
      password: config.password,
    );

    try {
      final report = await send(message, server, timeout: timeout);
      debugPrint('[EReceipt] OR# ${receipt.orNumber} sent: $report');
    } on MailerException catch (e) {
      debugPrint('[EReceipt] OR# ${receipt.orNumber} not sent: ${e.message}');
      throw EReceiptSendException(
        'The mail server did not accept the receipt: ${e.message}',
      );
    } on TimeoutException {
      throw const EReceiptSendException(
        'The mail server took too long to answer. Try again.',
      );
    } on SocketException {
      throw const EReceiptSendException(
        'Could not reach the mail server. Check the internet connection '
        'and try again.',
      );
    }
  }

  // ---- Building the receipt from each source --------------------------------

  EReceiptData _fromSale(String or, SalesTableData row) {
    final cash = _num(row.cash);
    final ecash = _num(row.ecash);
    final total = _num(row.total);

    final payments = <EReceiptPayment>[
      if (cash > 0) EReceiptPayment(label: 'CASH', amount: cash),
      if (ecash > 0)
        EReceiptPayment(
          label: _str(row.paymentName),
          amount: ecash,
          reference: _cleanReference(_str(row.referenceId)),
        ),
    ];
    // A zero-peso sale: still say how it was paid.
    if (payments.isEmpty) {
      payments.add(
        EReceiptPayment(
          label: _str(row.paymentName),
          amount: total,
          reference: _cleanReference(_str(row.referenceId)),
        ),
      );
    }

    return EReceiptData(
      orNumber: or,
      posId: _str(row.posid),
      cashier: _str(row.cashier),
      dateText: _str(row.date),
      items: _parseItems(_str(row.items)),
      payments: payments,
      total: total,
    );
  }

  EReceiptData _fromSplit(String or, SplitPaymentTableData row) {
    return EReceiptData(
      orNumber: or,
      posId: row.posId,
      cashier: row.staff,
      dateText: row.date,
      items: _parseItems(row.items),
      payments: [
        EReceiptPayment(
          label: row.firstPaymentType,
          amount: row.firstPayment,
          reference: _cleanReference(row.firstPaymentReference),
        ),
        EReceiptPayment(
          label: row.secondPaymentType,
          amount: row.secondPayment,
          reference: _cleanReference(row.secondPaymentReference),
        ),
      ],
      total: row.total,
    );
  }

  EReceiptData _fromHistory(String or, ReceiptHistoryTableData row) {
    final items = [
      for (final i in row.items)
        EReceiptItem(
          name: _displayName(i.name),
          quantity: i.quantity,
          price: i.price,
        ),
    ];

    return EReceiptData(
      orNumber: or,
      posId: row.posId.toString(),
      cashier: row.cashier,
      dateText: _formatDateTime(row.createdAt),
      items: items,
      payments: [
        for (final t in row.tenders)
          EReceiptPayment(
            label: t.type,
            amount: t.amount,
            reference: _cleanReference(t.reference),
          ),
      ],
      // The cached row's items already include the discount line.
      total: items.fold<double>(0, (sum, i) => sum + i.lineTotal),
    );
  }
}

// ---- Provider ---------------------------------------------------------------

@Riverpod(keepAlive: true)
MailerService mailerService(Ref ref) {
  final emailDao = ref.watch(emailDaoProvider);

  return MailerService(
    salesDao: ref.watch(salesDaoProvider),
    splitPaymentDao: ref.watch(splitPaymentDaoProvider),
    receiptHistoryDao: ref.watch(receiptHistoryDaoProvider),
    loadConfig: () => _loadMailerConfig(emailDao),
    loadBranch: _loadBranchInfo,
  );
}

/// The account saved in Settings > Email. Read fresh on every send, so a
/// change in Settings applies to the next receipt without a restart.
Future<MailerConfig> _loadMailerConfig(EmailDao emailDao) async {
  final row = await emailDao.getEmail();
  final email = row == null ? EmailDto.empty : EmailDto.fromTableData(row);

  if (!email.isComplete) {
    throw const MailerNotConfiguredException(
      'The email account for sending receipts is not set up. '
      'Fill it in under Settings > Email.',
    );
  }

  return MailerConfig(
    host: email.smtpServer.trim(),
    username: email.emailAddress.trim(),
    password: email.password,
  );
}

/// WIRE THIS UP: return the branch name and address printed on the email.
///
/// The old mailer read `branchname` and `address` from `branch.json`.
Future<EReceiptBranchInfo> _loadBranchInfo() async {
  throw const MailerNotConfiguredException(
    'The branch details for the e-receipt are not set up yet.',
  );
}

// ---- Small helpers ----------------------------------------------------------

String _str(Object? value) => value?.toString() ?? '';

double _num(Object? value) {
  if (value is num) return value.toDouble();
  final text = _str(value).replaceAll(RegExp(r'[^0-9.-]'), '');
  return double.tryParse(text) ?? 0;
}

int _int(Object? value) => _num(value).toInt();

/// Cash sales are stored with the reference "CASH"; that is not a reference.
String _cleanReference(String reference) {
  final trimmed = reference.trim();
  return trimmed.toUpperCase() == 'CASH' ? '' : trimmed;
}

/// Services are sent to the server as "Srv - Haircut"; the customer should see
/// "Haircut", as on the printed receipt.
String _displayName(String name) =>
    name.replaceFirst(RegExp(r'^Srv\s*-\s*'), '');

List<EReceiptItem> _parseItems(String json) {
  try {
    final decoded = jsonDecode(json);
    if (decoded is! List) return const [];
    return [
      for (final x in decoded)
        if (x is Map)
          EReceiptItem(
            name: _displayName(_str(x['name'])),
            quantity: _int(x['quantity']),
            price: _num(x['price']),
          ),
    ];
  } catch (_) {
    return const [];
  }
}

String _formatDateTime(DateTime d) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}';
}
