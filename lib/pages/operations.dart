import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_accouting/database/models/account.dart';
import 'package:simple_accouting/database/models/operation.dart';
import 'package:simple_accouting/database/repositoies/account_repository.dart';
import 'package:simple_accouting/database/repositoies/operation_repository.dart';
import 'package:simple_accouting/pdf/ledger.dart';
import 'package:simple_accouting/pdf/profit_and_loss.dart';
import '../menu.dart';

class OperationsPage extends StatefulWidget {
  const OperationsPage({Key? key}) : super(key: key);

  @override
  _OperationsPageState createState() => _OperationsPageState();
}

class _OperationsPageState extends State<OperationsPage> {
  late Future<List<Operation>> _operations;
  late List<Account> _accounts;
  DateTime? _dateFrom =
      DateTime.utc(DateTime.now().year, DateTime.now().month, 1);
  DateTime? _dateTo =
      DateTime.utc(DateTime.now().year, DateTime.now().month + 1, 1)
          .add(const Duration(days: -1));
  final _editFormKey = GlobalKey<FormBuilderState>();
  final _datesFormKey = GlobalKey<FormBuilderState>();

  void onSave(Operation operation) async {
    FormBuilderState? formState = _editFormKey.currentState;
    formState?.save();
    if (formState != null && formState.validate()) {
      operation.amount = double.parse(formState.fields['amount']?.value);
      operation.date = formState.fields['date']?.value;
      operation.account = formState.fields['account']?.value;
      operation.profile = 1;
      OperationRepository.save(operation);
      setState(() {
        _operations = OperationRepository.allByDates(_dateFrom, _dateTo);
      });
      Navigator.pop(context, 'Saved');
    }
  }

  void onDelete(Operation operation) async {
    OperationRepository.remove(operation);
    setState(() {
      _operations = OperationRepository.allByDates(_dateFrom, _dateTo);
    });
  }

  void onEdit(Operation? operation) async {
    Operation currentOperation = operation ?? Operation();
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Ajouter une opération'),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Builder(
          builder: (context) {
            // Get available height and width of the build area of this widget. Make a choice depending on the size.
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;

            return SizedBox(
              height: height - 400,
              width: width - 400,
              child: FormBuilder(
                key: _editFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: <Widget>[
                    FormBuilderTextField(
                      name: 'amount',
                      decoration: const InputDecoration(
                        labelText: 'Montant',
                      ),
                      initialValue: currentOperation.amount != null
                          ? currentOperation.amount.toString()
                          : '',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.numeric(context)
                      ]),
                      keyboardType: TextInputType.text,
                    ),
                    FormBuilderDateTimePicker(
                      name: 'date',
                      inputType: InputType.date,
                      decoration: const InputDecoration(
                        labelText: 'Date de l\'opération',
                      ),
                      initialValue: currentOperation.date,
                      validator: FormBuilderValidators.required(context),
                    ),
                    FormBuilderSearchableDropdown(
                      name: 'account',
                      items: _accounts,
                      itemAsString: (Account? account) {
                        return account.toString() +
                            ' - ' +
                            (account?.type == 'debit'
                                ? 'Compte de dépense'
                                : 'Compte de remboursement');
                      },
                      decoration: const InputDecoration(
                          labelText: 'Choisissez un compte'),
                      initialValue: currentOperation.account,
                    )
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
            onPressed: () => onSave(currentOperation),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void generatePdf(String type, List<Operation> operations) async {
    final documentsPath = await getApplicationDocumentsDirectory();
    String path = documentsPath.path;

    if (type == 'ledger') {
      path += "/grand_livre.pdf";
      final File file = File(path);
      await file.writeAsBytes(await generateLedger(operations));
    } else if (type == 'profitAndLoss') {
      path += "/compte_de_resultat.pdf";
      final File file = File(path);
      await file.writeAsBytes(await generateProfitAndLoss(operations));
    } else {
      throw Exception('Invalid PDF type');
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Génération terminée',
            style: TextStyle(color: Colors.green),
          ),
          content: Text('Votre fichier $path est disponible'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _operations = OperationRepository.allByDates(_dateFrom, _dateTo);
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
                child: Row(children: [
                  Expanded(
                    child: Container(),
                  ),
                  ElevatedButton(
                    onPressed: () => onEdit(null),
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  FutureBuilder(
                    future: _operations,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData && snapshot.data.length > 0) {
                        List<Operation> operations = snapshot.data;
                        return ElevatedButton(
                          onPressed: () async {
                            generatePdf('ledger', operations);
                          },
                          child: Row(children: const [
                            Icon(Icons.picture_as_pdf),
                            Text("Grand livre"),
                          ]),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  FutureBuilder(
                    future: _operations,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData && snapshot.data.length > 0) {
                        List<Operation> operations = snapshot.data;
                        return ElevatedButton(
                          onPressed: () async {
                            generatePdf('profitAndLoss', operations);
                          },
                          child: Row(children: const [
                            Icon(Icons.picture_as_pdf),
                            Text("Compte de résultat"),
                          ]),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ]),
              ),
            ),
            FormBuilder(
              key: _datesFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: FormBuilderDateTimePicker(
                      name: 'date_from',
                      inputType: InputType.date,
                      initialValue: _dateFrom,
                      decoration: const InputDecoration(
                        labelText: 'Du',
                      ),
                      validator: FormBuilderValidators.required(context),
                      onChanged: (DateTime? value) {
                        setState(() {
                          _dateFrom = value;
                          _operations = OperationRepository.allByDates(
                              _dateFrom, _dateTo);
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 50.0),
                  Expanded(
                    child: FormBuilderDateTimePicker(
                      name: 'date_to',
                      inputType: InputType.date,
                      initialValue: _dateTo,
                      decoration: const InputDecoration(
                        labelText: 'Au',
                      ),
                      validator: FormBuilderValidators.required(context),
                      onChanged: (DateTime? value) {
                        setState(() {
                          _dateTo = value;
                          _operations = OperationRepository.allByDates(
                              _dateFrom, _dateTo);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            FutureBuilder(
              future: _operations,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<Operation> operations = snapshot.data;
                  if (operations.isEmpty) {
                    return const Expanded(
                      child: Center(
                        child: Text(
                          'Aucune opérations pour la période sélectionnée',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                      ),
                    );
                  }
                  return Expanded(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Date")),
                        DataColumn(label: Text("Opération")),
                        DataColumn(label: Text("Dépenses")),
                        DataColumn(label: Text("Recettes")),
                        DataColumn(label: Text("Actions")),
                      ],
                      rows: operations
                          .map((Operation operation) => DataRow(cells: [
                                DataCell(Text(DateFormat('yyyy-MM-dd')
                                    .format(operation.date ?? DateTime.now()))),
                                DataCell(Text(operation.account?.name ?? '')),
                                DataCell(Text(operation.account?.type == 'debit'
                                    ? operation.amount.toString()
                                    : '')),
                                DataCell(Text(
                                    operation.account?.type == 'credit'
                                        ? operation.amount.toString()
                                        : '')),
                                DataCell(Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () => onDelete(operation),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () => onEdit(operation),
                                      )
                                    ]))
                              ]))
                          .toList(),
                    ),
                  );
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
