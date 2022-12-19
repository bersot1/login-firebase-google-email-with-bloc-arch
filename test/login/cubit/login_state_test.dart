import 'package:flutter_firebase_login/login/cubit/login_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

void main() {
  const email = Email.dirty('email');
  const password = Password.dirty('password');

  group('LoginState', () {
    test('supports value comparions', () {
      expect(LoginState(), LoginState());
    });

    <LoginState, LoginState>{
      LoginState().copyWith(): LoginState(),
      LoginState().copyWith(status: FormzStatus.pure): LoginState(),
      LoginState().copyWith(email: email): LoginState(email: email),
      LoginState().copyWith(password: password): LoginState(password: password),
    }.forEach((actual, matcher) {
      test('returns object according to the copyWith params $actual to $matcher', () {
        expect(actual, matcher);
      });
    });
  });
}
