import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
/// Using Equatable for value comparison.
abstract class Failure extends Equatable {
  const Failure();
  
  @override
  List<Object?> get props => [];
}

/// Server failure - API returned an error response
class ServerFailure extends Failure {
  final String message;
  
  const ServerFailure(this.message);
  
  @override
  List<Object?> get props => [message];
}

/// Network failure - no internet connection
class NetworkFailure extends Failure {
  const NetworkFailure();
}

/// Cache failure - no cached data available
class CacheFailure extends Failure {
  const CacheFailure();
}
