// ignore_for_file: prefer_const_constructors, prefer_null_aware_operators

import 'dart:io';
import 'package:netduino_upc_app/domain/controller/controllerUserFirebase.dart';
import 'package:netduino_upc_app/domain/controller/controllerPerfilUser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  ControlUserPerfil controlup = Get.find();
  ControlUserAuth controlua = Get.find();
  TextEditingController controlNombre = TextEditingController();
  TextEditingController controlUser = TextEditingController();
  TextEditingController controlPass = TextEditingController();
  TextEditingController controlProfesion = TextEditingController();
  TextEditingController controlCiudad = TextEditingController();
  TextEditingController controlDireccion = TextEditingController();
  TextEditingController controlCelular = TextEditingController();
  ImagePicker picker = ImagePicker(); // Lista de opciones
  List<String> registroSesion = [];
  String generoSeleccionado =
      'Masculino'; // Variable de estado para almacenar el valor seleccionado del género
  var generos = <String>[
    'Masculino',
    'Femenino',
    'Otro',
  ];
  @override
  var _image;
  _galeria() async {
    XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = (image != null) ? File(image.path) : null;
      //_image = File(image!.path);
    });
  }

  _camara() async {
    XFile? image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = (image != null) ? File(image.path) : null;
      // _image = File(image!.path);
    });
  }

  void initState() {
    super.initState();
    final args =
        Get.arguments; // Obtener los argumentos pasados desde la vista anterior
    registroSesion = args ?? "";
    controlNombre.text = registroSesion[0];
    controlUser.text = registroSesion[1];
    controlPass.text = registroSesion[2];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 89, 217, 217),
        title: const Text("Completar Perfil",
            style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: ListView(
            children: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: () {
                    _opcioncamara(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    height: 220,
                    width: double.maxFinite,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0),
                      ),
                      child: _image != null
                          ? Image.file(
                              _image,
                              width: 100,
                              height: 100,
                              fit: BoxFit.fitHeight,
                            )
                          : Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                enabled: false,
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
                  labelText: controlua.userValido!.user!.email,
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.email, color: Colors.white),
                ),
              ),
              TextFormField(
                controller: controlNombre,
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
                  labelText: "Confirme su nombre",
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon:
                      const Icon(Icons.accessibility_new, color: Colors.white),
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: controlProfesion,
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
                  labelText: 'Profesion',
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon:
                      const Icon(Icons.psychology_rounded, color: Colors.white),
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: controlCiudad,
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
                  labelText: 'Ciudad',
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon:
                      const Icon(Icons.add_location, color: Colors.white),
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: controlDireccion,
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
                  labelText: 'Direccion',
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon:
                      const Icon(Icons.add_home_work, color: Colors.white),
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: controlCelular,
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
                  labelText: 'Celular',
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon:
                      const Icon(Icons.phone_android, color: Colors.white),
                ),
              ),
              const SizedBox(height: 8.0),
              DropdownButton(
                hint: const Text(
                  'Genero',
                  style: TextStyle(color: Colors.white),
                ),
                dropdownColor: Colors.grey[800],
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                iconSize: 36,
                isExpanded: true,
                underline: const SizedBox(),
                style: const TextStyle(color: Colors.white),
                value: 'Masculino',
                onChanged: (newValue) {
                  setState(() {
                    generoSeleccionado =
                        newValue.toString(); // Actualiza el valor seleccionado
                  });
                },
                items: generos.map((valueItem) {
                  return DropdownMenuItem(
                    value: valueItem,
                    child: Text(valueItem),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  var catalogo = <String, dynamic>{
                    'id': controlua.userValido!.user!.uid,
                    'foto': _image != null ? _image.path : null,
                    'correo': controlUser.text,
                    'password': controlPass.text,
                    'estado': 'activo',
                    'nombre': controlNombre.text,
                    'genero': generoSeleccionado,
                    'profesion': controlProfesion.text,
                    'ciudad': controlCiudad.text,
                    'direccion': controlDireccion.text,
                    'celular': controlCelular.text,
                  };
                  controlup.crearcatalogo(catalogo, _image);
                  if (_image != null || _image == null) {
                    Get.snackbar("Perfil Guardado Correctamente",
                        controlup.mensajesPerfil,
                        duration: const Duration(seconds: 4),
                        backgroundColor: const Color.fromARGB(255, 73, 73, 73));
                    Get.toNamed("/login");
                  } else {
                    controlup.crearcatalogo(catalogo, null);
                    Get.snackbar("No se pudo guardar el perfil",
                        controlup.mensajesPerfil,
                        duration: const Duration(seconds: 4),
                        backgroundColor: const Color.fromARGB(255, 73, 73, 73));
                  }
                  //Peticiones.crearcatalogo(catalogo, _image);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 89, 217, 217),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                child: Text("Crear mi perfil"),
              ),
            ],
          ),
        ),
      ),
    );
  }

//Seleccionar la camara o la galeria

  void _opcioncamara(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Imagen de Galeria'),
                      onTap: () {
                        _galeria();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Capturar Imagen'),
                    onTap: () {
                      _camara();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
