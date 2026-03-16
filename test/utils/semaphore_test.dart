import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:forsaken/utils/semaphore.dart';

void main() {
  group('Semaphore - basic acquire/release', () {
    test('can acquire when count > 0', () async {
      final sem = Semaphore(1);
      await expectLater(sem.acquire(), completes);
    });

    test('release increments count when no waiters', () async {
      final sem = Semaphore(1);
      await sem.acquire();
      sem.release();
      // Should be acquirable again.
      await expectLater(sem.acquire(), completes);
    });

    test('acquire blocks when count is 0', () async {
      final sem = Semaphore(1);
      await sem.acquire(); // count → 0

      var secondAcquired = false;
      final future = sem.acquire().then((_) => secondAcquired = true);

      // Not yet acquired.
      expect(secondAcquired, isFalse);

      sem.release(); // unblocks the waiter
      await future;
      expect(secondAcquired, isTrue);
    });

    test('multiple waiters are served in FIFO order', () async {
      final sem = Semaphore(1);
      await sem.acquire(); // hold the semaphore

      final order = <int>[];
      final futures = <Future<void>>[];

      for (var i = 0; i < 3; i++) {
        final idx = i;
        futures.add(sem.acquire().then((_) {
          order.add(idx);
          sem.release();
        }));
      }

      sem.release(); // release initial hold
      await Future.wait(futures);

      expect(order, equals([0, 1, 2]));
    });
  });

  group('Semaphore - concurrency limit', () {
    test('limits concurrent operations to maxCount', () async {
      const maxCount = 3;
      final sem = Semaphore(maxCount);
      var concurrent = 0;
      var maxConcurrent = 0;

      final futures = List.generate(10, (_) async {
        await sem.acquire();
        concurrent++;
        if (concurrent > maxConcurrent) maxConcurrent = concurrent;
        // Simulate work.
        await Future.delayed(Duration.zero);
        concurrent--;
        sem.release();
      });

      await Future.wait(futures);
      expect(maxConcurrent, lessThanOrEqualTo(maxCount));
    });

    test('semaphore with maxCount=1 acts as mutex', () async {
      final sem = Semaphore(1);
      var inCritical = false;
      var violated = false;

      final futures = List.generate(5, (_) async {
        await sem.acquire();
        if (inCritical) violated = true;
        inCritical = true;
        await Future.delayed(Duration.zero);
        inCritical = false;
        sem.release();
      });

      await Future.wait(futures);
      expect(violated, isFalse);
    });
  });

  // Property 19: Semaphore Limits Concurrent Operations
  // Validates: Requisitos 9.1
  group('Property 19 - Semaphore concurrency invariant', () {
    test('concurrent count never exceeds maxCount for various limits', () async {
      for (final limit in [1, 2, 5]) {
        final sem = Semaphore(limit);
        var concurrent = 0;
        var violated = false;

        final futures = List.generate(20, (_) async {
          await sem.acquire();
          concurrent++;
          if (concurrent > limit) violated = true;
          await Future.delayed(Duration.zero);
          concurrent--;
          sem.release();
        });

        await Future.wait(futures);
        expect(violated, isFalse, reason: 'limit=$limit violated');
      }
    });
  });

  // Property 20: Ordered Async Operations Complete In Order
  // Validates: Requisitos 9.2
  group('Property 20 - FIFO ordering', () {
    test('waiters are released in the order they queued', () async {
      final sem = Semaphore(1);
      await sem.acquire(); // hold

      final released = <int>[];
      final futures = <Future<void>>[];

      for (var i = 0; i < 5; i++) {
        final idx = i;
        futures.add(sem.acquire().then((_) {
          released.add(idx);
          sem.release();
        }));
      }

      sem.release();
      await Future.wait(futures);

      expect(released, equals([0, 1, 2, 3, 4]));
    });
  });

  // Property 21: Async Timeout Triggers Error
  // Validates: Requisitos 9.3
  group('Property 21 - Timeout behavior', () {
    test('acquire times out when semaphore is held and timeout is short',
        () async {
      final sem = Semaphore(1);
      await sem.acquire(); // hold indefinitely

      expect(
        () => sem.acquire().timeout(const Duration(milliseconds: 10)),
        throwsA(isA<TimeoutException>()),
      );
    });
  });
}
