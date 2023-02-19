part of 'cubit_bloc.dart';

abstract class CubitState extends Equatable {
  const CubitState();
  
  @override
  List<Object> get props => [];
}

class CubitInitial extends CubitState {}


class CubitNavigatorState extends CubitState {
  final String route;
  const CubitNavigatorState({required this.route});
}

class CubitLoginToastState extends CubitState {}

class CubitRegisterToastState extends CubitState {}

class CubitRecoveryPasswordState extends CubitState {}


class CubitErrorState extends CubitState {
  final String warning;
  const CubitErrorState({required this.warning});
}
