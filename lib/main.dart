import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:english_words/english_words.dart';
import 'dart:async';

void main() => runApp(MyApp());

WordPair get generateSingleWordPair => generateWordPairs().take(1).toList()[0];

final suggestions = <WordPair>[];

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
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
  final _saved = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18, letterSpacing: 6);

  final Stream<List<WordPair>> _timeStreamImprove =
      Stream.periodic(Duration(seconds: 2), (var i) {
        suggestions.add(generateSingleWordPair);
        return suggestions;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Rand name generator"),
          actions: <Widget>[
            // Add 3 lines from here...
            IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
          ],
        ),
        body: Column(
          children: [
            _buildSuggestions(),
          ],
        ));
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext build) {
      final tiles = _saved.map((var pair) =>
          ListTile(title: Text(pair.asPascalCase, style: _biggerFont)));

      final List<Card> cards = tiles.map((var tile) => Card(child: tile,)).toList();

      return Scaffold(
        appBar: AppBar(
          title: Text("Saved Names"),
        ),
        //body: ListView(children: divided),
        body: Column(children: cards,),
      );
    }));
  }

  Flexible _buildSuggestions() {
    return Flexible(
      child: StreamBuilder(
        stream: _timeStreamImprove,
        initialData: <WordPair>[generateSingleWordPair],
        builder: (BuildContext context, AsyncSnapshot snapshot) {

          suggestions.forEach((var f) {
            print("s : " + f.asPascalCase);
          });
          print("${snapshot.data.runtimeType}");

          return Scrollbar(
            child: ListView.builder(
              itemCount: suggestions.length * 2,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, i) {
                if (i.isOdd) return Divider();
                final index = i ~/ 2;
                return _buildRow(suggestions[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile( title: Text(pair.asPascalCase, style: _biggerFont),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : Colors.black,
      ),
      onTap: () {
        setState(() {
          // setState : 다시 그림 == Widget 을 그리기 위해 함수를 다시 호출 함
          alreadySaved ? _saved.remove(pair) : _saved.add(pair);
        });
      },
    );
  }
}
