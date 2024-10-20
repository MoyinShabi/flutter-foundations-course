@Timeout(Duration(milliseconds: 500))
library;

import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '1234';
  group(
    'submit',
    () {
      test(
        '''
    Given formType is signIn
    When signInWithEmailAndPassword succeeds
    Then return true
    And state is AsyncData
    ''',
        () async {
          // Arrange
          final authRepository = MockAuthRepository();
          when(
            () => authRepository.signInWithEmailAndPassword(
              testEmail,
              testPassword,
            ),
          ).thenAnswer((_) => Future.value());
          final controller = EmailPasswordSignInController(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.signIn,
          );

          expectLater(
            controller.stream,
            emitsInOrder(
              [
                EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.signIn,
                  value: const AsyncLoading<void>(),
                ),
                EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.signIn,
                  value: const AsyncData<void>(null),
                ),
              ],
            ),
          );

          // Act
          final result = await controller.submit(testEmail, testPassword);

          // Assert
          expect(result, true);
        },
      );

      test(
        '''
        Given formType is signIn
        When signInWithEmailAndPassword fails
        Then return false
        And state is AsyncError
         ''',
        () async {
          // Arrange
          final authRepository = MockAuthRepository();
          final exception = Exception('Connection failed');
          when(
            () => authRepository.signInWithEmailAndPassword(
              testEmail,
              testPassword,
            ),
          ).thenThrow(exception);
          final controller = EmailPasswordSignInController(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.signIn,
          );

          expectLater(
            controller.stream,
            emitsInOrder(
              [
                EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.signIn,
                  value: const AsyncLoading<void>(),
                ),
                predicate<EmailPasswordSignInState>(
                  (state) {
                    expect(state.formType, EmailPasswordSignInFormType.signIn);
                    expect(state.value.hasError, true);
                    return true;
                  },
                )
              ],
            ),
          );

          // Act
          final result = await controller.submit(testEmail, testPassword);

          // Assert
          expect(result, false);
        },
      );
      test(
        '''
    Given formType is register
    When createUserWithEmailAndPassword succeeds
    Then return true
    And state is AsyncData
    ''',
        () async {
          // Arrange
          final authRepository = MockAuthRepository();
          when(
            () => authRepository.createUserWithEmailAndPassword(
              testEmail,
              testPassword,
            ),
          ).thenAnswer((_) => Future.value());
          final controller = EmailPasswordSignInController(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.register,
          );

          expectLater(
            controller.stream,
            emitsInOrder(
              [
                EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.register,
                  value: const AsyncLoading<void>(),
                ),
                EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.register,
                  value: const AsyncData<void>(null),
                ),
              ],
            ),
          );

          // Act
          final result = await controller.submit(testEmail, testPassword);

          // Assert
          expect(result, true);
        },
      );

      test(
        '''
        Given formType is register
    When createUserWithEmailAndPassword fails
    Then return false
    And state is AsyncError
         ''',
        () async {
          // Arrange
          final authRepository = MockAuthRepository();
          final exception = Exception('Connection failed');
          when(
            () => authRepository.signInWithEmailAndPassword(
              testEmail,
              testPassword,
            ),
          ).thenThrow(exception);
          final controller = EmailPasswordSignInController(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.register,
          );

          expectLater(
            controller.stream,
            emitsInOrder(
              [
                EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.register,
                  value: const AsyncLoading<void>(),
                ),
                predicate<EmailPasswordSignInState>(
                  (state) {
                    expect(
                        state.formType, EmailPasswordSignInFormType.register);
                    expect(state.value.hasError, true);
                    return true;
                  },
                )
              ],
            ),
          );

          // Act
          final result = await controller.submit(testEmail, testPassword);

          // Assert
          expect(result, false);
        },
      );
    },
  );

  group('updateFormType', () {
    test('''
    Given formType is signIn
    When called with register
    Then state.formType is register
    ''', () {
      // Arrange
      final authRepository = MockAuthRepository();
      final controller = EmailPasswordSignInController(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.signIn,
      );

      // Act
      controller.updateFormType(EmailPasswordSignInFormType.register);

      // Assert
      expect(
          controller.state,
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.register,
            value: const AsyncData<void>(null),
          ));
    });
    test('''
    Given formType is register
    When called with signIn
    Then state.formType is signIn
    ''', () {
      // Arrange
      final authRepository = MockAuthRepository();
      final controller = EmailPasswordSignInController(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.register,
      );

      // Act
      controller.updateFormType(EmailPasswordSignInFormType.signIn);

      // Assert
      expect(
          controller.state,
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.signIn,
            value: const AsyncData<void>(null),
          ));
    });
  });
}
