import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_datasource.dart';
import '../models/payment_model.dart';

/// Implementation of PaymentRepository
class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PaymentRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ESewaPaymentData>> initializeESewaPayment({
    required String plan,
    required double amount,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.initializeESewaPayment(
          plan: plan,
          amount: amount,
        );
        final paymentData = ESewaPaymentDataModel.fromJson(result);
        return Right(paymentData);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPaymentHistory({
    int page = 1,
    int limit = 10,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getPaymentHistory(
          page: page,
          limit: limit,
        );
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<SubscriptionPlan>>> getSubscriptionPlans() async {
    try {
      final result = await remoteDataSource.getSubscriptionPlans();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelSubscription() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.cancelSubscription();
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
