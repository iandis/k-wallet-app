import 'dart:async' show FutureOr;

abstract class Action<INPUT, OUTPUT> {
  const Action();

  FutureOr<OUTPUT> call(INPUT input);
}
