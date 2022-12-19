import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_firebase_login/app/bloc/app_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements UserModel {}

void main() {
  group('AppState', () {
    group('unauthenticated', () {
      test('has cirrect status', () {
        final state = AppState.unauthenticated();
        expect(state.status, AppStatus.unauthenticated);
        expect(state.user, UserModel.empty);
      });
    });

    group('authenticated', () {
      test('has cirrect status', () {
        final user = MockUser();
        final state = AppState.authenticated(user);
        expect(state.status, AppStatus.authenticated);
        expect(state.user, user);
      });
    });
  });
}
