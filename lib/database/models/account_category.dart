class AccountCategory {
  final int id;
  final String name;
  final String code;

  AccountCategory({
    required this.id,
    required this.name,
    required this.code,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
    };
  }
}
