// ignore_for_file: avoid_print

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyAppState()),
        ChangeNotifierProvider(create: (context) => KeyboardState()),
      ],
      //create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 255, 206, 46)),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var selectedPlayIndex = 0;

  void updatePlayIndex(int index) {
    selectedPlayIndex = index;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const TitlePage();
        break;
      case 1:
        page = const PlayPage();
        break;
      case 2:
        page = const LeaderboardPage();
        break;
      case 3:
        page = const OptionsPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 1000,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.sports_esports),
                    label: Text('Play'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.star_rounded),
                    label: Text('Highscores'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text('Settings'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                    appState.updatePlayIndex(0);
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class TitlePage extends StatelessWidget {
  const TitlePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome! Let's get practicing!",
              style:
                  DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
            ),
            const SizedBox(height: 30),
            RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: 'MODES',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              'Typing Practice',
              style: TextStyle(fontSize: 30),
            ),
            const Text(
              'Just keep typing, just keep typing~',
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              '100 Word Dash',
              style: TextStyle(fontSize: 30),
            ),
            const Text(
              'Type 100 words as fast as you can!',
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Minute to Win It',
              style: TextStyle(fontSize: 30),
            ),
            const Text(
              'Put your skills to the test! Can you type 100 words in 1 minute?',
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  @override
  Widget build(BuildContext context) {
    Widget page = const DifficultySelectPage();
    var appState = context.watch<MyAppState>();
    switch (appState.selectedPlayIndex) {
      case 0:
        page = const DifficultySelectPage();
        break;
      case 1:
        page = const TypingPracticePage();
        break;
      case 2:
        page = const MinuteToWinPage();
        break;
      case 3:
        page = const HundredWordDashPage();
        break;
      default:
        throw UnimplementedError('no widget');
    }

    return Container(
      child: page,
    );
  }
}

class DifficultySelectPage extends StatelessWidget {
  const DifficultySelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var keyboardState = context.watch<KeyboardState>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'SELECT MODE',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SizedBox(
                height: 300,
                width: 300,
                child: FilledButton(
                  onPressed: () {
                    keyboardState.resetWords();
                    keyboardState.addWords(100);
                    appState.updatePlayIndex(1);
                  },
                  child: const Text(
                    'Typing Practice',
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: SizedBox(
                height: 300,
                width: 300,
                child: FilledButton(
                  onPressed: () {
                    keyboardState.resetWords();
                    keyboardState.addWords(100);
                    appState.updatePlayIndex(2);
                  },
                  child: const Text(
                    'Minute to Win it',
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: SizedBox(
                height: 300,
                width: 300,
                child: FilledButton(
                  onPressed: () {
                    keyboardState.resetWords();
                    keyboardState.addWords(100);
                    appState.updatePlayIndex(3);
                  },
                  child: const Text(
                    'Hundred Word Dash',
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KeyboardState extends ChangeNotifier {
  KeyboardState() {
    loadWords().then((value) {
      wordBank = value.split("\r\n"); // \n new line, \r\n carriage return
    });
  }

  List<RichText> wordWidgets = [];
  List<String> currentWords = [];
  List<String> wordBank = [];
  List<List<TextSpan>> charWidgets = [[]];

  int wordCount = 0;
  int charInWordCount = 0;

  Color correctColor = Colors.green;
  Color incorrectColor = Colors.red;
  Color defaultColor = Colors.black;

  Future<String> loadWords() async {
    final String response = await rootBundle.loadString('assets/words.txt');
    return response;
  }

  void resetWords() {
    wordWidgets.clear();
    charWidgets.clear();
    currentWords.clear();
    wordCount = 0;
    charInWordCount = 0;
  }

  void addWords(int numberOfWords) {
    int startPoint = currentWords.length;
    int wordBankSize = wordBank.length;

    for (int i = 0; i < numberOfWords; i++) {
      int randomWordPosition = Random().nextInt(wordBankSize);
      currentWords.add(wordBank[randomWordPosition]);
    }

    for (var i = startPoint; i < currentWords.length; i++) {
      var textList = <TextSpan>[];
      for (var j = 0; j < currentWords[i].length; j++) {
        textList.add(TextSpan(
            text: currentWords[i][j],
            style: const TextStyle(color: Colors.black)));
      }
      textList.add(const TextSpan(
        text: ' ',
      ));
      charWidgets.add(textList);
      wordWidgets.add(RichText(
        text: TextSpan(
          children: charWidgets[i],
        ),
      ));
    }
  }

  void replaceChar(Color color, String key) {
    TextSpan newText = TextSpan(text: key, style: TextStyle(color: color));
    //print(charWidgets[wordCount][charInWordCount]);
    charWidgets[wordCount][charInWordCount] = newText;
    updateCurrentWord();
    notifyListeners();
  }

  String currentCharacter() {
    String result = '';
    if (currentWords[wordCount].length > charInWordCount) {
      result = currentWords[wordCount][charInWordCount];
    }
    //print(result);
    return result;
  }

  void moveToNextWord() {
    if (charInWordCount < currentWords[wordCount].length) {
      int missingChars = currentWords[wordCount].length - charInWordCount;
      for (int i = 0; i < missingChars; i++) {
        replaceChar(
          incorrectColor,
          currentWords[wordCount][charInWordCount + i],
        );
      }
    }
    charInWordCount = 0;
    wordCount++;
    print("space");
  }

  void correctCharTyped(String keyInput) {
    replaceChar(correctColor, keyInput);
    charInWordCount++;
    print("correct");
  }

  void incorrectCharTyped() {
    replaceChar(
      incorrectColor,
      currentWords[wordCount][charInWordCount],
    );
    charInWordCount++;
    print('wrong');
  }

  void addIncorrectChar(String char) {
    TextSpan newText =
        TextSpan(text: char, style: TextStyle(color: incorrectColor));
    charWidgets[wordCount].insert(charInWordCount, newText);
    updateCurrentWord();
    charInWordCount++;
    print("overflow");
    notifyListeners();
  }

  void deleteChar() {
    if (charInWordCount > 0) {
      if (charInWordCount <= currentWords[wordCount].length) {
        charInWordCount--;
        print("delete in limit");
        replaceChar(
          defaultColor,
          currentWords[wordCount][charInWordCount],
        );
      } else {
        var w = charWidgets[wordCount].removeAt(charInWordCount - 1);
        print(w);
        charInWordCount--;
        updateCurrentWord();
        print("delete over limit");
        notifyListeners();
      }
    }
  }

  void updateCurrentWord() {
    double newTextScale;
    if (wordWidgets[wordCount].textScaleFactor == 1) {
      newTextScale = 0.999999;
    } else {
      newTextScale = 1;
    }

    var newWord = RichText(
      textScaleFactor: newTextScale,
      text: TextSpan(
        children: charWidgets[wordCount],
      ),
    );

    wordWidgets[wordCount] = newWord;
  }
}

class TypingPracticePage extends StatelessWidget {
  const TypingPracticePage({super.key});

  @override
  Widget build(BuildContext context) {
    var keyboardState = context.watch<KeyboardState>();
    Column textWrap = Column(
      children: keyboardState.wordWidgets,
    );
    return RawKeyboardListener(
      onKey: (event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.space) {
            keyboardState.moveToNextWord();
          } else if (event.character == keyboardState.currentCharacter()) {
            keyboardState.correctCharTyped(event.character.toString());
          } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
            keyboardState.deleteChar();
          } else if (keyboardState
                  .currentWords[keyboardState.wordCount].length <=
              keyboardState.charInWordCount) {
            keyboardState.addIncorrectChar(event.character.toString());
          } else if (event.character != keyboardState.currentCharacter()) {
            keyboardState.incorrectCharTyped();
          }
        }
      },
      focusNode: FocusNode(),
      autofocus: true,
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: textWrap,
          ),
          // child: ListView(
          //   children: keyboardState.wordWidgets
          // ),
        ),
      ),
    );
  }
}

class MinuteToWinPage extends StatelessWidget {
  const MinuteToWinPage({super.key});

  @override
  Widget build(BuildContext context) {
    var keyboardState = context.watch<KeyboardState>();
    Wrap textWrap = Wrap(children: keyboardState.wordWidgets);
    return RawKeyboardListener(
      onKey: (event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.space) {
            keyboardState.moveToNextWord();
          } else if (event.character == keyboardState.currentCharacter()) {
            keyboardState.correctCharTyped(event.character.toString());
          } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
            keyboardState.deleteChar();
          } else if (keyboardState
                  .currentWords[keyboardState.wordCount].length <=
              keyboardState.charInWordCount) {
            keyboardState.addIncorrectChar(event.character.toString());
          } else if (event.character != keyboardState.currentCharacter()) {
            keyboardState.incorrectCharTyped();
          }
        }
      },
      focusNode: FocusNode(),
      autofocus: true,
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: textWrap,
        ),
      ),
    );
  }
}

class HundredWordDashPage extends StatelessWidget {
  const HundredWordDashPage({super.key});

  @override
  Widget build(BuildContext context) {
    var keyboardState = context.watch<KeyboardState>();
    Wrap textWrap = Wrap(children: keyboardState.wordWidgets);
    return RawKeyboardListener(
      onKey: (event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.space) {
            keyboardState.moveToNextWord();
          } else if (event.character == keyboardState.currentCharacter()) {
            keyboardState.correctCharTyped(event.character.toString());
          } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
            keyboardState.deleteChar();
          } else if (keyboardState
                  .currentWords[keyboardState.wordCount].length <=
              keyboardState.charInWordCount) {
            keyboardState.addIncorrectChar(event.character.toString());
          } else if (event.character != keyboardState.currentCharacter()) {
            keyboardState.incorrectCharTyped();
          }
        }
      },
      focusNode: FocusNode(),
      autofocus: true,
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: textWrap,
        ),
      ),
    );
  }
}

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('LEADERBOARD'),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('OPTIONS'),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
