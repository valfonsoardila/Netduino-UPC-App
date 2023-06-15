import 'package:netduino_upc_app/domain/controller/controllerUserFirebase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Restaurar extends StatelessWidget {
  const Restaurar({super.key});

  @override
  Widget build(BuildContext context) {
    ControlUserAuth controlua = Get.find();
    TextEditingController user = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0, // Eliminar la sombra del AppBar
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Container(
                color: Colors.black,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: const Text(
                        '¿Has olvidado tu contraseña?',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: const Text(
                        'Introduce el correo electronico asociado\na tu cuenta y te enviaremos un codigo de verificacion',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.start,
                      ),
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
                        prefixIcon:
                            const Icon(Icons.email, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        if (user.text.isNotEmpty) {
                          controlua.recuperarPass(user.text).then((value) {
                            if (controlua.mensajesUser == "Proceso exitoso") {
                              Get.snackbar("Correo enviado",
                                  "Por favor revise su bandeja de entrada",
                                  duration: const Duration(seconds: 4),
                                  backgroundColor:
                                      const Color.fromARGB(255, 73, 73, 73));
                            } else {
                              Get.snackbar("No se pudo enviar el correo",
                                  "Por favor intente de nuevo",
                                  duration: const Duration(seconds: 4),
                                  backgroundColor:
                                      const Color.fromARGB(255, 73, 73, 73));
                            }
                          });
                        } else {
                          Get.snackbar("No ha ingresado un correo",
                              "Por favor intente de nuevo",
                              duration: const Duration(seconds: 4),
                              backgroundColor:
                                  const Color.fromARGB(255, 73, 73, 73));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 89, 217, 217),
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      child: const Text(
                        'Enviar enlace',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
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
