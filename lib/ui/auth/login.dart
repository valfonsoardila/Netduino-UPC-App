import 'package:netduino_upc_app/domain/controller/controllerUserFirebase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({Key? key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ControlUserAuth controlua = Get.find();
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/images/NetduinoUPC_logo.png',
                      width:
                          100, // Ajusta el ancho de la imagen según tus necesidades
                      height:
                          100, // Ajusta la altura de la imagen según tus necesidades
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Netduino UPC',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Color.fromARGB(255, 89, 217, 217),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40.0),
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
                        prefixIcon:
                            const Icon(Icons.email, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: pass,
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
                      obscureText: true,
                    ),
                    const SizedBox(height: 40.0),
                    ElevatedButton(
                      onPressed: () {
                        //Proceso de validación de usuario
                        controlua.estadoUser == null;
                        controlua.userValido == null;
                        if (user.text == "" && pass.text == "") {
                          Get.snackbar(
                              "No ha ingresado su correo electronico, ni su contraseña",
                              "Por favor ingrese su correo y contraseña");
                        } else if (user.text == "") {
                          Get.snackbar("No ha ingresado su correo electronico",
                              "Por favor ingrese su correo");
                        } else if (pass.text == "") {
                          Get.snackbar("No ha ingreado su contraseña",
                              "por favor ingrese una contraseña");
                        } else {
                          controlua
                              .ingresarUser(user.text, pass.text)
                              .then((value) {
                            if (controlua.userValido == null) {
                              Get.snackbar(
                                  "El usuario o contraseña no son correctos",
                                  controlua.mensajesUser,
                                  duration: const Duration(seconds: 4),
                                  backgroundColor:
                                      const Color.fromARGB(255, 73, 73, 73));
                            } else {
                              if (controlua.estadoUser == null) {
                                Get.snackbar(
                                    "El usuario o contraseña no son correctos",
                                    controlua.mensajesUser,
                                    duration: const Duration(seconds: 4),
                                    backgroundColor:
                                        const Color.fromARGB(255, 73, 73, 73));
                              } else {
                                if (controlua.estadoUser != null) {
                                  // Get.snackbar("Ha iniciado sesión correctamente",
                                  //     controlua.mensajesUser,
                                  //     duration: const Duration(seconds: 4),
                                  //     backgroundColor:
                                  //         const Color.fromARGB(255, 73, 73, 73));
                                  // controlua.userValido!.user?.uid;
                                  String uid = controlua.userValido!.user!.uid;
                                  Get.toNamed("/principal", arguments: uid);
                                  // Get.to(Home(uid: uid));
                                }
                              }
                            }
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 89, 217, 217),
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      child: const Text(
                        'Iniciar sesión',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.toNamed("/register");
                            },
                            child: const Text(
                              'Registrarse',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                color: Color.fromARGB(255, 89, 217, 217),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.toNamed("/restaurar");
                            },
                            child: const Text(
                              'Restaurar contraseña',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                color: Color.fromARGB(255, 89, 217, 217),
                              ),
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
