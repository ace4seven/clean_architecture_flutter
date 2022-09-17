import 'package:clean_architecture_tutorial/feature/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/DI/injection_container.dart';

class NumberTriviaScreen extends StatelessWidget {
  NumberTriviaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Number Trivia"),
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Top Half
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: Placeholder(),
                  );
                },
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  const Placeholder(
                    fallbackHeight: 40,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Expanded(child: Placeholder(fallbackHeight: 30)),
                      SizedBox(width: 10),
                      Expanded(child: Placeholder(fallbackHeight: 30)),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
