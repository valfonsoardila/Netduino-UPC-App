import 'package:netduino_upc_app/domain/controller/controllerUserFirebase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    //ControlUser controlu = Get.find();
    //ControlUserFirebase controlfb = Get.find();
    ControlUserAuth controlua = Get.find();
    TextEditingController nombre = TextEditingController();
    TextEditingController user = TextEditingController();
    TextEditingController pass = TextEditingController();
    return Container(
      color: Colors.black,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(children: [
              Container(
                padding: const EdgeInsets.only(top: 30),
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.person,
                        color: Color.fromARGB(255, 89, 217, 217), size: 40),
                    SizedBox(height: 10),
                    Text(
                      "Crear una Cuenta",
                      style: TextStyle(
                          color: Color.fromARGB(255, 89, 217, 217),
                          fontSize: 33),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    right: 35,
                    left: 35,
                    top: MediaQuery.of(context).size.height * 0.27),
                child: Column(children: [
                  TextFormField(
                    controller: nombre,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 89, 217, 217)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      labelText: 'Nombre completo',
                      labelStyle: const TextStyle(color: Colors.white),
                      prefixIcon: const Icon(Icons.supervised_user_circle,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: user,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 89, 217, 217)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      labelText: 'Correo electrónico',
                      labelStyle: const TextStyle(color: Colors.white),
                      prefixIcon: const Icon(Icons.email, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: pass,
                    obscureText: true,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 89, 217, 217)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      labelText: 'Contraseña',
                      labelStyle: const TextStyle(color: Colors.white),
                      prefixIcon: const Icon(Icons.lock, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Registrarse',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Color.fromARGB(255, 89, 217, 217),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () {
                              if (nombre.text.isEmpty &&
                                  user.text.isEmpty &&
                                  pass.text.isEmpty) {
                                Get.snackbar("Por favor llene todos los campos",
                                    controlua.mensajesUser,
                                    duration: const Duration(seconds: 4),
                                    backgroundColor:
                                        const Color.fromARGB(255, 73, 73, 73));
                              } else if (nombre.text.isEmpty) {
                                Get.snackbar(
                                    "Por favor llene el campo de nombre",
                                    controlua.mensajesUser,
                                    duration: const Duration(seconds: 4),
                                    backgroundColor:
                                        const Color.fromARGB(255, 73, 73, 73));
                              } else if (user.text.isEmpty) {
                                Get.snackbar(
                                    "Por favor llene el campo de correo",
                                    controlua.mensajesUser,
                                    duration: const Duration(seconds: 4),
                                    backgroundColor:
                                        const Color.fromARGB(255, 73, 73, 73));
                              } else if (pass.text.isEmpty) {
                                Get.snackbar(
                                    "Por favor llene el campo de contraseña",
                                    controlua.mensajesUser,
                                    duration: const Duration(seconds: 4),
                                    backgroundColor:
                                        const Color.fromARGB(255, 73, 73, 73));
                              } else {
                                controlua
                                    .crearUser(user.text, pass.text)
                                    .then((value) {
                                  if (controlua.userValido == null) {
                                    Get.snackbar(
                                        "Error al registrar, Asegurate de que tu contraseña es mayor a 6 caracteres",
                                        controlua.mensajesUser,
                                        duration: const Duration(seconds: 4),
                                        backgroundColor: const Color.fromARGB(
                                            255, 73, 73, 73));
                                  } else {
                                    Get.snackbar("¡Registrado Correctamente!",
                                        controlua.mensajesUser,
                                        duration: const Duration(seconds: 4),
                                        backgroundColor: const Color.fromARGB(
                                            255, 73, 73, 73));
                                    String password = pass.text;
                                    Get.toNamed("/perfil", arguments: [
                                      nombre.text,
                                      user.text,
                                      password
                                    ]);
                                  }
                                });
                              }
                            },
                            icon: const Icon(Icons.arrow_forward),
                          ),
                        ),
                      ]),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/login');
                          },
                          child: const Text(
                            'Inicio',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
