import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uex_app/core/utils/string_utils.dart';
import 'package:uex_app/features/address/presentation/bloc/get_address_bloc.dart';
import 'package:uex_app/features/contacts/domain/entities/contacts_entity.dart';

import '../bloc/add_contacts/add_contacts_bloc.dart';

class AddContactsPage extends StatefulWidget {
  const AddContactsPage({super.key});
  static const String routeName = '/addContacts';

  @override
  State<AddContactsPage> createState() => _AddContactsPageState();
}

class _AddContactsPageState extends State<AddContactsPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _cpfController;
  late final TextEditingController _longitudeController;
  late final TextEditingController _cepController;
  late final TextEditingController _addressController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _districtController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _phoneController;
  late final FocusNode _cityFocus;
  late final FocusNode _phoneFocus;
  late final FocusNode _stateFocus;
  late final FocusNode _districtFocus;
  late final FocusNode _nameFocus;
  late final FocusNode _cpfFocus;
  late final FocusNode _longitudeFocus;
  late final FocusNode _latitudeFocus;
  late final FocusNode _cepFocus;
  late final FocusNode _addressFocus;
  late final GlobalKey<FormState> _formKey;
  late final AddContactsBloc _addContactsBloc;
  MaskTextInputFormatter cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp('[0-9]')},
  );
  MaskTextInputFormatter cepFormatter = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {'#': RegExp('[0-9]')},
  );
  MaskTextInputFormatter phoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp('[0-9]')},
  );

  @override
  void initState() {
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _districtController = TextEditingController();
    _nameController = TextEditingController();
    _cpfController = TextEditingController();
    _longitudeController = TextEditingController();
    _cepController = TextEditingController();
    _addressController = TextEditingController();
    _latitudeController = TextEditingController();
    _phoneController = TextEditingController();
    //context.read<LocationBloc>().add(GetCurrentLocation());

    _formKey = GlobalKey<FormState>();
    _cityFocus = FocusNode();
    _phoneFocus = FocusNode();
    _stateFocus = FocusNode();
    _districtFocus = FocusNode();
    _nameFocus = FocusNode();
    _cpfFocus = FocusNode();
    _longitudeFocus = FocusNode();
    _latitudeFocus = FocusNode();
    _cepFocus = FocusNode();
    _addressFocus = FocusNode();
    //context.read<GetContactsBloc>().add(GetDataContacts());

    _addContactsBloc = context.read<AddContactsBloc>();

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cpfController.dispose();
    _longitudeController.dispose();
    _cepController.dispose();
    _addressController.dispose();
    _stateController.dispose();
    _districtController.dispose();

    _nameFocus.dispose();
    _phoneFocus.dispose();
    _cpfFocus.dispose();
    _longitudeFocus.dispose();
    _latitudeFocus.dispose();
    _cepFocus.dispose();
    _addressFocus.dispose();
    _districtFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    focusNode: _nameFocus,
                    controller: _nameController,
                    decoration: const InputDecoration(
                      label: Text('Nome'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nome é obrigatório';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    focusNode: _phoneFocus,
                    controller: _phoneController,
                    inputFormatters: [phoneFormatter],
                    decoration: const InputDecoration(
                      label: Text('Telefone'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Telefone é obrigatório';
                      }
                      if (value.length < 11) {
                        return 'Telefone invalido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    focusNode: _cpfFocus,
                    controller: _cpfController,
                    inputFormatters: [cpfFormatter],
                    decoration: const InputDecoration(
                      label: Text('CPF'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'CPF é obrigatório';
                      } else if (!CPFValidator.isValid(value)) {
                        return 'CPF inválido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    focusNode: _cepFocus,
                    controller: _cepController,
                    inputFormatters: [cepFormatter],
                    decoration: const InputDecoration(
                      label: Text('CEP'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'CEP é obrigatório';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      value = cepWithoutMask(_cepController.text);
                      if (value.length == 8) {
                        context.read<GetAddressBloc>().add(
                              Address(cep: value),
                            );
                      }
                    },
                  ),
                  TextFormField(
                    focusNode: _addressFocus,
                    controller: _addressController,
                    decoration: const InputDecoration(
                      label: Text('Endereço'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Endereço é obrigatório';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    focusNode: _districtFocus,
                    controller: _districtController,
                    decoration: const InputDecoration(
                      label: Text('Bairro'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bairro é obrigatório';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    focusNode: _cityFocus,
                    controller: _cityController,
                    decoration: const InputDecoration(
                      label: Text('Cidade'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Cidade é obrigatório';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    focusNode: _stateFocus,
                    controller: _stateController,
                    decoration: const InputDecoration(
                      label: Text('Estado'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Estado é obrigatória';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    focusNode: _latitudeFocus,
                    controller: _latitudeController,
                    decoration: const InputDecoration(
                      label: Text('Latitude'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Latitude é obrigatória';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    focusNode: _longitudeFocus,
                    controller: _longitudeController,
                    decoration: const InputDecoration(
                      label: Text('Longitude'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Longitude é obrigatória';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  //MapSelector(),
                  BlocListener<GetAddressBloc, GetAddressState>(
                    listener: (context, state) {
                      if (state is GetAddressSuccess) {
                        _addressController.text = state.address.logradouro;
                        _cityController.text = state.address.localidade;
                        _districtController.text = state.address.bairro;
                        _stateController.text = state.address.estado;
                      }
                      if (state is GetAddressError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message!),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: SizedBox.shrink(),
                  ),
                  BlocConsumer<AddContactsBloc, AddContactsState>(
                    listener: (context, state) {
                      if (state is AddContactsError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message!),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                      if (state is AddContactsSuccess) {
                        _nameController.clear();
                        _cpfController.clear();
                        _addressController.clear();
                        _cepController.clear();
                        _latitudeController.clear();
                        _longitudeController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Contato criado com sucesso!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    builder: (context, state) {
                      if (state is AddContactsLoading) {
                        return const CircularProgressIndicator(
                          color: Colors.white,
                        );
                      }
                      return ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _addContactsBloc.add(
                              CreateContacts(
                                ContactsEntity(
                                  id: '',
                                  phone: _phoneController.text,
                                  uf: _stateController.text,
                                  district: _districtController.text,
                                  city: _cityController.text,
                                  name: _nameController.text,
                                  cep: _cepController.text,
                                  coordinates: LatLng(
                                    double.parse(_latitudeController.text),
                                    double.parse(_longitudeController.text),
                                  ),
                                  address: _addressController.text,
                                  cpf: _cpfController.text,
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('Criar contato'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
