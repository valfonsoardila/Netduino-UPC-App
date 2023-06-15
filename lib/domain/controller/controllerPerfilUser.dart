import 'package:netduino_upc_app/data/services/peticionesPerfil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ControlUserPerfil extends GetxController {
  final _response = Rxn();
  final _Datos = Rxn();
  final _mensaje = "".obs;
  final Rxn<UserCredential> _perfil = Rxn<UserCredential>();

  Future<void> crearcatalogo(Map<String, dynamic> catalogo, foto) async {
    try {
      print("llego al controlador");
      _response.value = await Peticiones.crearcatalogo(catalogo, foto);
      await controlPerfil(_response.value);
    } catch (error) {
      print('Error en la operación de registro: $error');
      await Future.delayed(Duration(seconds: 2)); // Esperar 2 segundos
      await crearcatalogo(catalogo, foto); // Reintentar el registro
    }
    //  _response.value = await Peticiones.crearcatalogo(catalogo, foto);
    //   await controlPerfil(_response.value);
  }

  Future<void> actualizarcatalogo(Map<String, dynamic> catalogo, foto) async {
    _response.value = await Peticiones.actualizarcatalogo(catalogo, foto);
    await controlPerfil(_response.value);
  }

  Future<void> eliminarcatalogo(Map<String, dynamic> catalogo) async {
    _response.value = await Peticiones.eliminarcatalogo(catalogo);
    await controlPerfil(_response.value);
  }

  Future<Map<String, dynamic>> obtenercatalogo(String id) async {
    print("llego al controlador");
    _response.value = await Peticiones.obtenercatalogo(id);
    await controlPerfil(_response.value);
    print("resultado de la peticion:");
    print(_response.value);
    return _response.value;
  }

  Future<void> controlPerfil(dynamic respuesta) async {
    if (respuesta == null) {
      _mensaje.value = "Por favor intente de nuevo";
      print(_mensaje.value);
    } else if (respuesta == "1" || respuesta == "2") {
      _mensaje.value = "Por favor intente de nuevo";
      print(_mensaje.value);
    } else {
      _mensaje.value = "Proceso exitoso";
      if (respuesta is UserCredential) {
        _perfil.value = respuesta;
      } else {
        _Datos.value = respuesta;
        print(_Datos.value);
      }
    }
  }

  List<Map<String, dynamic>> get datosPerfil => _Datos.value;
  dynamic get estadoPerfil => _response.value;
  String get mensajesPerfil => _mensaje.value;
  UserCredential? get perfilValido => _perfil.value;
}
