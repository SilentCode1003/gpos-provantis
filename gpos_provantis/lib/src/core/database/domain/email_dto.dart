import 'package:drift/drift.dart' show Value;

import 'package:gpos_provantis/src/core/database/app_database.dart';

/// The mail account e-receipts are sent from.
class EmailDto {
  const EmailDto({
    required this.emailAddress,
    required this.password,
    required this.smtpServer,
  });

  /// There is only ever one email row; this is its id.
  static const rowId = 'email_config';

  static const empty = EmailDto(emailAddress: '', password: '', smtpServer: '');

  /// The sending address. Also the SMTP login.
  final String emailAddress;
  final String password;

  /// Host name only, e.g. "smtp.gmail.com".
  final String smtpServer;

  /// True when all three fields are filled in, so mail can be sent.
  bool get isComplete =>
      emailAddress.trim().isNotEmpty &&
      password.isNotEmpty &&
      smtpServer.trim().isNotEmpty;

  factory EmailDto.fromTableData(EmailTableData row) {
    return EmailDto(
      emailAddress: row.emailAddress,
      password: row.password,
      smtpServer: row.smtpServer,
    );
  }

  EmailTableCompanion toCompanion() {
    return EmailTableCompanion(
      id: const Value(rowId),
      emailAddress: Value(emailAddress),
      password: Value(password),
      smtpServer: Value(smtpServer),
    );
  }

  EmailDto copyWith({
    String? emailAddress,
    String? password,
    String? smtpServer,
  }) {
    return EmailDto(
      emailAddress: emailAddress ?? this.emailAddress,
      password: password ?? this.password,
      smtpServer: smtpServer ?? this.smtpServer,
    );
  }
}