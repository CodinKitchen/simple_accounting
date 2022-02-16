class Account {
  static const String table = 'accounts';

  final int? id;
  String? name;
  String? code;
  int? profile;

  Account({this.id, this.name, this.code, this.profile});

  factory Account.fromDatabase(Map<String, dynamic> data) => Account(
      id: data['id'],
      name: data['name'],
      code: data['code'],
      profile: data['profile_id']);

  Map<String, dynamic> toDatabase() {
    return {'id': id, 'name': name, 'code': code, 'profile_id': profile};
  }

  @override
  String toString() {
    return (name ?? '') + ' - ' + (code ?? '');
  }
}
