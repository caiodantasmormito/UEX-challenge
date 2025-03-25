import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uex_app/features/address/domain/entities/address_entity.dart';
import 'package:uex_app/features/address/domain/usecases/get_address_by_uf_usecase.dart';
import 'package:uex_app/features/address/presentation/bloc/get_address_bloc.dart';
import 'package:uex_app/features/address/presentation/bloc/get_address_by_uf/get_address_by_uf_bloc.dart';
import 'package:uex_app/features/contacts/domain/entities/contacts_entity.dart';

import '../bloc/add_contacts/add_contacts_bloc.dart';

class AddContactsPage extends StatefulWidget {
  const AddContactsPage({super.key});
  static const String routeName = '/addContacts';

  @override
  State<AddContactsPage> createState() => _AddContactsPageState();
}

class _AddContactsPageState extends State<AddContactsPage> {
  final List<String> estadosBrasileiros = [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO'
  ];

  String? selectedEstado;
  late final TextEditingController _nameController;
  late final TextEditingController _cpfController;

  late final TextEditingController _cepController;
  late final TextEditingController _addressController;
  late final TextEditingController _numberController;

  late final TextEditingController _districtController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _phoneController;
  late final FocusNode _cityFocus;
  late final FocusNode _phoneFocus;
  late final FocusNode _stateFocus;
  late final FocusNode _numberFocus;
  late final FocusNode _districtFocus;
  late final FocusNode _nameFocus;
  late final FocusNode _cpfFocus;

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
    _numberController = TextEditingController();

    _cepController = TextEditingController();
    _addressController = TextEditingController();

    _phoneController = TextEditingController();

    _formKey = GlobalKey<FormState>();
    _cityFocus = FocusNode();
    _phoneFocus = FocusNode();
    _stateFocus = FocusNode();
    _districtFocus = FocusNode();
    _nameFocus = FocusNode();
    _cpfFocus = FocusNode();
    _numberFocus = FocusNode();

    _cepFocus = FocusNode();
    _addressFocus = FocusNode();

    _addContactsBloc = context.read<AddContactsBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cpfController.dispose();
    _numberController.dispose();
    _cepController.dispose();
    _addressController.dispose();
    _stateController.dispose();
    _districtController.dispose();

    _nameFocus.dispose();
    _phoneFocus.dispose();
    _cpfFocus.dispose();
    _numberFocus.dispose();
    _cepFocus.dispose();
    _addressFocus.dispose();
    _districtFocus.dispose();
    _cityFocus.dispose();
    _stateFocus.dispose();

    super.dispose();
  }

  void _buscarEnderecos() {
    if (selectedEstado != null &&
        _cityController.text.isNotEmpty &&
        _addressController.text.isNotEmpty) {
      context.read<GetAddressByUfBloc>().add(AddressByUf(
            params: GetAddressParams(
              uf: selectedEstado!,
              city: _cityController.text,
              address: _addressController.text,
            ),
          ));
    }
  }

  void _mostrarDialogoEnderecos(List<AddressEntity> addresses) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Selecione um endereço'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return ListTile(
                title: Text(address.logradouro),
                subtitle: Text('${address.bairro}, ${address.localidade}'),
                onTap: () {
                  _preencherCamposEndereco(address);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _preencherCamposEndereco(AddressEntity address) {
    setState(() {
      _addressController.text = address.logradouro;
      _districtController.text = address.bairro;
      _cityController.text = address.localidade;
      _stateController.text = address.uf;
      _cepController.text = address.cep;
      selectedEstado = address.uf;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Adicionar Contato'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 16,
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
                    keyboardType: TextInputType.phone,
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
                        return 'Telefone inválido';
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
                        return 'CPF inexistente';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedEstado,
                    decoration: const InputDecoration(
                      labelText: 'Estado (UF)',
                    ),
                    items: estadosBrasileiros.map((String estado) {
                      return DropdownMenuItem<String>(
                        value: estado,
                        child: Text(estado),
                      );
                    }).toList(),
                    onChanged: (String? novoEstado) {
                      setState(() {
                        selectedEstado = novoEstado;
                        _stateController.text = novoEstado ?? '';
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Estado é obrigatório';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _cityController,
                    focusNode: _cityFocus,
                    decoration: const InputDecoration(
                      labelText: 'Cidade',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Cidade é obrigatória';
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _addressFocus,
                          controller: _addressController,
                          decoration: const InputDecoration(
                            label: Text('Endereço'),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe um endereço';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _buscarEnderecos,
                        tooltip: 'Buscar endereços',
                      ),
                    ],
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    focusNode: _numberFocus,
                    controller: _numberController,
                    decoration: const InputDecoration(
                      label: Text('Número'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe um número';
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
                  ),
                  BlocListener<GetAddressBloc, GetAddressState>(
                    listener: (context, state) {
                      if (state is GetAddressSuccess) {
                        _preencherCamposEndereco(state.address);
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
                    child: const SizedBox.shrink(),
                  ),
                  BlocListener<GetAddressByUfBloc, GetAddressByUfState>(
                    listener: (context, state) {
                      if (state is GetAddressByUfSuccess) {
                        _mostrarDialogoEnderecos(state.addresses);
                      }
                      if (state is GetAddressByUfError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message.toString()),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const SizedBox.shrink(),
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
                        _numberController.clear();
                        _nameController.clear();
                        _cpfController.clear();
                        _addressController.clear();
                        _cepController.clear();

                        _phoneController.clear();
                        _cityController.clear();
                        _districtController.clear();
                        setState(() => selectedEstado = null);
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
                        return const CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (!CPFValidator.isValid(_cpfController.text)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Por favor, insira um CPF válido'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            _addContactsBloc.add(
                              CreateContacts(
                                ContactsEntity(
                                  id: '',
                                  number: _numberController.text,
                                  phone: _phoneController.text,
                                  uf: _stateController.text,
                                  district: _districtController.text,
                                  city: _cityController.text,
                                  name: _nameController.text,
                                  cep: _cepController.text,
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
