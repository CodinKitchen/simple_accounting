import 'package:intl/intl.dart';
import 'package:simple_accouting/database/models/account.dart';

class Operation {
  static const String table = 'operations';

  final int? id;
  double? amount;
  DateTime? date;
  int? profile;
  Account? account;

  Operation({
    this.id,
    this.amount,
    this.date,
    this.profile,
    this.account,
  });

  factory Operation.fromDatabase(Map<String, dynamic> data) => Operation(
        id: data['id'],
        amount: data['amount'],
        date: DateTime.parse(data['date']),
        profile: data['profile_id'],
        account: Account(
            id: data['account_id'], code: data['code'], name: data['name']),
      );

  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'amount': amount,
      'date': DateFormat('yyyy-MM-dd').format(date ?? DateTime.now()),
      'profile_id': profile,
      'account_id': account?.id,
    };
  }
}
