import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:simple_accouting/database/models/account.dart';
import 'package:simple_accouting/database/models/operation.dart';
import 'package:simple_accouting/database/repositoies/account_repository.dart';
import 'package:simple_accouting/database/repositoies/operation_repository.dart';
import '../menu.dart';

class OperationsPage extends StatefulWidget {
  const OperationsPage({Key? key}) : super(key: key);

  @override
  _OperationsPageState createState() => _OperationsPageState();
}

class _OperationsPageState extends State<OperationsPage> {
  late Future<List<Operation>> _operationWidgets;
  late List<Account> _accounts;
  final _formKey = GlobalKey<FormBuilderState>();

  void onSave() async {
    FormBuilderState? formState = _formKey.currentState;
    formState?.save();
    if (formState != null && formState.validate()) {
      Operation operation = Operation();
      operation.amount = double.parse(formState.fields['amount']?.value);
      operation.date = formState.fields['date']?.value;
      operation.account = formState.fields['account']?.value;
      operation.profile = 1;
      OperationRepository.save(operation);
      setState(() {
        _operationWidgets = OperationRepository.all();
      });
    }
    Navigator.pop(context, 'Saved');
  }

  void onDelete(Operation operation) async {
    OperationRepository.remove(operation);
    setState(() {
      _operationWidgets = OperationRepository.all();
    });
  }

  @override
  void initState() {
    super.initState();
    _operationWidgets = OperationRepository.all();
    AccountRepository.all().then((accounts) => _accounts = accounts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the SimpleAccounting object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Simple accounting - Vos opérations'),
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
                              title: const Text('Ajouter une opération'),
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
                                            name: 'amount',
                                            decoration: const InputDecoration(
                                              labelText: 'Montant',
                                            ),
                                            validator:
                                                FormBuilderValidators.compose([
                                              FormBuilderValidators.required(
                                                  context),
                                              FormBuilderValidators.numeric(
                                                  context)
                                            ]),
                                            keyboardType: TextInputType.text,
                                          ),
                                          FormBuilderDateTimePicker(
                                            name: 'date',
                                            inputType: InputType.date,
                                            decoration: const InputDecoration(
                                              labelText: 'Date de l\'opération',
                                            ),
                                            validator:
                                                FormBuilderValidators.required(
                                                    context),
                                          ),
                                          FormBuilderSearchableDropdown(
                                            name: 'account',
                                            items: _accounts,
                                            decoration: const InputDecoration(
                                                labelText:
                                                    'Searchable Dropdown'),
                                          )
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
              future: _operationWidgets,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<Operation> operations = snapshot.data;
                  return Expanded(
                      child: ListView.separated(
                          separatorBuilder: (context, index) => const Divider(
                                color: Colors.black,
                              ),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: operations.length,
                          itemBuilder: (context, index) {
                            Operation operation = operations[index];
                            final operationDate =
                                operation.date ?? DateTime.now();
                            return ListTile(
                              title: Text(operation.account.toString()),
                              subtitle: Text(operation.amount.toString() +
                                  "€" +
                                  " - " +
                                  DateFormat('yyyy-MM-dd')
                                      .format(operationDate)),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => onDelete(operation),
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
