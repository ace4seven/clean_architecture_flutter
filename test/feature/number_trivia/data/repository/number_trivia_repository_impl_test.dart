import 'package:clean_architecture_tutorial/feature/number_trivia/data/repository/number_trivia_repository_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/datasource/number_trivia_local_datasource.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/datasource/number_trivia_remote_datasource.dart';
import 'package:clean_architecture_tutorial/library/platform/network_info.dart';
import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks([NumberTriviaRemoteDatasource])
@GenerateMocks([NumberTriviaLocalDataSource])
@GenerateMocks([NetworkInfo])
void main() {
  NumberTriviaRepositoryImpl repository;
  MockNumberTriviaRemoteDatasource mockRemoteDataSource;
  MockNumberTriviaLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDatasource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });
}
