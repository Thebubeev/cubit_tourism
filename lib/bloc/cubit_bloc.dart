import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_task/firebase_auth/firebase_auth.dart';

part 'cubit_event.dart';
part 'cubit_state.dart';

class CubitBloc extends Bloc<CubitEvent, CubitState> {
  final _firebaseAuth = FirebaseAuth.instance;
  final auth = Auth();
  CubitBloc() : super(CubitInitial()) {
    on<CubitLoginWithGoogleEvent>((event, emit) async {
      try {
        await auth.signInWithGoogle().then((value) {
          if (value.uid != null) {
            emit(const CubitNavigatorState(route: '/home'));
          }
        });
      } catch (e) {
        print(e.toString());
        emit(const CubitErrorState(warning: 'Что-то прошло не так...'));
      }
    });
    on<CubitForgotPasswordEvent>((event, emit) async {
      try {
        await auth.resetPasswordUsingEmail(event.login);
        emit(CubitRecoveryPasswordState());
      } catch (error) {
        String _warning = 'Что-то прошло не так...';
        switch (error.toString()) {
          case "[firebase_auth/invalid-email] The email address is badly formatted.":
            _warning = "Ваша почта недоступна.";
            break;
          case "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.":
            _warning = "Такого пользователя не существует!";
            break;
          case "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.":
            _warning = "Слишком много запросов. Попробуйте позже.";
            break;
          case "[firebase_auth/unknown] Given String is empty or null":
            _warning = '[firebase_auth/unknown] Given String is empty or null';
            break;
        }
        print(error);
        emit(CubitErrorState(warning: _warning));
      }
    });
    on<CubitRegisterEvent>((event, emit) async {
      try {
        await auth.createUserWithEmailAndPassword(
          event.login.trim(),
          event.password.trim(),
          event.name.trim()
        );
        emit(CubitRegisterToastState());
      } catch (error) {
        String _warning = 'Что-то прошло не так...';
        switch (error.toString()) {
          case "[firebase_auth/invalid-email] The email address is badly formatted.":
            _warning = "Ваша почта недоступна.";

            break;
          case "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.":
            _warning = "Слишком много запросов. Попробуйте позже.";

            break;
          case "[firebase_auth/email-already-in-use] The email address is already in use by another account.":
            _warning = "Данная почта уже зарегистрирована.";

            break;
          case "[firebase_auth/unknown] Given String is empty or null":
            _warning = '[firebase_auth/unknown] Given String is empty or null';

            break;
        }
        print(error);
        emit(CubitErrorState(warning: _warning));
      }
    });
    on<CubitLoginEvent>((event, emit) async {
      try {
        await auth
            .signInWithEmailAndPassword(
                event.login.trim(), event.password.trim())
            .then((_) async => _firebaseAuth.currentUser!.emailVerified
                ? emit(const CubitNavigatorState(route: '/home'))
                : {emit(CubitLoginToastState())});
      } catch (error) {
        String _warning = 'Что-то прошло не так...';
        switch (error.toString()) {
          case "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.":
            _warning = "Такого пользователя не существует!";

            break;
          case "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.":
            _warning = "Слишком много запросов. Попробуйте позже!";

            break;
          case "[firebase_auth/invalid-email] The email address is badly formatted.":
            _warning = _firebaseAuth.currentUser!.emailVerified
                ? "Почта недоступна."
                : 'Мы отправили письмо . Пожалуйста, подтвердите вашу почту.';

            _firebaseAuth.currentUser!.emailVerified
                ? null
                : await auth.sendVerificationEmail();
            break;
          case "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.":
            _warning = "Логин или пароль неверный.";

            break;
          case "[firebase_auth/unknown] Given String is empty or null":
            _warning = '[firebase_auth/unknown] Given String is empty or null';
            break;
        }
        print(error);
        emit(CubitErrorState(warning: _warning));
      }
    });
  }
}
