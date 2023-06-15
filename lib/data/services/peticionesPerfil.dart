import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:netduino_upc_app/domain/controller/controllerUserFirebase.dart';
import 'package:get/get.dart';

class Peticiones {
  static final fs.FirebaseStorage storage = fs.FirebaseStorage.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final ControlUserAuth controlua = Get.find();

  static Future<dynamic> crearcatalogo(
      Map<String, dynamic> catalogo, foto) async {
    print("llego a crear la peticion");
    try {
      var url = '';
      if (foto != null) {
        url =
            await Peticiones.cargarfoto(foto, controlua.userValido!.user!.uid);
      }
      print(url);
      catalogo['foto'] = url.toString();
      await _db.collection('perfil').doc().set(catalogo).catchError((e) {
        print("Guardo el catalogo");
        print(e);
        throw e; // Lanzar la excepción para que sea capturada en el controlador
      });
      return true;
    } catch (error) {
      print('Error en la operación de creación de catálogo: $error');
      throw error; // Lanzar la excepción para que sea capturada en el controlador
    }
    // print(catalogo['foto']);

    // var url = '';
    // if (foto != null) {
    //   url = await Peticiones.cargarfoto(
    //       foto, catalogo['nombre'] + catalogo['apellido']);
    // }
    // print(url);
    // catalogo['foto'] = url.toString();
    // await _db.collection('perfil').doc().set(catalogo).catchError((e) {
    //   print(e);
    // });
    // return true;
  }

  static Future<dynamic> actualizarcatalogo(
      Map<String, dynamic> catalogo, foto) async {
    print(catalogo['foto']);

    var url = '';
    if (foto != null) {
      url = await Peticiones.cargarfoto(
          foto, catalogo['nombre'] + catalogo['apellido']);
    }
    print(url);
    catalogo['foto'] = url.toString();
    await _db.collection('perfil').doc().update(catalogo).catchError((e) {
      print(e);
    });
    return true;
  }

  static Future<dynamic> eliminarcatalogo(Map<String, dynamic> catalogo) async {
    await _db.collection('perfil').doc().delete().catchError((e) {
      print(e);
    });
    return true;
  }

  static Future<Map<String, dynamic>> obtenercatalogo(id) async {
    print("Hizo la peticion: $id");
    Map<String, dynamic> datos = {};
    final perfilSnapshot = await FirebaseFirestore.instance
        .collection('perfil')
        .where('id', isEqualTo: id)
        .get();
    //Comprueba si el documento existe
    if (perfilSnapshot.docs.isNotEmpty) {
      print("el documento existe");
      perfilSnapshot.docs.forEach((doc) {
        datos = doc.data();
      });
    } else {
      print("el documento no existe");
      datos = {};
    }
    print("Hizo la peticion: $datos");
    return datos;
  }

  static Future<dynamic> cargarfoto(var foto, var idArt) async {
    try {
      final fs.Reference storageReference =
          fs.FirebaseStorage.instance.ref().child("fotos");
      fs.TaskSnapshot taskSnapshot =
          await storageReference.child(idArt).putFile(foto);
      var url = await taskSnapshot.ref.getDownloadURL();
      print('url:' + url.toString());
      return url.toString();
    } catch (error) {
      print('Error en la operación de carga de foto: $error');
      throw error; // Lanzar la excepción para que sea capturada en el controlador
    }
    // final fs.Reference storageReference =
    //     fs.FirebaseStorage.instance.ref().child("Perfil");

    // fs.TaskSnapshot taskSnapshot =
    //     await storageReference.child(idArt).putFile(foto);

    // var url = await taskSnapshot.ref.getDownloadURL();
    // print('url:' + url.toString());
    // return url.toString();
  }
}
