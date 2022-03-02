class Account {
  static const String table = 'accounts';

  final int? id;
  String? name;
  String? code;
  String? type;
  int? profile;

  Account({this.id, this.name, this.code, this.type, this.profile});

  factory Account.fromDatabase(Map<String, dynamic> data) => Account(
      id: data['id'],
      name: data['name'],
      code: data['code'],
      type: data['type'],
      profile: data['profile_id']);

  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'type': type,
      'profile_id': profile
    };
  }

  @override
  String toString() {
    String label = name ?? '';
    if (code != null) {
      label += ' - ' + (code ?? '');
    }
    return label;
  }
}
