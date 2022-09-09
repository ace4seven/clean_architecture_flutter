import 'dart:convert';

import 'package:clean_architecture_tutorial/feature/number_trivia/data/model/number_trivia_model.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/datasource/number_trivia_remote_datasource.dart';
import 'package:clean_architecture_tutorial/library/error/exception.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
void main() {
  late MockClient mockHttpClient;
  late NumberTriviaRemoteDatasourceImpl dataSource;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = NumberTriviaRemoteDatasourceImpl(client: mockHttpClient);
  });

  void setupMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setupMockHttpClientFails() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response("Something went wrong", 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTiviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('should perform a GET request on a URL with number being the endpoint and with application/json header', () async {
      // arange
      setupMockHttpClientSuccess200();
      // act
      dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      final uri = Uri.http('numbersapi.com', '$tNumber');
      verifyNever(mockHttpClient.get(uri, headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response code is 200 success', () async {
      // arange
      setupMockHttpClientSuccess200();
      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      expect(result, equals(tNumberTiviaModel));
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      // arange
      setupMockHttpClientFails();
      // act
      final call = dataSource.getConcreteNumberTrivia;
      // assert
      expect(() => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTiviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('should perform a GET request on a URL with number being the endpoint and with application/json header', () async {
      // arange
      setupMockHttpClientSuccess200();
      // act
      dataSource.getRandomNumberTrivia();
      // assert
      final uri = Uri.http('numbersapi.com', 'random');
      verifyNever(mockHttpClient.get(uri, headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response code is 200 success', () async {
      // arange
      setupMockHttpClientSuccess200();
      // act
      final result = await dataSource.getRandomNumberTrivia();
      // assert
      expect(result, equals(tNumberTiviaModel));
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      // arange
      setupMockHttpClientFails();
      // act
      final call = dataSource.getRandomNumberTrivia;
      // assert
      expect(call, throwsA(const TypeMatcher<ServerException>()));
    });
  });
}