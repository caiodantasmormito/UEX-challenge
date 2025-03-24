import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
  @override
  void initState() {
    context.read<GetContactsBloc>().add(GetDataContacts());

    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.push(
            AddContactsPage.routeName,
          );
        },
      ),
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                FirebaseAuth.instance.signOut();
                context.pushReplacement(LoginPage.routeName);
              },
              child: Icon(Icons.logout),
            ),
          )
        ],
      ),
      body: Column(
        children: [
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
                return Center(
                  child: const CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              }
              if (state is GetContactsSuccess) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.contacts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          state.contacts[index].name,
                        ),
                        subtitle: Text(state.contacts[index].cpf),
                      );
                    },
                  ),
                );
              }
              return Text(
                "Home Page",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
