@Timeout(Duration(milliseconds: 500))
library;

import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late AccountScreenController controller;
  setUp(() {
    authRepository = MockAuthRepository();
    controller = AccountScreenController(authRepository: authRepository);
  });
  group(
    'AccountScreenController',
    () {
      test('initial state is AsyncValue.data', () {
        // Assert
        verifyNever(authRepository.signOut);
        expect(controller.state, const AsyncData<void>(null));
      });

      test(
        'signOut success',
        () async {
          // Arrange
          when(authRepository.signOut).thenAnswer(
            (_) => Future.value(),
          );

          // Assert later
          expectLater(
            controller.stream,
            emitsInOrder([
              const AsyncLoading<void>(),
              const AsyncData<void>(null),
            ]),
          );

          // Act
          await controller.signOut();

          // Assert
          verify(authRepository.signOut).called(1);
          // expect(controller.state, const AsyncData<void>(null));
        },
      );

      test(
        'signOut failure',
        () async {
          // Arrange
          final exception = Exception('Connection failed');
          when(authRepository.signOut).thenThrow(exception);

          // Assert later
          expectLater(
            controller.stream,
            emitsInOrder([
              const AsyncLoading<void>(),
              predicate<AsyncValue<void>>((value) {
                expect(value.hasError, true);
                return true;
              }),
            ]),
          );

          // Act
          await controller.signOut();

          // Assert
          verify(authRepository.signOut).called(1);
          // expect(controller.state.hasError, true);
          // expect(controller.state, isA<AsyncError>());
        },
      );
    },
  );
}
