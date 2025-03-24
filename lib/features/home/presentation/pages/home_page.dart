import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uex_app/features/contacts/presentation/bloc/delete_contacts/delete_contacts_bloc.dart';
import 'package:uex_app/features/contacts/presentation/bloc/get_contacts/get_contacts_bloc.dart';
import 'package:uex_app/features/contacts/presentation/pages/add_contacts_page.dart';
import 'package:uex_app/features/login/presentation/login_page.dart';

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

  @override
  void initState() {
    super.initState();
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
    } else {
      debugPrint('Erro: _userId está nulo.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push(AddContactsPage.routeName);
          final userId = FirebaseAuth.instance.currentUser?.uid;
          if (userId != null) {
            context
                .read<GetContactsBloc>()
                .add(GetDataContacts(userId: userId));
          }
        },
      ),
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                FirebaseAuth.instance.signOut();
                context.pushReplacement(LoginPage.routeName);
              },
              child: const Icon(Icons.logout),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshContacts,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Pesquisar por nome ou CPF',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchText = value.toLowerCase();
                  });
                },
              ),
            ),
            BlocConsumer<GetContactsBloc, GetContactsState>(
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
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                }
                if (state is GetContactsSuccess) {
                  final filteredContacts = state.contacts.where((contact) {
                    return contact.name.toLowerCase().contains(_searchText) ||
                        contact.cpf.contains(_searchText);
                  }).toList();

                  return Expanded(
                    child: ListView.builder(
                      itemCount: filteredContacts.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(filteredContacts[index].name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(filteredContacts[index].address),
                              Row(
                                children: [
                                  Text('${filteredContacts[index].city} / '),
                                  Text(filteredContacts[index].uf),
                                ],
                              ),
                              Text(filteredContacts[index].cpf),
                              Text(filteredContacts[index].phone),
                            ],
                          ),
                          trailing: SizedBox(
                            width: 60,
                            child: Wrap(
                              spacing: 3,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: const Icon(Icons.edit),
                                ),
                                BlocListener<DeleteContactsBloc,
                                    DeleteContactsState>(
                                  listener: (context, state) {
                                    if (state is DeleteContactsError) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text(state.message.toString()),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                    if (state is DeleteContactsSuccess) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Contato excluído com sucesso!'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );

                                      final userId = FirebaseAuth
                                          .instance.currentUser?.uid;
                                      if (userId != null) {}
                                    }
                                  },
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title:
                                              const Text('Confirmar exclusão'),
                                          content: const Text(
                                            'Tem certeza que deseja excluir este contato?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                context
                                                    .read<DeleteContactsBloc>()
                                                    .add(DeleteContact(
                                                      contactId:
                                                          filteredContacts[
                                                                  index]
                                                              .id,
                                                    ));
                                              },
                                              child: const Text('Excluir',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: const Icon(Icons.delete,
                                        color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const Center(
                  child: Text("Nenhum contato encontrado."),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
