import 'dart:convert';

import 'package:clean_architecture_tutorial/feature/number_trivia/data/model/number_trivia_model.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/entity/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberModel = NumberTriviaModel(number: 1, text: "Lorem Ipsum");

  test('shold be subclass of NumberTrivia Enttity', () async {
    // Assert
    expect(tNumberModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return valid model if number is integer', () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, equals(tNumberModel));
    });

    test('should return valid model if number is double', () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia_double.json'));
      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, equals(tNumberModel));
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      final result = tNumberModel.toJson();
      expect(result, {
        "text": "Lorem Ipsum",
        "number": 1,
      });
    });
  });
}
