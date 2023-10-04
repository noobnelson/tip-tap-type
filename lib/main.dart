import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {

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

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(title: const Text('Tip-Tap-Type')),
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
                      label: Text('Leaderboard'),
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
      }
    );
  }
}

class TitlePage extends StatelessWidget {
  const TitlePage({ super.key });
  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Welcome! Let's get practicing!"),
        SizedBox(height: 30),
        Row(
          children: [
            Text(
              '''Difficulties: 
              Simple: lowercase and basic words
              Standard: capital letters, punctuation and common words
              Stupendous: capital letters, punctuation and complex words
              '''
            ),
          ],
        ),
      ],
    );
  }
}

class PlayPage extends StatelessWidget {
  const PlayPage({ super.key });
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('SELECT DIFFICULTY'),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({ super.key });
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
  const OptionsPage({ super.key });
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
