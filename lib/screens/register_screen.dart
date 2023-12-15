import 'package:flutter/material.dart';
import 'package:travelgo/services/services.dart';
import 'package:provider/provider.dart';
import 'package:travelgo/ui/input_decorations.dart';
import 'package:travelgo/widgets/widgets.dart';
import 'package:travelgo/providers/login_provider.dart';
import '../services/notifications_service.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 220),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Cadastro',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => LoginProvider(),
                      child: const _LoginForm(),
                    ),                    
                  ],
                ),
              ),
              const SizedBox(height: 50),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'login'),
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                      Colors.indigo.withOpacity(0.1),
                    ),
                    shape: MaterialStateProperty.all(const StadiumBorder())),
                child: const Text(
                  'Já possui uma conta?',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 17,
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginProvider>(context);
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: loginForm.formKey,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'usuario@email.com',
              labelText: 'E-mail',
              prefixIcon: Icons.alternate_email_rounded,
            ),
            onChanged: (value) => loginForm.email = value,
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value ?? "") ? null : "E-mail inválido!";
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.name,
            decoration: InputDecorations.authInputDecoration(
              hintText: '*********',
              labelText: 'Senha',
              prefixIcon: Icons.lock_outline,
            ),
            onChanged: (value) => loginForm.password = value,
            validator: (value) {
              if (value != null && value.length >= 8) return null;
              return 'A senha deve conter, no mínimo, 8 caracteres!';
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.deepPurple,
            onPressed: loginForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus(); 
                    final authService =
                        Provider.of<AuthService>(context, listen: false);                    
                    if (!loginForm.isValidForm()) return;
                    loginForm.isLoading = true;
                   
                    final String? errorMessage = await authService.createUser(
                        loginForm.email, loginForm.password);
                    if (errorMessage == null) {
                      Navigator.pushReplacementNamed(context, 'home');
                    } else {                      
                      NotificationsService.showSnackbar(errorMessage);
                      loginForm.isLoading = false;
                    }
                  },
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(loginForm.isLoading ? 'Aguarde' : 'Cadastro',
                    style: const TextStyle(color: Colors.white))),
          )
        ],
      ),
    );
  }
}
