import 'package:formz/formz.dart';

/// Validation errors for [ConfirmedPassword] [FormzInput]
enum ConfirmedPasswordValidationError {
  /// Generic inalid error.
  invalid
}

/// {@template confirmed_password}
/// Form input for a confirmed passwrod input.
/// {@endtemplate}
class ConfirmedPassword extends FormzInput<String, ConfirmedPasswordValidationError> {
  /// {@macro confirmed_password}
  const ConfirmedPassword.pure({this.password = ''}) : super.pure('');

  /// {@macro confirmed_password}
  const ConfirmedPassword.dirty({required this.password, String value = ''}) : super.dirty(value);

  /// the original password
  final String password;

  @override
  ConfirmedPasswordValidationError? validator(String? value) {
    return password == value ? null : ConfirmedPasswordValidationError.invalid;
  }
}
