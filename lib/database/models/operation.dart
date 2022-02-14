import 'package:intl/intl.dart';
import 'package:simple_accouting/database/models/account.dart';

class Operation {
  final int? id;
  final double amount;
  final DateTime date;
  final Account? account;

  Operation({
    this.id,
    required this.amount,
    required this.date,
    this.account,
  });

  factory Operation.fromDatabase(Map<String, dynamic> data) => Operation(
        id: data['id'],
        amount: data['amount'],
        date: DateTime.parse(data['date']),
      );

  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'amount': amount,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'account_id': account?.id,
    };
  }
}
