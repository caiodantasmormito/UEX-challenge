import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uex_app/features/address/domain/entities/address_entity.dart';
import 'package:uex_app/features/address/domain/usecases/get_address_by_uf_usecase.dart';
import 'package:uex_app/features/address/presentation/bloc/get_address_bloc.dart';
import 'package:uex_app/features/address/presentation/bloc/get_address_by_uf/get_address_by_uf_bloc.dart';
import 'package:uex_app/features/contacts/domain/entities/contacts_entity.dart';
import 'package:uex_app/features/contacts/presentation/bloc/update_contacts/update_contacts_bloc.dart';

class UpdateContactsPage extends StatefulWidget {
  final ContactsEntity contact;

  const UpdateContactsPage({super.key, required this.contact});
  static const String routeName = '/updateContacts';

  @override
  State<UpdateContactsPage> createState() => _UpdateContactsPageState();
}

class _UpdateContactsPageState extends State<UpdateContactsPage> {
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

  late String? selectedEstado;
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
  late final UpdateContactsBloc _editContactsBloc;

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
    super.initState();

    
    _nameController = TextEditingController(text: widget.contact.name);
    _cpfController = TextEditingController(text: widget.contact.cpf);
    _phoneController = TextEditingController(text: widget.contact.phone);
    _addressController = TextEditingController(text: widget.contact.address);
    _districtController = TextEditingController(text: widget.contact.district);
    _cityController = TextEditingController(text: widget.contact.city);
    _stateController = TextEditingController(text: widget.contact.uf);
    _cepController = TextEditingController(text: widget.contact.cep);
    _latitudeController = TextEditingController(
        text: widget.contact.coordinates.latitude.toString());
    _longitudeController = TextEditingController(
        text: widget.contact.coordinates.longitude.toString());

    selectedEstado = widget.contact.uf;

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

    _editContactsBloc = context.read<UpdateContactsBloc>();
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
        title: const Text('Editar Contato'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    focusNode: _cpfFocus,
                    controller: _cpfController,
                    inputFormatters: [cpfFormatter],
                    decoration: const InputDecoration(
                      label: Text('CPF'),
                    ),
                    readOnly: true, 
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'CPF é obrigatório';
                      } else if (!CPFValidator.isValid(value)) {
                        return 'CPF inexistente';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
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
                  BlocConsumer<UpdateContactsBloc, UpdateContactsState>(
                    listener: (context, state) {
                      if (state is UpdateContactsError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                      if (state is UpdateContactsSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Contato atualizado com sucesso!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    builder: (context, state) {
                      if (state is UpdateContactsLoading) {
                        return const CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _editContactsBloc.add(
                              UpdateContact(
                                ContactsEntity(
                                  id: widget.contact.id,
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
                        child: const Text('Salvar alterações'),
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
