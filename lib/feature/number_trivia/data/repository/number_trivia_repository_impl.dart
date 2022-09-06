import 'package:clean_architecture_tutorial/feature/number_trivia/data/datasource/number_trivia_local_datasource.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/data/datasource/number_trivia_remote_datasource.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/data/model/number_trivia_model.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/entity/number_trivia.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:clean_architecture_tutorial/library/error/exception.dart';
import 'package:clean_architecture_tutorial/library/platform/network_info.dart';
import 'package:dartz/dartz.dart';
import '../../../../library/error/failure.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {

  final NumberTriviaRemoteDatasource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) {
    // TODO: implement getConcreteNumberTrivia
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }
}
