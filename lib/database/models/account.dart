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

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'category_id': category.id,
    };
  }
}
