import 'package:clean_architecture_tutorial/library/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test('should return an integer when the string represents an usigned integer', () async {
      // arange
      final string = '134';
      // act
      final result = inputConverter.stringToUnsignedInteger(string);
      // assert
      expect(result, Right(134));
    });

    test('should return a Failure when the string is not an integer', () async {
      // arange
      final string = 'abc';
      // act
      final result = inputConverter.stringToUnsignedInteger(string);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });

    test('should return a Failure when the string is negative integer', () async {
      // arange
      final string = '-120';
      // act
      final result = inputConverter.stringToUnsignedInteger(string);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}