// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tip_tap_type/theme/theme_constants.dart';
import 'package:tip_tap_type/theme/theme_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyAppState()),
        ChangeNotifierProvider(create: (context) => WordsState()),
        ChangeNotifierProvider(create: (context) => ThemeManager()),
      ],
      child: Builder(builder: (BuildContext context) {
        final themeManager = Provider.of<ThemeManager>(context);
        return MaterialApp(
          title: 'Tip-Tap-Type',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeManager.themeMode,
          home: const MyHomePage(),
        );
      }),
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
                extended: constraints.maxWidth >= 800,
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
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "TIP-TAP-TYPE",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Modes',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const ListTile(
              title: Text('Typing Practice'),
              subtitle: Text('Just keep typing, just keep typing~'),
            ),
            const SizedBox(height: 10),
            const ListTile(
              title: Text('100 Word Dash'),
              subtitle: Text('Type 100 as fast as you can!'),
            ),
            const SizedBox(height: 10),
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
        page = const TypingPage();
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
    var wordsState = context.watch<WordsState>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'SELECT MODE',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FilledButton(
                onPressed: () {
                  wordsState.resetAllValues();
                  wordsState.addWords(6);
                  appState.updatePlayIndex(1);
                },
                child: Text(
                  'Typing Practice',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: FilledButton(
                onPressed: () {
                  wordsState.resetAllValues();
                  wordsState.addWords(6);
                  appState.updatePlayIndex(1);
                  wordsState.startTimer();
                },
                child: Text(
                  'Hundred Word Dash',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WordsState extends ChangeNotifier {
  WordsState() {
    loadWords().then((value) {
      wordBank = value.split("\r\n"); // \n new line, \r\n carriage return
    });
  }
  bool objectiveComplete = false;

  Stopwatch stopwatch = Stopwatch();
  late Timer timer;
  int timeCount = 0;

  int correctWordCount = 0;
  int incorrectWordCount = 0;
  int charInWordCount = 0;

  String currentStringInput = '';
  String objectiveCompleteString = '';

  List<RichText> wordWidgets = [];
  List<String> currentWords = [];
  List<String> wordBank = [];
  List<List<TextSpan>> charWidgets = [[]];

  TextStyle defaultText =
      const TextStyle(color: Color.fromARGB(71, 255, 255, 255), fontSize: 30);
  TextStyle correctText = const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 30);
  TextStyle incorrectText =
      const TextStyle(color: Color.fromARGB(255, 203, 84, 75), fontSize: 30);
  TextStyle currentText = const TextStyle(
    color: Color.fromARGB(74, 0, 0, 0),
    fontSize: 30,
    decoration: TextDecoration.underline,
  );

  Future<String> loadWords() async {
    final String response = await rootBundle.loadString('assets/words.txt');
    return response;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(microseconds: 30), (Timer t) { 
      timeCount = stopwatch.elapsed.inSeconds;
      if (correctWordCount == 10 && !objectiveComplete && stopwatch.isRunning) {
        stopwatch.stop();
        stopwatch.reset();
        timer.cancel();
        objectiveComplete = true;
        objectiveCompleteString = "You typed 100 words in $timeCount seconds!";
      }
      notifyListeners();
    });
    stopwatch.start();
  }

  void resetAllValues() {
    wordWidgets.clear();
    charWidgets.clear();
    currentWords.clear();
    stopwatch.reset();
    stopwatch.stop();
    charInWordCount = 0;
    timeCount = 0;
    correctWordCount = 0;
    incorrectWordCount = 0;
    objectiveComplete = false;
    objectiveCompleteString = '';
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
        textList.add(TextSpan(text: currentWords[i][j], style: defaultText));
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

  void replaceChar(TextStyle newStyle, String key) {
    TextSpan newText = TextSpan(text: key, style: newStyle);
    //print(charWidgets[0][charInWordCount]);
    charWidgets[0][charInWordCount] = newText;
    updateCurrentWord();
    notifyListeners();
  }

  String currentCharacter() {
    String result = '';
    if (currentWords[0].length > charInWordCount) {
      result = currentWords[0][charInWordCount];
    }
    //print(result);
    return result;
  }

  void moveToNextWord() {
    if (currentStringInput == currentWords[0]) {
      correctWordCount++;
    } else {
      incorrectWordCount++;
    }

    if (charInWordCount < currentWords[0].length) {
      int missingChars = currentWords[0].length - charInWordCount;
      for (int i = 0; i < missingChars; i++) {
        replaceChar(
          incorrectText,
          currentWords[0][charInWordCount + i],
        );
      }
    }

    wordWidgets.removeAt(0);
    currentWords.removeAt(0);
    charWidgets.removeAt(0);
    addWords(1);
    charInWordCount = 0;
    //print("space");
    currentStringInput = '';
    notifyListeners();
  }

  void correctCharTyped(String keyInput) {
    currentStringInput += keyInput;
    replaceChar(correctText, keyInput);
    charInWordCount++;
    //print("correct");
  }

  void incorrectCharTyped(String keyInput) {
    currentStringInput += keyInput;
    replaceChar(
      incorrectText,
      currentWords[0][charInWordCount],
    );
    charInWordCount++;
    //print('wrong');
  }

  void addIncorrectChar(String char) {
    currentStringInput += char;
    TextSpan newText = TextSpan(text: char, style: incorrectText);
    charWidgets[0].insert(charInWordCount, newText);
    updateCurrentWord();
    charInWordCount++;
    //print("overflow");
    notifyListeners();
  }

  void deleteChar() {
    if (charInWordCount > 0) {
      currentStringInput = currentStringInput.substring(0, charInWordCount - 1);
      if (charInWordCount <= currentWords[0].length) {

        charInWordCount--;
        //print("delete in limit");
        replaceChar(
          defaultText,
          currentWords[0][charInWordCount],
        );
      } else {
        var w = charWidgets[0].removeAt(charInWordCount - 1);
        //print(w);
        charInWordCount--;
        updateCurrentWord();
        //print("delete over limit");
        notifyListeners();
      }
    }
  }

  void updateCurrentWord() {
    double newTextScale;
    if (wordWidgets[0].textScaleFactor == 1) {
      newTextScale = 0.99999;
    } else {
      newTextScale = 1;
    }

    var newWord = RichText(
      textScaleFactor: newTextScale,
      text: TextSpan(
        children: charWidgets[0],
      ),
    );

    wordWidgets[0] = newWord;
  }
}

class TypingPage extends StatelessWidget {
  const TypingPage({super.key});

  @override
  Widget build(BuildContext context) {
    var wordsState = context.watch<WordsState>();
    Column textWrap = Column(children: wordsState.wordWidgets);
    Text correctCount = Text(wordsState.correctWordCount.toString());
    Text incorrectCount = Text(wordsState.incorrectWordCount.toString());
    Text timer = Text(wordsState.timeCount.toString());
    Text objectiveCompleteText = Text(wordsState.objectiveCompleteString);

    return RawKeyboardListener(
      onKey: (event) {
        if (event is RawKeyDownEvent && !wordsState.objectiveComplete) {
          // finished typing word
          if (event.logicalKey == LogicalKeyboardKey.space
            || event.logicalKey == LogicalKeyboardKey.enter) {
            wordsState.moveToNextWord();
          // correct key input
          } else if (event.character == wordsState.currentCharacter()) {
            wordsState.correctCharTyped(event.character.toString());
          // delete char
          } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
            wordsState.deleteChar();
          // typed more than expected
          } else if (wordsState.currentWords[0].length <=
              wordsState.charInWordCount) {
            wordsState.addIncorrectChar(event.character.toString());
          // wrong key input
          } else if (event.character != wordsState.currentCharacter()) {
            wordsState.incorrectCharTyped(event.character.toString());
          }
        }
      },
      focusNode: FocusNode(),
      autofocus: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check),
                        correctCount,
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.close),
                        incorrectCount,
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.timer),
                        timer,
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                textWrap,
                const SizedBox(height: 50),
                objectiveCompleteText,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OptionsPage extends StatefulWidget {
  const OptionsPage({super.key});

  @override
  State<OptionsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  @override
  Widget build(BuildContext context) {
    print('build');
    var themeState = context.watch<ThemeManager>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'OPTIONS',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const Text('Dark Mode'),
          Switch(
              value: themeState.themeMode == ThemeMode.dark,
              onChanged: (newValue) {
                themeState.toggleTheme(newValue);
              }),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
