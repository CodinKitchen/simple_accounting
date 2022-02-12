class AccountCategory {
  final int id;
  final String? name;
  final String? code;

  AccountCategory({
    required this.id,
    this.name,
    this.code,
  });

  factory AccountCategory.fromDatabase(Map<String, dynamic> data) =>
      AccountCategory(
        id: data['id'],
        name: data['name'],
        code: data['code'],
      );

  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'name': name,
      'code': code,
    };
  }
}
