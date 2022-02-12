import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:simple_accouting/database/db_helper.dart';
import 'package:simple_accouting/database/models/account.dart';

Future<List<Account>> _loadAccounts() async {
  final database = await DBHelper.database();
  final result = await database.query('accounts');
  return result.isNotEmpty
      ? result.map((item) => Account.fromDatabase(item)).toList()
      : [];
}

class AccountsListPage extends StatefulWidget {
  const AccountsListPage({Key? key}) : super(key: key);

  @override
  _AccountsListPageState createState() => _AccountsListPageState();
}

class _AccountsListPageState extends State<AccountsListPage> {
  late Future<List<Account>> _accounts;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _accounts = _loadAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 50,
        child: Align(
            alignment: Alignment.topRight,
            child: ElevatedButton(
                onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Ajouter un compte'),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        content: Builder(
                          builder: (context) {
                            // Get available height and width of the build area of this widget. Make a choice depending on the size.
                            var height = MediaQuery.of(context).size.height;
                            var width = MediaQuery.of(context).size.width;

                            return SizedBox(
                              height: height - 400,
                              width: width - 400,
                              child: FormBuilder(
                                key: _formKey,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                child: Column(
                                  children: <Widget>[
                                    FormBuilderTextField(
                                      name: 'name',
                                      decoration: const InputDecoration(
                                        labelText: 'Nom',
                                      ),
                                      validator: FormBuilderValidators.required(
                                          context),
                                      keyboardType: TextInputType.text,
                                    ),
                                    FormBuilderTextField(
                                      name: 'code',
                                      decoration: const InputDecoration(
                                        labelText: 'Code',
                                      ),
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(context),
                                        FormBuilderValidators.match(
                                            context, '^[A-Z]{3}\$',
                                            errorText: 'Saisissez 3 majuscules')
                                      ]),
                                      keyboardType: TextInputType.text,
                                    ),
                                    FormBuilderSearchableDropdown(
                                      name: 'category',
                                      items: const ['TEST', 'QSDQSD'],
                                      decoration: const InputDecoration(
                                        labelText: 'Catégorie',
                                      ),
                                      validator: FormBuilderValidators.required(
                                          context),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('Enregistrer'),
                          ),
                        ],
                      ),
                    ),
                child: const Icon(Icons.add))),
      ),
      FutureBuilder(
        future: _accounts,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<Account> accounts = snapshot.data;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  Account account = accounts[index];
                  return Text(account.name.toString());
                });
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const CircularProgressIndicator();
        },
      ),
    ]);
  }
}
