class Profile {
  static const String table = 'profiles';

  final int? id;
  String? firstName;
  String? lastName;
  String? bankIban;
  String? bankName;
  double? initialBalance;

  Profile({
    this.id,
    this.firstName,
    this.lastName,
    this.bankIban,
    this.bankName,
    this.initialBalance,
  });

  factory Profile.fromDatabase(Map<String, dynamic> data) => Profile(
        id: data['id'],
        firstName: data['first_name'],
        lastName: data['last_name'],
        bankIban: data['bank_iban'],
        bankName: data['bank_name'],
        initialBalance: data['initial_balance'],
      );

  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'bank_iban': bankIban,
      'bank_name': bankName,
      'initial_balance': initialBalance,
    };
  }
}
