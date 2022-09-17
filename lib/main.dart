import 'package:clean_architecture_tutorial/feature/number_trivia/presentation/pages/number_trivia_screen.dart';
import 'package:flutter/material.dart';
import 'app/DI/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
  runApp(const NumberTriviaApp());
}

class NumberTriviaApp extends StatelessWidget {
  const NumberTriviaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Number Trivia",
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        accentColor: Colors.green.shade600,
      ),
      home: NumberTriviaScreen(),
    );
  }
}
