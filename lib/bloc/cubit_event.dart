part of 'cubit_bloc.dart';

abstract class CubitEvent extends Equatable {
  const CubitEvent();

  @override
  List<Object> get props => [];
}

class CubitLoginEvent extends CubitEvent {
  final String login;
  final String password;
  const CubitLoginEvent({required this.login, required this.password});
}

class CubitRegisterEvent extends CubitEvent {
  final String login;
  final String password;
  final String name;
  const CubitRegisterEvent({required this.login, required this.password, required this.name});
}

class CubitLoginWithGoogleEvent extends CubitEvent {}

class CubitForgotPasswordEvent extends CubitEvent {
  final String login;
  const CubitForgotPasswordEvent({required this.login});
}
