import 'dart:convert';

import 'package:clean_architecture_tutorial/feature/number_trivia/data/model/number_trivia_model.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/datasource/number_trivia_local_datasource.dart';
import 'package:clean_architecture_tutorial/library/error/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

const CACHED_NUMBER_TRIVIA = "CACHED_NUMBER_TRIVIA";

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {

  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPreferences.setString(CACHED_NUMBER_TRIVIA, json.encode(triviaToCache.toJson()));
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);

    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    }

    throw CacheException();
  }
}