import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marvel_animation_app/features/auth/data/datasources/firebase_auth_datasource.dart';

import '../../../../core/entities/entity_either.dart';
import '../../../../core/network/error/failures.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

final Provider<AuthRepositoryImpl> authRepositoryProvider =
    Provider<AuthRepositoryImpl>((Ref<AuthRepositoryImpl> ref) {
  return AuthRepositoryImpl(
      dataSource: ref.read(firebaseAuthDataSourceProvider));
});

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.dataSource});

  final FirebaseAuthDataSource dataSource;

  @override
  Future<Either<Failure, UserModel>> logIn(UserModel params) async {
    final user = await dataSource.logIn(params.email, params.password ?? '');

    return user.when((Failure left) async {
      return Left<Failure, UserModel>(left);
    }, (UserModel right) async {
      return Right<Failure, UserModel>(right);
    });
  }

  @override
  Future<Either<Failure, UserModel>> signUp(
      UserModel params) async {
    final user = await dataSource.signUp(params);
    return user.when((Failure left) async {
      return Left<Failure, UserModel>(left);
    }, (UserModel right) async {
      return Right<Failure, UserModel>(right);
    });
  }

  @override
  Future<Either<Failure, void>> logOut() async {
    try {
      await dataSource.logOut();
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    try {
      final user = await dataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString(), 500));
    }
  }
}
