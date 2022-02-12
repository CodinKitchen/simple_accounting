import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:simple_accouting/database/db_helper.dart';
import 'package:simple_accouting/database/models/account_category.dart';

Future<List<AccountCategory>> _loadAccountCategories() async {
  final database = await DBHelper.database();
  final result = await database.query('account_categories');
  return result.isNotEmpty
      ? result.map((item) => AccountCategory.fromDatabase(item)).toList()
      : [];
}

class AccountsCategoriesPage extends StatefulWidget {
  const AccountsCategoriesPage({Key? key}) : super(key: key);

  @override
  _AccountsCategoriesPageState createState() => _AccountsCategoriesPageState();
}

class _AccountsCategoriesPageState extends State<AccountsCategoriesPage> {
  late Future<List<AccountCategory>> _accountCategories;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _accountCategories = _loadAccountCategories();
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
                        title: const Text('Ajouter une catégorie de compte'),
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
        future: _accountCategories,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<AccountCategory> categories = snapshot.data;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  AccountCategory category = categories[index];
                  return Text(category.name.toString());
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
