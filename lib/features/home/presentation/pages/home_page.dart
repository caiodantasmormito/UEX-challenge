import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uex_app/core/firebase/firebase.dart';
import 'package:uex_app/features/contacts/presentation/bloc/delete_contacts/delete_contacts_bloc.dart';
import 'package:uex_app/features/contacts/presentation/bloc/get_contacts/get_contacts_bloc.dart';
import 'package:uex_app/features/contacts/presentation/pages/add_contacts_page.dart';
import 'package:uex_app/features/contacts/presentation/pages/edit_contacts_page.dart';
import 'package:uex_app/features/login/presentation/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocus;
  String _searchText = '';
  String? _userId;

  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        Future.microtask(() => GoRouter.of(context).go(LoginPage.routeName));
      }
    });
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
      debugPrint('Usuário autenticado com ID: $_userId');
      context.read<GetContactsBloc>().add(GetDataContacts(userId: _userId!));
    } else {
      debugPrint('Nenhum usuário autenticado.');
    }
    _searchController = TextEditingController();
    _searchFocus = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _refreshContacts() async {
    if (_userId != null) {
      context.read<GetContactsBloc>().add(GetDataContacts(userId: _userId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 60),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async {
            await context.push(AddContactsPage.routeName);
            final userId = FirebaseAuth.instance.currentUser?.uid;
            if (userId != null) {
              context
                  .read<GetContactsBloc>()
                  .add(GetDataContacts(userId: userId));
            }
          },
          child: const Text(
            'Criar contato',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Contatos'),
        actions: [
          PopupMenuButton<int>(
            color: Colors.white,
            icon: const Icon(Icons.menu, color: Colors.black),
            onSelected: (value) {
              if (value == 0) {
                FirebaseAuth.instance.signOut();
                context.pushReplacement(LoginPage.routeName);
              } else if (value == 1) {
                final authService = AuthService();

                _showDeleteAccountDialog(context, authService);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Text('Sair'),
              ),
              const PopupMenuItem(
                value: 1,
                child: Text('Excluir conta'),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshContacts,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Pesquisar por nome ou CPF',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.search),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchText = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isAscending ? Icons.sort_by_alpha : Icons.sort,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _isAscending = !_isAscending;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocConsumer<GetContactsBloc, GetContactsState>(
                listener: (context, state) {
                  if (state is GetContactsError && state.message != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message!),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is GetContactsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is GetContactsSuccess) {
                    final filteredContacts = state.contacts.where((contact) {
                      return contact.name.toLowerCase().contains(_searchText) ||
                          contact.cpf.contains(_searchText);
                    }).toList();

                    filteredContacts.sort((a, b) => _isAscending
                        ? a.name.compareTo(b.name)
                        : b.name.compareTo(a.name));

                    if (filteredContacts.isNotEmpty) {
                      return ListView.builder(
                        itemCount: filteredContacts.length,
                        itemBuilder: (context, index) {
                          final contact = filteredContacts[index];
                          return Card(
                            elevation: 3,
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.002),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                              ),
                              title: Text(
                                contact.name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                spacing: 4,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(contact.address),
                                  Text('${contact.city}/${contact.uf}'),
                                  Text('CPF: ${contact.cpf}'),
                                  Text('Tel: ${contact.phone}'),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.black),
                                    onPressed: () async {
                                      await context.push(
                                        UpdateContactsPage.routeName,
                                        extra: contact,
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      _showDeleteDialog(context, contact.id);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(flex: 1),
                          const Icon(
                            Icons.contact_mail_outlined,
                            size: 100,
                            color: Colors.grey,
                          ),
                          const Text(
                            'Nenhum contato disponível',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Adicione um novo contato para começar',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    );
                  }
                  return const Center(
                    child: Text("Nenhum contato encontrado."),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String contactId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text(
          'Tem certeza que deseja excluir este contato?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<DeleteContactsBloc>().add(DeleteContact(
                    contactId: contactId,
                  ));
              _refreshContacts();
            },
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, AuthService authService) {
    final TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Excluir conta'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Para excluir sua conta, insira sua senha abaixo.'),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Digite sua senha";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final password = passwordController.text;

                try {
                  await authService.deleteAccount(password);

                  if (context.mounted) {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Conta excluída com sucesso')),
                    );
                    await FirebaseAuth.instance.signOut();
                    await Future.delayed(const Duration(milliseconds: 300));

                    if (context.mounted) {
                      context.go(LoginPage.routeName);
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Senha incorreta')),
                    );
                  }
                }
              }
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
