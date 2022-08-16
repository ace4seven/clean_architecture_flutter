import 'package:clean_architecture_tutorial/feature/number_trivia/domain/entity/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({
    required super.text,
    required super.number,
  });

  factory NumberTriviaModel.fromJson(Map<String, dynamic> jsonMap) {
    return NumberTriviaModel(text: jsonMap['text'], number: (jsonMap['number'] as num).toInt());
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number
    };
  }
}
