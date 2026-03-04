import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../errors/failures.dart';

/// Base UseCase class for all use cases
/// [Type] is the return type of the use case
/// [Params] is the parameters required by the use case
abstract class UseCase<Type, Params> {
  /// Execute the use case
  Future<Either<Failure, Type>> call(Params params);
}

/// Use this when the use case doesn't require any parameters
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}

/// Base class for pagination parameters
class PaginationParams extends Equatable {
  final int page;
  final int limit;
  final String? search;

  const PaginationParams({
    this.page = 1,
    this.limit = 10,
    this.search,
  });

  @override
  List<Object?> get props => [page, limit, search];

  Map<String, dynamic> toQueryParams() {
    return {
      'page': page.toString(),
      'limit': limit.toString(),
      if (search != null && search!.isNotEmpty) 'search': search,
    };
  }
}

/// Stream use case for real-time data
abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}
