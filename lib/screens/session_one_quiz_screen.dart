import 'package:flutter/material.dart';

import '../data/content.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/environment_background.dart';
import '../widgets/session_page_navigation.dart';

class SessionOneQuizScreen extends StatefulWidget {
  const SessionOneQuizScreen({super.key});

  @override
  State<SessionOneQuizScreen> createState() => _SessionOneQuizScreenState();
}

class _SessionOneQuizScreenState extends State<SessionOneQuizScreen> {
  final List<Quiz> _questions = List<Quiz>.of(sessionQuizzes[1]!);
  final Map<int, List<String>> _choiceExplanations = const {
    0: [
      'Distance traveled over time describes speed, not acceleration.',
      'Correct! Acceleration describes how quickly velocity changes over time.',
      'Mass measures how much matter an object contains.',
      'Size describes an object’s dimensions, not its acceleration.',
    ],
    1: [
      'm/s is a unit of speed or velocity. Acceleration is velocity change per second.',
      'km/h is commonly used for speed, not acceleration.',
      'Correct! (m/s) per second is m/s².',
      'Kilograms measure mass, not acceleration.',
    ],
    2: [
      'Correct! Speeding up, slowing down, or changing direction means velocity changes.',
      'An object at rest has no motion, but a changing velocity describes acceleration.',
      'Velocity can change while speed stays constant if direction changes.',
      'Mass is not what defines acceleration.',
    ],
    3: [
      'Initial velocity is the starting velocity, not the duration.',
      'Final velocity is the ending velocity, not the duration.',
      'Correct! Time tells how long the velocity changes.',
      'Distance tells how far an object travels, not how long the change takes.',
    ],
    4: [
      'Check it: 2 × 4 = 8 m/s, not the 20 m/s change in velocity.',
      'Check it: 4 × 4 = 16 m/s, not the 20 m/s change in velocity.',
      'Correct! a = (20 − 0) ÷ 4 = 20 ÷ 4 = 5 m/s².',
      'Check it: 8 × 4 = 32 m/s, not the 20 m/s change in velocity.',
    ],
  };

  bool _started = false;
  bool _finished = false;
  int _index = 0;
  int _score = 0;
  int? _selected;

  void _choose(int option) {
    if (_selected != null) return;
    AppScope.of(context).click();
    setState(() {
      _selected = option;
      if (option == _questions[_index].answer) _score++;
    });
  }

  void _next() {
    if (_index < _questions.length - 1) {
      setState(() {
        _index++;
        _selected = null;
      });
      return;
    }
    final state = AppScope.of(context);
    state.recordChallenge(_score, total: _questions.length);
    state.completeLesson(1);
    setState(() => _finished = true);
  }

  void _retry() {
    setState(() {
      _finished = false;
      _index = 0;
      _score = 0;
      _selected = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n(context, 'Week 1 · Acceleration Quiz',
            'Linggo 1 · Pagsusulit sa Akselerasyon')),
      ),
      bottomNavigationBar: const SessionPageNavigationBar(
        sessionId: 1,
        currentPage: SessionPage.quiz,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: dark
                ? const [Color(0xFF0E1526), Color(0xFF111C32)]
                : const [Color(0xFFE8F5FF), Color(0xFFD5E9FF)],
          ),
        ),
        child: SafeArea(
          top: false,
          child: _finished
              ? _resultView()
              : !_started
                  ? _startView()
                  : _questionView(),
        ),
      ),
    );
  }

  Widget _brandHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF087DE0), Color(0xFF0755B7)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x33002C72), blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset('assets/icon/icon.png', width: 48, height: 48),
        ),
        const SizedBox(width: 9),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AccelLab',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      height: 1,
                      fontWeight: FontWeight.w900)),
              Text('Learn. Move. Accelerate.',
                  style: TextStyle(
                      color: Color(0xFFD8F1FF),
                      fontSize: 10,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
              color: const Color(0xFF064B9A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white70)),
          child: const Text('WEEK 1',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w900)),
        ),
      ]),
    );
  }

  Widget _startView() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
      children: [
        _brandHeader(),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: cardColor(context),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF7DC9F4), width: 2),
          ),
          child: Column(children: [
            Text('Acceleration Quiz',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 24,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(
              l10n(context, 'Test your knowledge about acceleration!',
                  'Subukan ang iyong kaalaman tungkol sa akselerasyon!'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: subText(context),
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: SizedBox(
                height: 178,
                child: Stack(
                  children: [
                    const Positioned.fill(
                      child: EnvironmentBackground(
                          environment: Environment.city, distance: 0),
                    ),
                    const Positioned(
                      left: 0,
                      right: 0,
                      bottom: 8,
                      child: Center(
                        child: VehicleWidget(
                            type: VehicleType.autoRickshaw, width: 150),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .94),
                            borderRadius: BorderRadius.circular(18)),
                        child: const Row(children: [
                          Icon(Icons.quiz_rounded, color: C.blue, size: 16),
                          SizedBox(width: 4),
                          Text('5 QUESTIONS',
                              style: TextStyle(
                                  color: C.navy,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900)),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            BigButton(
              l10n(context, 'START QUIZ', 'SIMULAN ANG PAGSUSULIT'),
              color: C.blue,
              icon: Icons.play_arrow_rounded,
              onTap: () => setState(() => _started = true),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _questionView() {
    final dark = isDark(context);
    final question = _questions[_index];
    final answered = _selected != null;
    final correct = _selected == question.answer;
    final explanations = _choiceExplanations[_index]!;
    return ListView(
      padding: const EdgeInsets.fromLTRB(13, 10, 13, 16),
      children: [
        _brandHeader(),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                minHeight: 13,
                value: (_index + (answered ? 1 : 0)) / _questions.length,
                backgroundColor:
                    dark ? Colors.white.withValues(alpha: .15) : Colors.white,
                color: C.green,
              ),
            ),
          ),
          const SizedBox(width: 9),
          Text('${_index + 1}/${_questions.length}',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w900)),
          const SizedBox(width: 10),
          const Icon(Icons.star_rounded, color: C.orange, size: 19),
          Text('$_score',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w900)),
        ]),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardColor(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF9CCBF0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: Text('Question ${_index + 1}',
                      style: const TextStyle(
                          color: C.blue, fontWeight: FontWeight.w900)),
                ),
                if (_index == 4)
                  const VehicleWidget(
                      type: VehicleType.autoRickshaw, width: 65),
              ]),
              const SizedBox(height: 7),
              Text(question.questionFor(AppScope.of(context).tagalog),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      height: 1.25)),
              if (_index == 4) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: dark
                        ? const Color(0xFF263B5C)
                        : const Color(0xFFEAF5FF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFBCDDF7)),
                  ),
                  child: Text('a = (vf − vi) ÷ t',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 17,
                          fontWeight: FontWeight.w900)),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < question.options.length; i++)
          _answerOption(question, i),
        if (answered) ...[
          const SizedBox(height: 2),
          _feedback(question, explanations, correct),
          const SizedBox(height: 10),
          BigButton(
            _index == _questions.length - 1 ? 'Finish Quiz' : 'Next',
            icon: Icons.arrow_forward_rounded,
            color: C.blue,
            onTap: _next,
          ),
        ],
      ],
    );
  }

  Widget _answerOption(Quiz question, int option) {
    final selected = _selected == option;
    final showCorrect = _selected != null && option == question.answer;
    final wrongSelection = selected && option != question.answer;
    final dark = isDark(context);
    final bg = showCorrect
        ? (dark ? const Color(0xFF173B30) : const Color(0xFFDFF5E5))
        : wrongSelection
            ? (dark ? const Color(0xFF47272D) : const Color(0xFFFFE1E1))
            : cardColor(context);
    final border = showCorrect
        ? C.green
        : wrongSelection
            ? C.red
            : const Color(0xFFB5D7F1);
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: _selected == null ? () => _choose(option) : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: border, width: showCorrect || wrongSelection ? 2 : 1),
            ),
            child: Row(children: [
              CircleAvatar(
                radius: 11,
                backgroundColor: showCorrect
                    ? C.green
                    : wrongSelection
                        ? C.red
                        : dark
                            ? const Color(0xFF263B5C)
                            : const Color(0xFFE5F2FF),
                child: Text(String.fromCharCode(65 + option),
                    style: TextStyle(
                        color: showCorrect || wrongSelection
                            ? Colors.white
                            : C.blue,
                        fontSize: 11,
                        fontWeight: FontWeight.w900)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                    question.optionsFor(AppScope.of(context).tagalog)[option],
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
              ),
              if (showCorrect)
                const Icon(Icons.check_circle_rounded,
                    color: C.green, size: 21),
              if (wrongSelection)
                const Icon(Icons.cancel_rounded, color: C.red, size: 21),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _feedback(Quiz question, List<String> explanations, bool correct) {
    final dark = isDark(context);
    final chosenExplanation = explanations[_selected!];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: correct
            ? (dark ? const Color(0xFF173B30) : const Color(0xFFE0F6E7))
            : (dark ? const Color(0xFF47272D) : const Color(0xFFFFEEEE)),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: correct ? C.green : C.red),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(correct ? Icons.check_circle : Icons.cancel,
              color: correct ? C.green : C.red, size: 21),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
                correct
                    ? 'Excellent! You got it right.'
                    : 'Almost! Review the concept and try again.',
                style: TextStyle(
                    color: correct ? const Color(0xFF14753D) : C.red,
                    fontWeight: FontWeight.w900)),
          ),
        ]),
        const SizedBox(height: 5),
        Text(chosenExplanation,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface, height: 1.25)),
        if (!correct) ...[
          const SizedBox(height: 6),
          Text(
            'Correct answer: ${String.fromCharCode(65 + question.answer)}. ${question.options[question.answer]}',
            style: TextStyle(
                color: dark ? const Color(0xFF83E5A8) : const Color(0xFF14753D),
                fontWeight: FontWeight.w800),
          ),
          Text(_choiceExplanations[_index]![question.answer],
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.25)),
        ],
      ]),
    );
  }

  Widget _resultView() {
    final percent = (_score * 100 / _questions.length).round();
    final label = percent >= 90
        ? 'Acceleration Master'
        : percent >= 80
            ? 'Great Job!'
            : percent >= 70
                ? 'Good Progress'
                : 'Keep Practicing';
    final color = percent >= 70 ? C.green : C.orange;
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
      children: [
        _brandHeader(),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF0A64C6), Color(0xFF063C91)]),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFFD64A), width: 3),
          ),
          child: Column(children: [
            const Text('WEEK 1 COMPLETE!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFFFFE33C),
                    fontSize: 25,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            const Icon(Icons.emoji_events_rounded,
                size: 74, color: Color(0xFFFFD54A)),
            const Text('🏁     🎉     🏁',
                style: TextStyle(fontSize: 25, height: 1.1)),
            const SizedBox(height: 5),
            Text('$_score / ${_questions.length}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900)),
            const Text('YOUR SCORE',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(13)),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('Acceleration Skills  ',
                    style:
                        TextStyle(color: C.navy, fontWeight: FontWeight.w800)),
                Text('$percent%',
                    style: TextStyle(
                        color: color,
                        fontSize: 21,
                        fontWeight: FontWeight.w900)),
              ]),
            ),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w900)),
            if (percent < 70)
              const Text('Review the Practice section and try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 8),
            const VehicleWidget(type: VehicleType.autoRickshaw, width: 145),
          ]),
        ),
        const SizedBox(height: 12),
        BigButton('TRY AGAIN',
            icon: Icons.refresh_rounded, color: C.orange, onTap: _retry),
        const SizedBox(height: 8),
        BigButton('BACK TO MENU',
            icon: Icons.home_rounded,
            color: C.blue,
            onTap: () => Navigator.of(context).pop()),
      ],
    );
  }
}
