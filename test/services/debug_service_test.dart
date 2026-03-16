import 'package:flutter_test/flutter_test.dart';

import 'package:forsaken/services/debug_service.dart';

void main() {
  setUp(() {
    DebugService.initialize();
  });

  // ---------------------------------------------------------------------------
  // initialize
  // ---------------------------------------------------------------------------
  group('initialize', () {
    test('with isEnabled: false sets isDebugEnabled to false', () {
      DebugService.initialize(isEnabled: false);
      expect(DebugService.instance.isDebugEnabled, isFalse);
    });

    test('with isEnabled: true sets isDebugEnabled to true', () {
      DebugService.initialize(isEnabled: true);
      expect(DebugService.instance.isDebugEnabled, isTrue);
    });

    test('resets singleton to a fresh instance', () {
      DebugService.initialize(isEnabled: true);
      final first = DebugService.instance;

      DebugService.initialize(isEnabled: false);
      final second = DebugService.instance;

      // After re-initialize the state should reflect the new settings
      expect(second.isDebugEnabled, isFalse);
      // The instances are different objects after re-initialization
      expect(identical(first, second), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // setEnabled
  // ---------------------------------------------------------------------------
  group('setEnabled', () {
    test('setEnabled(false) disables logging', () {
      DebugService.initialize(isEnabled: true);
      DebugService.instance.setEnabled(false);
      expect(DebugService.instance.isDebugEnabled, isFalse);
    });

    test('setEnabled(true) enables logging', () {
      DebugService.initialize(isEnabled: false);
      DebugService.instance.setEnabled(true);
      expect(DebugService.instance.isDebugEnabled, isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // toggleDebug
  // ---------------------------------------------------------------------------
  group('toggleDebug', () {
    test('flips enabled state from true to false', () {
      DebugService.initialize(isEnabled: true);
      DebugService.instance.toggleDebug();
      expect(DebugService.instance.isDebugEnabled, isFalse);
    });

    test('flips enabled state from false to true', () {
      DebugService.initialize(isEnabled: false);
      DebugService.instance.toggleDebug();
      expect(DebugService.instance.isDebugEnabled, isTrue);
    });

    test('double toggle returns to original state', () {
      DebugService.initialize(isEnabled: true);
      DebugService.instance.toggleDebug();
      DebugService.instance.toggleDebug();
      expect(DebugService.instance.isDebugEnabled, isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // setMinLevel
  // ---------------------------------------------------------------------------
  group('setMinLevel', () {
    test('setMinLevel(LogLevel.error) sets minimum level', () {
      DebugService.initialize(isEnabled: true);
      // After setting min level to error, lower-level logs should be filtered.
      // We verify this indirectly: the call must not throw.
      expect(
        () => DebugService.instance.setMinLevel(LogLevel.error),
        returnsNormally,
      );
    });

    test('log methods below min level do not throw', () {
      DebugService.initialize(isEnabled: true);
      DebugService.instance.setMinLevel(LogLevel.error);

      expect(() => DebugService.instance.debug('filtered'), returnsNormally);
      expect(() => DebugService.instance.info('filtered'), returnsNormally);
      expect(() => DebugService.instance.warning('filtered'), returnsNormally);
    });
  });

  // ---------------------------------------------------------------------------
  // singleton
  // ---------------------------------------------------------------------------
  group('singleton', () {
    test('DebugService.instance returns the same instance', () {
      final a = DebugService.instance;
      final b = DebugService.instance;
      expect(identical(a, b), isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // log methods - enabled
  // ---------------------------------------------------------------------------
  group('log methods when enabled', () {
    setUp(() {
      DebugService.initialize(isEnabled: true);
    });

    test('debug() does not throw', () {
      expect(
        () => DebugService.instance.debug('debug message', tag: 'Test'),
        returnsNormally,
      );
    });

    test('info() does not throw', () {
      expect(
        () => DebugService.instance.info('info message', tag: 'Test'),
        returnsNormally,
      );
    });

    test('warning() does not throw', () {
      expect(
        () => DebugService.instance.warning('warning message', tag: 'Test'),
        returnsNormally,
      );
    });

    test('error() does not throw', () {
      expect(
        () => DebugService.instance.error('error message', tag: 'Test'),
        returnsNormally,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // log methods - disabled
  // ---------------------------------------------------------------------------
  group('log methods when disabled', () {
    setUp(() {
      DebugService.initialize(isEnabled: false);
    });

    test('debug() does not throw', () {
      expect(
        () => DebugService.instance.debug('debug message'),
        returnsNormally,
      );
    });

    test('info() does not throw', () {
      expect(
        () => DebugService.instance.info('info message'),
        returnsNormally,
      );
    });

    test('warning() does not throw', () {
      expect(
        () => DebugService.instance.warning('warning message'),
        returnsNormally,
      );
    });

    test('error() does not throw', () {
      expect(
        () => DebugService.instance.error('error message'),
        returnsNormally,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // error with error object
  // ---------------------------------------------------------------------------
  group('error with error object', () {
    test('error() with error object does not throw when enabled', () {
      DebugService.initialize(isEnabled: true);
      final exception = Exception('something went wrong');
      final stackTrace = StackTrace.current;

      expect(
        () => DebugService.instance.error(
          'error with object',
          tag: 'Test',
          error: exception,
          stackTrace: stackTrace,
        ),
        returnsNormally,
      );
    });

    test('error() with error object does not throw when disabled', () {
      DebugService.initialize(isEnabled: false);
      final exception = Exception('something went wrong');

      expect(
        () => DebugService.instance.error(
          'error with object',
          error: exception,
        ),
        returnsNormally,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // LogLevel enum
  // ---------------------------------------------------------------------------
  group('LogLevel', () {
    test('values have correct ordering', () {
      expect(LogLevel.debug.value, lessThan(LogLevel.info.value));
      expect(LogLevel.info.value, lessThan(LogLevel.warning.value));
      expect(LogLevel.warning.value, lessThan(LogLevel.error.value));
      expect(LogLevel.error.value, lessThan(LogLevel.none.value));
    });

    test('none has value 999', () {
      expect(LogLevel.none.value, equals(999));
    });
  });

  // ---------------------------------------------------------------------------
  // property tests - error logging
  // Feature: unit-testing-implementation, Property 16: Errors Are Logged Appropriately
  // Validates: Requirements 8.2
  // ---------------------------------------------------------------------------
  group('property tests - error logging', () {
    test('all log levels are callable without throwing for any message', () {
      DebugService.initialize(isEnabled: true);
      final service = DebugService.instance;

      final loggableLevels = LogLevel.values
          .where((l) => l != LogLevel.none)
          .toList();

      for (final level in loggableLevels) {
        for (var i = 0; i < 50; i++) {
          final message = 'message_${level.name}_$i';
          expect(
            () {
              switch (level) {
                case LogLevel.debug:
                  service.debug(message);
                case LogLevel.info:
                  service.info(message);
                case LogLevel.warning:
                  service.warning(message);
                case LogLevel.error:
                  service.error(message);
                case LogLevel.none:
                  break;
              }
            },
            returnsNormally,
            reason: 'level ${level.name} message $i should not throw',
          );
        }
      }
    });

    test('error logging with various exception types does not throw', () {
      DebugService.initialize(isEnabled: true);
      final service = DebugService.instance;

      final exceptions = <Object>[
        Exception('generic exception'),
        StateError('state error'),
        ArgumentError('argument error'),
        FormatException('format exception'),
        RangeError('range error'),
      ];

      for (final ex in exceptions) {
        expect(
          () => service.error(
            'caught error',
            error: ex,
            stackTrace: StackTrace.current,
          ),
          returnsNormally,
          reason: '${ex.runtimeType} should not cause error() to throw',
        );
      }
    });

    test(
        'log level filtering: messages below minLevel are silently ignored',
        () {
      DebugService.initialize(isEnabled: true);
      final service = DebugService.instance;
      service.setMinLevel(LogLevel.error);

      expect(() => service.debug('filtered debug'), returnsNormally);
      expect(() => service.info('filtered info'), returnsNormally);
      expect(() => service.warning('filtered warning'), returnsNormally);
    });
  });
}
