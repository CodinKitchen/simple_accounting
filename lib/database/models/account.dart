import 'package:simple_accouting/database/models/account_category.dart';

class Account {
  final int id;
  final String name;
  final String code;
  final AccountCategory category;

  Account({
    required this.id,
    required this.name,
    required this.code,
    required this.category,
  });

  factory Account.fromDatabase(Map<String, dynamic> data) => Account(
        id: data['id'],
        name: data['name'],
        code: data['code'],
        category: AccountCategory(id: data['category_id']),
      );

  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'category_id': category.id,
    };
  }
}
