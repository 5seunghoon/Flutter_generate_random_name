import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: RandomWords(), //여기에는 위젯이 들어간다. 이 위젯이 관찰할 상태는 State 에 따라 달라진다.
    );
  }
}

// StatefulWidget 을 만드려면 두가지가 필요하다.
//
// 위젯, 그리고 그 위젯의 상태
// 시스템은 위젯을 이용해서 모양새를 만들고,
// 그 위젯은 설정된 상태에 따라 내용이 변하게 된다.
//
// 먼저 StatefulWidget 을 상속함으로써 위젯을 만들고
// 해당 위젯의 상태를 담당해줄 State 를 만든다.
// 그리고 그 State 의 제네릭으로 StatefulWidget 을 넣어준다.
class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rand name generator"),
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(pair.asPascalCase, style: _biggerFont),
    );
  }
}
