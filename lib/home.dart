import 'package:flutter/material.dart';
import 'package:quiz/answer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Icon> _scoreTracker = [];
  int _questionIndex = 0;
  int _totalScore = 0;
  bool answerWasSelected = false;
  bool endOfQuiz = false;
  bool correctAnswerSelected = false;

  void _questionAnswered(bool answerScore) {
    setState(() {
      // answer was selected
      answerWasSelected = true;
      // check if answer was correct
      if (answerScore) {
        _totalScore++;
        correctAnswerSelected = true;
      }
      // adding to the score tracker on top
      _scoreTracker.add(
        answerScore
            ? Icon(
          Icons.check_circle,
          color: Colors.green,
        )
            : Icon(
          Icons.clear,
          color: Colors.redAccent,
        ),
      );
      //when the quiz ends
      if (_questionIndex + 1 == _questions.length) {
        endOfQuiz = true;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _questionIndex++;
      answerWasSelected = false;
      correctAnswerSelected = false;
    });
    // what happens at the end of the quiz
    if (_questionIndex >= _questions.length) {
      _resetQuiz();
    }
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
      _scoreTracker = [];
      endOfQuiz = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Flutter quiz'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.blueAccent, Colors.black]),
          ),
        ),
      ),
      body:
        Container(
          alignment: Alignment.center,
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(image:DecorationImage(
          image: NetworkImage(
            'https://rare-gallery.com/mocahbig/87810-flutter-code-computer-programming-logo-hd-4k.jpg'
          ),
          fit: BoxFit.cover,
          opacity: 30.0,
        ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                if (_scoreTracker.length == 0)
                  SizedBox(
                    height: 30.0,
                  ),
                if (_scoreTracker.length > 0) ..._scoreTracker
              ],
            ),
            Container(
              width: double.infinity,
              height: 140.0,
              margin: EdgeInsets.only(bottom: 10.0, left: 30.0, right: 30.0),
              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://bs-uploads.toptal.io/blackfish-uploads/components/seo/content/og_image_file/og_image/1096555/0408-FlutterMessangerDemo-Luke_Social-e8a0e8ddab86b503a125ebcad823c583.png'),
                  fit: BoxFit.cover,
                  opacity: 10,
                ),
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  _questions[_questionIndex]['question'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ...(_questions[_questionIndex]['answers']
            as List<Map<String, Object>>)
                .map(
                  (answer) => Answer(
                answerText: answer['answerText'],
                answerColor:
                answerWasSelected
                    ? answer['score']
                    ? Colors.green
                    : Colors.red
                    : null,
                answerTap: () {
                  if (answerWasSelected) {
                    return;
                  }
                  //answer is being selected
                  _questionAnswered(answer['score']);
                },
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              child: ElevatedButton(
              style:
              ElevatedButton.styleFrom(
                minimumSize: Size(200.00, 40.0),backgroundColor:Colors.blueAccent,shadowColor: Colors.blueAccent,
              ),
              onPressed: () {
                if (!answerWasSelected) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Please select an answer before going to the next question'),
                  ));
                  return;

                }
                _nextQuestion();
              },
              child: Text(endOfQuiz ? 'Restart Quiz' : 'Next Question'),
            ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Text(
                '${_totalScore.toString()}/${_questions.length}',
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold, color: Colors.white70),
              ),
            ),
            if (answerWasSelected && !endOfQuiz)
              Container(
                height: 100,
                width: double.infinity,
                color: correctAnswerSelected ? Colors.green : Colors.red,
                child: Center(
                  child: Text(
                    correctAnswerSelected
                        ? 'Good Answer.'
                        : 'Wrong Answer.',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (endOfQuiz)
              Container(
                height: 100,
                width: double.infinity,
                color: Colors.blueAccent,
                child: Center(
                  child: Text(
                    _totalScore > 4
                        ? 'Congratulations! Your final score is: $_totalScore'
                        : 'Your final score is: $_totalScore. Better luck next time!',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: _totalScore > 4 ? Colors.green : Colors.white,
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

final _questions = const [
  {
    'question': 'What is Flutter?',
    'answers': [
      {'answerText': 'A. Flutter is an open-source backend development framework.', 'score': false},
      {'answerText': 'B. Flutter is an open-source UI toolkit.', 'score': true},
      {'answerText': 'C. Flutter is an open-source programming language for cross-platform applications.', 'score': false},
      {'answerText': 'D. Flutters is a DBMS toolkit.', 'score': false},
    ],
  },
  {
    'question':
    'Who developed the Flutter Framework and continues to maintain it today?',
    'answers': [
      {'answerText': 'A. Facebook', 'score': false},
      {'answerText': 'B. Microsoft', 'score': false},
      {'answerText': 'C. Google', 'score': true},
      {'answerText': 'D. Oracle', 'score': false},

    ],
  },
  {
    'question': 'Which programming language is used to build Flutter applications?',
    'answers': [
      {'answerText': 'A. Kotlin', 'score': false},
      {'answerText': 'B. Dart', 'score': true},
      {'answerText': 'C. Java', 'score': false},
      {'answerText': 'D. Go', 'score': false},
    ],
  },
  {
    'question': 'How many types of widgets are there in Flutter?',
    'answers': [
      {'answerText': '2', 'score': true},
      {'answerText': '4', 'score': false},
      {'answerText': '6', 'score': false},
      {'answerText': '8+', 'score': false},
    ],
  },
  {
    'question':
    'When building for iOS, Flutter is restricted to an __ compilation strategy',
    'answers': [
      {'answerText': 'A. AOT (ahead-of-time)', 'score': true},
      {'answerText': 'B. JIT (Just-in-time)', 'score': false},
      {'answerText': 'C. Transcompilation', 'score': false},
      {'answerText': 'D. Recompilation', 'score': false},

    ],
  },
  {
    'question': 'A sequence of asynchronous Flutter events is known as a:',
    'answers': [
      {'answerText': 'Flow', 'score': false},
      {'answerText': 'Current', 'score': false},
      {'answerText': 'Stream', 'score': true},
      {'answerText': 'Series', 'score': false},
    ],
  },
  {
    'question': 'Access to a cloud database through Flutter is available through which service?',
    'answers': [
      {'answerText': 'A. SQLite', 'score': false},
      {'answerText': 'B. Firebase Database', 'score': true},
      {'answerText': 'C. NOSQL', 'score': false},
      {'answerText': 'D. MYSQL', 'score': false},
    ],
  },
  {
    'question': 'What are some key advantages of Flutter over alternate frameworks?',
    'answers': [
      {'answerText': 'A. Rapid cross-platform application development and debugging tools', 'score': false},
      {'answerText': 'B. Future-proofed technologies and UI resources', 'score': false},
      {'answerText': 'C. Strong supporting tools for application development and launch', 'score': false},
      {'answerText': 'D. All of the above', 'score': true},
    ],
  },
  {
    'question': 'What element is used as an identifier for components when programming in Flutter?',
    'answers': [
      {'answerText': 'A. Widgets', 'score': false},
      {'answerText': 'B. Keys', 'score': true},
      {'answerText': 'C. Elements', 'score': false},
      {'answerText': 'D. Serial', 'score': false},
    ],
  },
  {
    'question': 'What type of test can examine your code as a complete system?',
    'answers': [
      {'answerText': 'A. Unit tests', 'score': false},
      {'answerText': 'B. Widget tests', 'score': false},
      {'answerText': 'C. Integration Tests', 'score': true},
      {'answerText': 'D. All of the above', 'score': false},
    ],
  },
  {
    'question': 'What type of Flutter animation allows you to represent real-world behavior?',
    'answers': [
      {'answerText': 'A. Physics-based', 'score': true},
      {'answerText': 'B. Maths-based', 'score': false},
      {'answerText': 'C. Graph-based', 'score': false},
      {'answerText': 'D. Sim-based', 'score': false},
    ],
  },
  {
    'question': 'What is the key configuration file used when building a Flutter project?',
    'answers': [
      {'answerText': 'A. pubspec.yaml', 'score': true},
      {'answerText': 'B. pubspec.xml', 'score': false},
      {'answerText': 'C. config.html', 'score': false},
      {'answerText': 'D. root.xml', 'score': false},
    ],
  },
  {
    'question': 'True or false: Flutter boasts improved runtime performance over most application frameworks?.',
    'answers': [
      {'answerText': 'True', 'score': true},
      {'answerText': 'False', 'score': false},
    ],
  },
  {
    'question': 'What command would you use to compile your Flutter app in release mode?',
    'answers': [
      {'answerText': 'A. Flutter --release', 'score': false},
      {'answerText': 'B. Flutter build --release', 'score': false},
      {'answerText': 'C. Flutter run --release', 'score': true},
      {'answerText': 'D. Flutter run &release', 'score': false},
    ],
  },
  {
    'question': 'Which function will return the widgets attached to the screen as a root of the widget tree to be rendered on screen?',
    'answers': [
      {'answerText': 'A. main()', 'score': false},
      {'answerText': 'B. runApp()', 'score': true},
      {'answerText': 'C. container()', 'score': false},
      {'answerText': 'D. root()', 'score': false},
    ],
  },
  {
    'question': 'Which component allows us to specify the distance between widgets on the screen?',
    'answers': [
      {'answerText': 'A. SafeArea', 'score': false},
      {'answerText': 'B. SizedBox', 'score': true},
      {'answerText': 'C. table', 'score': false},
      {'answerText': 'D. AppBar', 'score': false},
    ],
  },
  {
    'question': 'Which widget type allows you to modify its appearance dynamically according to user input?',
    'answers': [
      {'answerText': 'A. Stateful widget', 'score': true},
      {'answerText': 'B. Stateless widget', 'score': false},
    ],
  },
];