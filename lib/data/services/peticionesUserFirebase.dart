import 'package:firebase_auth/firebase_auth.dart';

class Peticioneslogin {
  static final FirebaseAuth auth = FirebaseAuth.instance;

//Registro Usando Correo Electronico y Contraseña
  static Future<dynamic> crearRegistroEmail(dynamic email, dynamic pass) async {
    try {
      UserCredential usuario = await auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      print("Usuario Creado");
      return usuario;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        String ErrorPass = 'Contraseña Debil';
        return ErrorPass;
      } else if (e.code == 'email-already-in-use') {
        String ErrorEmail = 'Correo ya Existe';
        return ErrorEmail;
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> consultarUsuario() async {
    try {
      User? usuario = auth.currentUser;
      return usuario;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> ingresarEmail(dynamic email, dynamic pass) async {
    try {
      UserCredential usuario =
          await auth.signInWithEmailAndPassword(email: email, password: pass);
      print(usuario.user!.uid);
      return usuario;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Correo no encontrado');
        return '1';
      } else if (e.code == 'wrong-password') {
        print('Password incorrecto');
        return '2';
      }
      return null;
    }
  }

  static Future<dynamic> recuperarContrasena(dynamic email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return "Correo Enviado";
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> abandonarSesion() async {
    try {
      await auth.signOut();
      return "Sesion Cerrada";
    } catch (e) {
      print(e);
    }
  }
}
