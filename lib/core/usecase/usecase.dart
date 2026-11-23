import 'package:equatable/equatable.dart';

/// Base UseCase contract following Clean Architecture principles.
abstract class UseCase<T, Params> {
  Future<T> call(Params params);
}

/// Helper class to represent use cases that take no parameters.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
