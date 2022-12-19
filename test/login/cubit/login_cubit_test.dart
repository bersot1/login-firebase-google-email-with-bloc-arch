import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_firebase_login/login/cubit/login_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

void main() {
  const invlaidEmailString = 'invalid';
  const invalidEmail = Email.dirty(invlaidEmailString);

  const validEmailString = 'test@gmail.com';
  const validEmail = Email.dirty(validEmailString);

  const invalidPasswordString = 'invalid';
  const invalidPassword = Password.dirty(invalidPasswordString);

  const validPasswordString = 't0S3cret134';
  const validPassword = Password.dirty(validPasswordString);

  group('LoginCubit', () {
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();

      when(() => authenticationRepository.logInWithGoogle()).thenAnswer((_) async => {});
      when(() => authenticationRepository.logInWithEmailAndPassword(
          email: any(named: 'email'), password: any(named: 'password'))).thenAnswer((_) async => {});
    });

    test('initial state is LoginState', () {
      expect(LoginCubit(authenticationRepository).state, LoginState());
    });

    group('emailChanged', () {
      blocTest<LoginCubit, LoginState>(
        'emits [invalid] when email/password are invalid',
        build: () => LoginCubit(authenticationRepository),
        act: (cubit) => cubit.emailChanged(invlaidEmailString),
        expect: () => <LoginState>[
          LoginState(email: invalidEmail, status: FormzStatus.invalid),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [valid] when email/password are valid.',
        build: () => LoginCubit(authenticationRepository),
        seed: () => LoginState(password: validPassword),
        act: (cubit) => cubit.emailChanged(validEmailString),
        expect: () => <LoginState>[LoginState(email: validEmail, password: validPassword, status: FormzStatus.valid)],
      );
    });

    group('passwordChanged', () {
      blocTest<LoginCubit, LoginState>(
        'emits [invalid] when email/password are invalid.',
        build: () => LoginCubit(authenticationRepository),
        act: (cubit) => cubit.passwordChanged(invalidPasswordString),
        expect: () => <LoginState>[
          LoginState(
            password: invalidPassword,
            status: FormzStatus.invalid,
          )
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [valid] when email/password are valid.',
        build: () => LoginCubit(authenticationRepository),
        seed: () => LoginState(email: validEmail),
        act: (cubit) => cubit.passwordChanged(validPasswordString),
        expect: () => <LoginState>[
          LoginState(
            email: validEmail,
            password: validPassword,
            status: FormzStatus.valid,
          )
        ],
      );
    });

    group('logInWithCredentials', () {
      blocTest<LoginCubit, LoginState>(
        'does nothing when status is not validated',
        build: () => LoginCubit(authenticationRepository),
        act: (cubit) => cubit.logInWithCredentials(),
        expect: () => const <LoginState>[],
      );

      blocTest<LoginCubit, LoginState>(
        'calls logInWithEmailAndPassword with correct email/password',
        build: () => LoginCubit(authenticationRepository),
        seed: () => LoginState(status: FormzStatus.valid, email: validEmail, password: validPassword),
        act: (cubit) => cubit.logInWithCredentials(),
        verify: (_) {
          verify(
            () => authenticationRepository.logInWithEmailAndPassword(
                email: validEmailString, password: validPasswordString),
          );
        },
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when logInWithEmailAndPassword succeeds',
        build: () => LoginCubit(authenticationRepository),
        seed: () => LoginState(
          status: FormzStatus.valid,
          email: validEmail,
          password: validPassword,
        ),
        act: (cubit) => cubit.logInWithCredentials(),
        expect: () => <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress, email: validEmail, password: validPassword),
          LoginState(status: FormzStatus.submissionSuccess, email: validEmail, password: validPassword)
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logInWithEmailAndPassword fails due to LoginWIthEmailAndPasswordFailure',
        setUp: () {
          when(() => authenticationRepository.logInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'))).thenThrow(LogInWithEmailAndPasswordFailure('oops'));
        },
        build: () => LoginCubit(authenticationRepository),
        seed: () => LoginState(
          status: FormzStatus.valid,
          email: validEmail,
          password: validPassword,
        ),
        act: (cubit) => cubit.logInWithCredentials(),
        expect: () => <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress, email: validEmail, password: validPassword),
          LoginState(
            status: FormzStatus.submissionFailure,
            email: validEmail,
            password: validPassword,
            errorMessage: 'oops',
          )
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logInWithEmailAndPassword fails due to generic exception',
        setUp: () {
          when(() => authenticationRepository.logInWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password'))).thenThrow(Exception('oops'));
        },
        build: () => LoginCubit(authenticationRepository),
        seed: () => LoginState(
          status: FormzStatus.valid,
          email: validEmail,
          password: validPassword,
        ),
        act: (cubit) => cubit.logInWithCredentials(),
        expect: () => <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress, email: validEmail, password: validPassword),
          LoginState(status: FormzStatus.submissionFailure, email: validEmail, password: validPassword)
        ],
      );
    });

    group('LogInWithGoogle', () {
      blocTest<LoginCubit, LoginState>(
        'calls logInWithGoogle',
        build: () => LoginCubit(authenticationRepository),
        act: (cubit) => cubit.logInWithGoogle(),
        verify: (_) {
          verify(() => authenticationRepository.logInWithGoogle()).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when logInWithGoogle succeeds',
        build: () => LoginCubit(authenticationRepository),
        act: (cubit) => cubit.logInWithGoogle(),
        expect: () => <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress),
          LoginState(status: FormzStatus.submissionSuccess)
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logInWithGoogle fails due to LoginWithGoogleFailure',
        setUp: () {
          when(() => authenticationRepository.logInWithGoogle()).thenThrow(LogInWithGoogleFailure('oops'));
        },
        build: () => LoginCubit(authenticationRepository),
        act: (cubit) => cubit.logInWithGoogle(),
        expect: () => <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress),
          LoginState(status: FormzStatus.submissionFailure, errorMessage: 'oops')
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logInWithGoogle fails due to generic exception',
        setUp: () {
          when(
            () => authenticationRepository.logInWithGoogle(),
          ).thenThrow(Exception('oops'));
        },
        build: () => LoginCubit(authenticationRepository),
        act: (cubit) => cubit.logInWithGoogle(),
        expect: () => <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress),
          LoginState(status: FormzStatus.submissionFailure)
        ],
      );
    });
  });
}
