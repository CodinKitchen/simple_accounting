import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:simple_accouting/database/models/account.dart';
import 'package:simple_accouting/database/repositoies/account_repository.dart';
import 'package:simple_accouting/menu.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({Key? key}) : super(key: key);

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  late Future<List<Account>> _accounts;
  final _formKey = GlobalKey<FormBuilderState>();

  void onSave() async {
    FormBuilderState? formState = _formKey.currentState;
    formState?.save();
    if (formState != null && formState.validate()) {
      Account account = Account();
      account.name = formState.fields['name']?.value;
      account.code = formState.fields['code']?.value;
      account.profile = 1;
      AccountRepository.save(account);
      setState(() {
        _accounts = AccountRepository.all();
      });
    }
    Navigator.pop(context, 'Saved');
  }

  void onDelete(Account account) async {
    try {
      await AccountRepository.remove(account);
    } catch (e) {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Vous ne pouvez pas supprimer ce compte',
              style: TextStyle(color: Colors.red),
            ),
            content: const Text(
                'Ce compte est associé à des opérations, il ne peut pas être supprimé.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Fermer'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    setState(() {
      _accounts = AccountRepository.all();
    });
  }

  @override
  void initState() {
    super.initState();
    _accounts = AccountRepository.all();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the SimpleAccounting object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Simple accounting - Vos comptes'),
      ),
      drawer: const Menu(),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 300, top: 50, right: 300, bottom: 0),
        child: Center(
          child: Column(children: [
            SizedBox(
              height: 50,
              child: Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                      onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title:
                                  const Text('Ajouter une catégorie de compte'),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              content: Builder(
                                builder: (context) {
                                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                  var height =
                                      MediaQuery.of(context).size.height;
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
                                            validator:
                                                FormBuilderValidators.required(
                                                    context),
                                            keyboardType: TextInputType.text,
                                          ),
                                          FormBuilderTextField(
                                            name: 'code',
                                            decoration: const InputDecoration(
                                              labelText: 'Code',
                                            ),
                                            validator:
                                                FormBuilderValidators.compose([
                                              FormBuilderValidators.required(
                                                  context),
                                              FormBuilderValidators.match(
                                                  context, '^[A-Z]{3}\$',
                                                  errorText:
                                                      'Saisissez 3 majuscules')
                                            ]),
                                            keyboardType: TextInputType.text,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: onSave,
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
                  return Expanded(
                      child: ListView.separated(
                          separatorBuilder: (context, index) => const Divider(
                                color: Colors.black,
                              ),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: accounts.length,
                          itemBuilder: (context, index) {
                            Account account = accounts[index];
                            return ListTile(
                              title: Text(account.name.toString()),
                              subtitle: Text(account.code.toString()),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => onDelete(account),
                              ),
                            );
                          }));
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const CircularProgressIndicator();
              },
            ),
          ]),
        ),
      ),
    );
  }
}
