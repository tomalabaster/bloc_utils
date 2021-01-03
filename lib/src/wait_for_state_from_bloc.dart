import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'bloc_closed_without_yielding_state_exception.dart';

Future<T> waitForStateFromBloc<T>({
  @required Bloc bloc,
}) {
  final completer = Completer<T>();

  if (bloc.state is T) {
    completer.complete(bloc.state);

    return completer.future;
  }

  StreamSubscription blocSubscription;

  blocSubscription = bloc.listen(
    (state) {
      if (state is T) {
        completer.complete(state);

        blocSubscription.cancel();
      }
    },
    onDone: () {
      completer.completeError(BlocClosedWithoutYieldingStateException());

      blocSubscription.cancel();
    },
    cancelOnError: true,
  );

  return completer.future;
}
