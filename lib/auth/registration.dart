import 'package:flutter/material.dart';
import 'package:app/swagger.dart';
import 'package:app/search.dart';

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  hintText: 'Username',
                ),
                controller: nameController,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  hintText: 'Password',
                ),
                controller: passwordController,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  hintText: 'Repeat password',
                ),
                controller: repeatPasswordController,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(),
              child: Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all<Color>(
                      Colors.black,
                    ),
                    side: WidgetStateProperty.all<BorderSide>(
                      const BorderSide(color: Colors.black, width: 0.8),
                    ),
                  ),
                  onPressed: () async {
                    if (passwordController.text ==
                        repeatPasswordController.text) {

                      final isRegistered = await Swagger.registerUser(
                        context,
                        nameController.text,
                        passwordController.text,
                      );

                      if (isRegistered) {
                        final authData = await Swagger.loginUser(
                          context,
                          nameController.text,
                          passwordController.text,
                        );

                        if (authData != null && authData['access_token'] != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchScreen(
                                authToken: authData['access_token']!,
                                baseUrl: 'http://10.0.2.2:8000',
                              ),
                            ),
                          );
                        } else {
                          print('Ошибка: не удалось получить токен');
                        }
                      }
                    }
                  },
                  child: const Text('Create'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
