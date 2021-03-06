import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:simple_accouting/database/models/profile.dart';
import 'package:simple_accouting/database/repositoies/profile_repository.dart';
import '../menu.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Profile _profile = Profile();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    ProfileRepository.loadProfile().then((profile) {
      _profile = profile;
      _formKey.currentState?.patchValue({
        'firstName': _profile.firstName,
        'lastName': _profile.lastName,
        'bankIban': _profile.bankIban,
        'bankName': _profile.bankName,
        'initialBalance': _profile.initialBalance?.toString(),
      });
    });
  }

  void onSave() async {
    FormBuilderState? formState = _formKey.currentState;
    formState?.save();
    if (formState != null && formState.validate()) {
      _profile.firstName = formState.fields['firstName']?.value;
      _profile.lastName = formState.fields['lastName']?.value;
      _profile.bankIban = formState.fields['bankIban']?.value;
      _profile.bankName = formState.fields['bankName']?.value;
      _profile.initialBalance =
          double.parse(formState.fields['initialBalance']?.value);
      ProfileRepository.save(_profile);

      const snackBar = SnackBar(
        content: Text('Informations enregistrées'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the SimpleAccounting object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Simple accounting - Votre profil'),
      ),
      drawer: const Menu(),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 300, top: 50, right: 300, bottom: 0),
        child: Column(children: [
          FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(children: <Widget>[
              FormBuilderTextField(
                name: 'firstName',
                decoration: const InputDecoration(
                  labelText: 'Prénom',
                ),
                validator: FormBuilderValidators.required(context),
              ),
              FormBuilderTextField(
                name: 'lastName',
                decoration: const InputDecoration(
                  labelText: 'Nom',
                ),
                validator: FormBuilderValidators.required(context),
              ),
              FormBuilderTextField(
                name: 'bankIban',
                decoration: const InputDecoration(
                  labelText: 'Iban',
                ),
                validator: FormBuilderValidators.required(context),
              ),
              FormBuilderTextField(
                name: 'bankName',
                decoration: const InputDecoration(
                  labelText: 'Banque',
                ),
                validator: FormBuilderValidators.required(context),
              ),
              FormBuilderTextField(
                name: 'initialBalance',
                decoration: const InputDecoration(
                  labelText: 'Balance initiale',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                  FormBuilderValidators.numeric(context),
                ]),
                keyboardType: TextInputType.number,
              ),
            ]),
          ),
          const SizedBox(
            height: 50,
          ),
          MaterialButton(
            color: Theme.of(context).colorScheme.secondary,
            child: const Text(
              "Enregistrer",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: onSave,
          ),
        ]),
      ),
    );
  }
}
