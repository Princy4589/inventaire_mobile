import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pgi_mobile/services/online/signin_service.dart';
import 'package:pgi_mobile/utils/token.dart';

// This is the code I've written
class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: LoginWidget()),
    );
  }
}

// this is a code in the documentation of flutter
class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  Token token = Token();
  var _passwordVisible = false;

  @override
  void initState() {
    //is loggedIn(), une fonction qui :
    //Vérifie si l'utilisateur s'est connecter auparavant
    //Si oui, cela va rediriger vers le menu, sinon, on aura
    //un écran de connexion
    isLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Image logo fid afficher au dessus du formulaire de login
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 35),
                child: Image.asset('assets/icons/fid_logo.png',
                    height: 200, width: 200),
              ),

              const SizedBox(height: 30),
              // Formulaire Login
              Padding(
                // L'utilisateur va entrer son email ici
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 8.0),
                child: TextFormField(
                    // Le controller ici est utilisé pour prendre les valeurs
                    // entrées par l'utilisateur
                    controller: controllerEmail,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-mail*',
                      prefixIcon: Icon(Icons.mail),
                    ),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "* Ce champ est requis"),
                      EmailValidator(
                          errorText:
                              'Veuillez entrer une adresse email valide'),
                    ])),
              ),
              // L'utilisateur va entrer son mot de passe ici
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 8.0),
                  child: TextFormField(
                    controller: controllerPassword,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Mot de passe*',
                      prefixIcon: const Icon(Icons.key),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),

                    // The validator receives the text that the user has entered.
                    validator: MultiValidator([
                      RequiredValidator(errorText: "* Ce champ est requis"),
                    ]),
                  )),
              // On a ici le bouton se connecter
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(19, 62, 103, 1),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // lorsque les champs sont proprement remplis,
                      //En cliquant sur le bouton, on récupère les données
                      //entrées par l'utilisateur et les mets en paramètre dans
                      //la méthode login qui va faire l'authentification et
                      // va rediriger vers l'écran d'accueil
                      //authenticate(controllerEmail.text, controllerPassword.text);
                      await authenticateUser(controllerEmail.text,
                          controllerPassword.text, context);
                    }
                  },
                  child: const Text('SE CONNECTER'),
                ),
              ),

              Container(
                  margin: const EdgeInsets.all(10),
                  child: const Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        'Copyright © FID 2022',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ))),
            ]),
      ),
    );
  }
}
