import 'package:clean_architecture_tutorial/feature/number_trivia/domain/entity/number_trivia.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';

import '../../../../library/error/failure.dart';
import '../../../../library/usecase/usecase.dart';

class GetRandomNumberTrivia implements SuspendUnitUseCase<NumberTrivia> {

  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<dartz.Either<Failure, NumberTrivia>> call() async {
    return await repository.getRandomNumberTrivia();
  }

}

class LoremIpsumWidget extends StatefulWidget {
  const LoremIpsumWidget({Key? key}) : super(key: key);

  @override
  State<LoremIpsumWidget> createState() => _LoremIpsumWidgetState();
}

class _LoremIpsumWidgetState extends State<LoremIpsumWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
