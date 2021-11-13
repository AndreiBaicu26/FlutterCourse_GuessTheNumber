import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final buttonStateGuess = "Guess";
  final buttonStateRetry = "Retry";
  final bigGreyTextStyle = const TextStyle(fontSize: 30, color: Colors.grey);
  final TextEditingController controller = TextEditingController();

  int generatedNumber = 1 + Random().nextInt(99);
  int selectedNumber = -1;
  String gameButtonText = "Guess";
  String hintText = "";
  bool inputEnabled = true;

  bool valueGuessed(insertedValue) {
    return insertedValue == generatedNumber;
  }

  bool retryButtonPressed() {
    return gameButtonText == buttonStateRetry;
  }

  void handleGuessButtonPressed() {
    if (retryButtonPressed()) {
      resetGame();
      return;
    }

    var value = int.tryParse(controller.text);
    if (value == null) return;
    controller.clear();

    if (valueGuessed(value)) {
      openDialog();
      setStateForHintAndSelectedNum(value, "You guessed the number!");
    } else {
      if (value < generatedNumber) {
        setStateForHintAndSelectedNum(value, "Try Higher");
      } else {
        setStateForHintAndSelectedNum(value, "Try Lower");
      }
    }
  }

  void setStateForHintAndSelectedNum(int selectedNUmber, String text) {
    setState(() {
      selectedNumber = selectedNUmber;
      hintText = text;
    });
  }

  void resetGame() {
    generatedNumber = generateRandomNumber();
    setState(() {
      hintText = "";
      inputEnabled = true;
      selectedNumber = -1;
      gameButtonText = buttonStateGuess;
    });
  }

  void endGame() {
    setState(() {
      gameButtonText = buttonStateRetry;
      inputEnabled = false;
    });
  }

  int generateRandomNumber() {
    return 1 + Random().nextInt(99);
  }

  void openDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("You guessed right"),
            content: Text("It was $selectedNumber"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  resetGame();
                },
                child: const Text("Cool, Try Again"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  endGame();
                },
                child: const Text("Nice"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guess my number"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          11.0,
        ),
        child: Column(
          children: <Widget>[
            const Text(
              "I am thinking of a number between 1 and 100.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(
                top: 20,
              ),
              child: const Text(
                "It's your turn to guess my number",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(
                top: 20,
              ),
              child: Visibility(
                child: Text(
                  'You chose: $selectedNumber',
                  style: bigGreyTextStyle,
                ),
                visible: selectedNumber != -1,
              ),
            ),
            Visibility(
              child: Text(
                hintText,
                style: bigGreyTextStyle,
              ),
              visible: hintText != "",
            ),
            Card(
              elevation: 10.0,
              margin: const EdgeInsetsDirectional.only(
                top: 40,
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.all(
                  8.0,
                ),
                child: Column(
                  children: <Widget>[
                    const Text(
                      "Try a number!",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.grey,
                      ),
                    ),
                    TextField(
                      controller: controller,
                      keyboardType: const TextInputType.numberWithOptions(),
                      enabled: inputEnabled,
                    ),
                    Container(
                      margin: const EdgeInsetsDirectional.only(
                        top: 10,
                      ),
                      child: ElevatedButton(
                        onPressed: handleGuessButtonPressed,
                        child: Text(
                          gameButtonText,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
