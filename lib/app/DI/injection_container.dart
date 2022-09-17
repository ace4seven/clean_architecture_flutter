import 'package:clean_architecture_tutorial/feature/number_trivia/data/dataSource/NumberTriviaLocalDataSource.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/data/repository/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/datasource/number_trivia_local_datasource.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/datasource/number_trivia_remote_datasource.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/usecase/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/usecase/get_random_number_trivia.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_architecture_tutorial/library/network/network_info.dart';
import 'package:clean_architecture_tutorial/library/util/input_converter.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  /// Bloc
  sl.registerFactory<NumberTriviaBloc>(() => NumberTriviaBloc(
        getConcreteNumberTrivia: sl(),
        getRandomNumberTrivia: sl(),
        inputConverter: sl(),
      ));

  /// Use Case
  sl.registerLazySingleton<GetConcreteNumberTrivia>(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton<GetRandomNumberTrivia>(() => GetRandomNumberTrivia(sl()));

  /// Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  /// Data Sources
  sl.registerLazySingleton<NumberTriviaRemoteDatasource>(
      () => NumberTriviaRemoteDatasourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sl()));

  // Core
  sl.registerLazySingleton<InputConverter>(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(dataConnectionChecker: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<DataConnectionChecker>(() => DataConnectionChecker.new());
}
