import 'dart:convert' show HtmlEscape;

/// What the e-receipt email shows, and the HTML that shows it.
///
/// The layout and CSS are the ones from the old `email.dart`. The data is
/// plain values (no database rows) so the template can be tested on its own.

/// The business details printed at the top and bottom of the email.
class EReceiptBranchInfo {
  const EReceiptBranchInfo({required this.name, this.address = ''});

  final String name;

  /// Printed as one line under the receipt, e.g. "123 Main St, Imus, Cavite".
  final String address;
}

class EReceiptItem {
  const EReceiptItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  final String name;
  final int quantity;
  final double price;

  double get lineTotal => price * quantity;
}

/// One payment taken for the receipt. A split sale has two.
class EReceiptPayment {
  const EReceiptPayment({
    required this.label,
    required this.amount,
    this.reference = '',
  });

  /// e.g. "CASH" or "GCASH".
  final String label;
  final double amount;

  /// The e-payment reference. Empty for cash.
  final String reference;
}

class EReceiptData {
  const EReceiptData({
    required this.orNumber,
    required this.posId,
    required this.cashier,
    required this.dateText,
    required this.items,
    required this.payments,
    required this.total,
  });

  final String orNumber;
  final String posId;
  final String cashier;

  /// Shown as-is, e.g. "2026-10-10 11:30".
  final String dateText;
  final List<EReceiptItem> items;
  final List<EReceiptPayment> payments;
  final double total;
}

class EReceiptEmail {
  const EReceiptEmail._();

  static String subject(EReceiptBranchInfo branch, EReceiptData receipt) =>
      '${branch.name} - OR#:${receipt.orNumber} [E-Receipt]';

  /// The email body. Every value that came from the sale or the branch is
  /// HTML-escaped, so an item called `Tea <large>` can't break the layout.
  static String html({
    required EReceiptData receipt,
    required EReceiptBranchInfo branch,
    String? supportEmail,
  }) {
    final itemRows = StringBuffer();
    for (final item in receipt.items) {
      itemRows.write('''
          <tr>
            <td>${_e(item.name)} x ${item.quantity}</td>
            <td class="alignright">${_money(item.price)}</td>
            <td class="alignright">${_money(item.lineTotal)}</td>
          </tr>
''');
    }

    final detailLines = <String>[
      'Cashier: ${_e(receipt.cashier)}',
      'POS ID: ${_e(receipt.posId)}',
      'OR#: ${_e(receipt.orNumber)}',
      'Date: ${_e(receipt.dateText)}',
      for (final p in receipt.payments)
        p.reference.isEmpty
            ? 'Payment: ${_e(p.label)} - ${_money(p.amount)}'
            : 'Payment: ${_e(p.label)} - ${_money(p.amount)} '
                  '(Ref. #: ${_e(p.reference)})',
    ];

    final support = (supportEmail ?? '').trim();
    final footerRow = support.isEmpty
        ? ''
        : '''
                        <tr>
                            <td class="aligncenter content-block">Questions? Email <a href="mailto:${_e(support)}">${_e(support)}</a></td>
                        </tr>
''';

    return '''
<html>
<head>
<meta charset="utf-8">
$_css
</head>
<body>

<table class="body-wrap">
    <tbody><tr>
        <td></td>
        <td class="container" width="600">
            <div class="content">
                <table class="main" width="100%" cellpadding="0" cellspacing="0">
                    <tbody><tr>
                        <td class="content-wrap aligncenter">
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tbody>
                                <tr>
                                    <td class="content-block">
                                        <h2>${_e(branch.name)}</h2>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content-block">
                                        <table class="invoice">
                                            <tbody>
                                            <tr>
                                                <td>${detailLines.join('<br>')}</td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table class="invoice-items" cellpadding="0" cellspacing="10">
                                                        <thead>
                                                          <tr>
                                                            <th>Item</th>
                                                            <th>Price</th>
                                                            <th>Subtotal</th>
                                                          </tr>
                                                        </thead>
                                                        <tbody>
                                                          $itemRows
                                                          <tr class="total">
                                                              <td class="aligncenter" width="60%">Total</td>
                                                              <td></td>
                                                              <td class="alignright">${_money(receipt.total)}</td>
                                                          </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                        </tbody></table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content-block">
                                     ${_e(branch.address)}
                                    </td>
                                </tr>
                                <tr>
                                  <td>Thank you for being our valued customer. We hope our product will meet your expectations. Let us know if you have any questions.</td>
                                </tr>
                            </tbody></table>
                        </td>
                    </tr>
                </tbody></table>
                <div class="footer">
                    <table width="100%">
                        <tbody>
$footerRow                    </tbody></table>
                </div></div>
        </td>
        <td></td>
    </tr>
</tbody></table>
</body>
</html>
''';
  }
}

const _escape = HtmlEscape();

String _e(String value) => _escape.convert(value);

/// "₱1,234.50" as HTML (the peso sign is an entity so it survives any mail
/// client's encoding). Digits only, so nothing here needs escaping.
String _money(double value) {
  final parts = value.abs().toStringAsFixed(2).split('.');
  final whole = parts[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  return '${value < 0 ? '-' : ''}&#8369;$whole.${parts[1]}';
}

/// The stylesheet from the old email.dart.
const _css = r'''
<style>
/* -------------------------------------
    GLOBAL
    A very basic CSS reset
------------------------------------- */
* {
    margin: 0;
    padding: 0;
    font-family: "Helvetica Neue", "Helvetica", Helvetica, Arial, sans-serif;
    box-sizing: border-box;
    font-size: 14px;
}

img {
    max-width: 100%;
}

body {
    -webkit-font-smoothing: antialiased;
    -webkit-text-size-adjust: none;
    width: 100% !important;
    height: 100%;
    line-height: 1.6;
}

/* Let's make sure all tables have defaults */
table td {
    vertical-align: top;
}

/* -------------------------------------
    BODY & CONTAINER
------------------------------------- */
body {
    background-color: #f6f6f6;
}

.body-wrap {
    background-color: #f6f6f6;
    width: 100%;
}

.container {
    display: block !important;
    max-width: 600px !important;
    margin: 0 auto !important;
    /* makes it centered */
    clear: both !important;
}

.content {
    max-width: 800px;
    margin: 0 auto;
    display: block;
    padding: 20px;
}

/* -------------------------------------
    HEADER, FOOTER, MAIN
------------------------------------- */
.main {
    background: #fff;
    border: 1px solid #e9e9e9;
    border-radius: 3px;
}

.content-wrap {
    padding: 20px;
}

.content-block {
    padding: 0 0 20px;
}

.header {
    width: 100%;
    margin-bottom: 20px;
}

.footer {
    width: 100%;
    clear: both;
    color: #999;
    padding: 20px;
}
.footer a {
    color: #999;
}
.footer p, .footer a, .footer unsubscribe, .footer td {
    font-size: 12px;
}

/* -------------------------------------
    TYPOGRAPHY
------------------------------------- */
h1, h2, h3 {
    font-family: "Helvetica Neue", Helvetica, Arial, "Lucida Grande", sans-serif;
    color: #000;
    margin: 40px 0 0;
    line-height: 1.2;
    font-weight: 400;
}

h1 {
    font-size: 32px;
    font-weight: 500;
}

h2 {
    font-size: 24px;
}

h3 {
    font-size: 18px;
}

h4 {
    font-size: 14px;
    font-weight: 600;
}

p, ul, ol {
    margin-bottom: 10px;
    font-weight: normal;
}
p li, ul li, ol li {
    margin-left: 5px;
    list-style-position: inside;
}

/* -------------------------------------
    LINKS & BUTTONS
------------------------------------- */
a {
    color: #1ab394;
    text-decoration: underline;
}

.btn-primary {
    text-decoration: none;
    color: #FFF;
    background-color: #1ab394;
    border: solid #1ab394;
    border-width: 5px 10px;
    line-height: 2;
    font-weight: bold;
    text-align: center;
    cursor: pointer;
    display: inline-block;
    border-radius: 5px;
    text-transform: capitalize;
}

/* -------------------------------------
    OTHER STYLES THAT MIGHT BE USEFUL
------------------------------------- */
.last {
    margin-bottom: 0;
}

.first {
    margin-top: 0;
}

.aligncenter {
    text-align: center;
}

.alignright {
    text-align: right;
}

.alignleft {
    text-align: left;
}

.clear {
    clear: both;
}

/* -------------------------------------
    ALERTS
    Change the class depending on warning email, good email or bad email
------------------------------------- */
.alert {
    font-size: 16px;
    color: #fff;
    font-weight: 500;
    padding: 20px;
    text-align: center;
    border-radius: 3px 3px 0 0;
}
.alert a {
    color: #fff;
    text-decoration: none;
    font-weight: 500;
    font-size: 16px;
}
.alert.alert-warning {
    background: #f8ac59;
}
.alert.alert-bad {
    background: #ed5565;
}
.alert.alert-good {
    background: #1ab394;
}

/* -------------------------------------
    INVOICE
    Styles for the billing table
------------------------------------- */
.invoice {
    margin: 40px auto;
    text-align: left;
    width: 80%;
}
.invoice td {
    padding: 5px 0;
}
.invoice .invoice-items {
    width: 100%;
}
.invoice .invoice-items td {
    border-top: #eee 1px solid;
}
.invoice .invoice-items .total td {
    border-top: 2px solid #333;
    border-bottom: 2px solid #333;
    font-weight: 700;
}

/* -------------------------------------
    RESPONSIVE AND MOBILE FRIENDLY STYLES
------------------------------------- */
@media only screen and (max-width: 640px) {
    h1, h2, h3, h4 {
        font-weight: 600 !important;
        margin: 20px 0 5px !important;
    }

    h1 {
        font-size: 22px !important;
    }

    h2 {
        font-size: 18px !important;
    }

    h3 {
        font-size: 16px !important;
    }

    .container {
        width: 100% !important;
    }

    .content, .content-wrap {
        padding: 10px !important;
    }

    .invoice {
        width: 100% !important;
    }
}
</style>
''';
