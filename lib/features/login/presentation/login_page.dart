import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uex_app/core/firebase/firebase.dart';
import 'package:uex_app/features/home/presentation/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocus;
  late final FocusNode _passwordFocus;
  final firebaseService = AuthService();
  bool isRegistering = false;
  bool isLoading = false;
  bool _isObscurePassword = true;
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).dialogBackgroundColor,
              Theme.of(context).primaryColor
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            spacing: MediaQuery.of(context).size.height * 0.08,
            children: [
              SafeArea(
                child: Image.asset(
                  'assets/images/uex.png',
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocus,
                      onEditingComplete: () => _passwordFocus.requestFocus(),
                      decoration: InputDecoration(
                        label: Text("E-Mail"),
                        hintText: 'Digite seu e-mail',
                        errorStyle: TextStyle(color: Colors.white),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "E-mail obrigatório.";
                        }

                        final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );

                        if (!emailRegex.hasMatch(value)) {
                          return "E-mail inválido.";
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isObscurePassword,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscurePassword = !_isObscurePassword;
                            });
                          },
                          icon: _isObscurePassword
                              ? const Icon(Icons.visibility_outlined)
                              : const Icon(Icons.visibility_off_outlined),
                        ),
                        label: Text("Password"),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Password obrigatório.";
                        }
                        if (value.trim().length < 8) {
                          return "Password deve conter no mínimo 8 caractéres";
                        }
                        return null;
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isRegistering = !isRegistering;
                        });
                      },
                      child: Text(
                        isRegistering ? "Entrar" : "Registre-se",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });

                      try {
                        if (isRegistering) {
                          await firebaseService.registerWithEmailAndPassword(
                            _emailController.text,
                            _passwordController.text,
                          );
                          context.pushReplacement(HomePage.routeName);
                        } else {
                          final user =
                              await firebaseService.signInWithEmailAndPassword(
                            _emailController.text,
                            _passwordController.text,
                          );

                          if (user != null) {
                            context.pushReplacement(HomePage.routeName);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Falha ao fazer login. Verifique suas credenciais.")),
                            );
                          }
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("$e")),
                        );
                      } finally {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isLoading
                        ? Center(
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Center(
                            child: Text(
                              !isRegistering ? "Entrar" : "Registre-se",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
