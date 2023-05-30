import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

//Evento -> Inicializar el proceso de autenticación y determinar el estado inicial del usuario.
class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

//Evento -> Verificacion Email
class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

//Evento -> Iniciar sesion
class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogIn(this.email, this.password);
}

//Evento -> Registrarse
class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  const AuthEventRegister(this.email, this.password);
}

//Evento -> Verificación de registro valido
class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
} 

//Evento -> Olvidar contraseña
class AuthEventForgotPassword extends AuthEvent {
  final String? email;
  const AuthEventForgotPassword({this.email});
}

//Evento -> Cerrar sesión
class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}