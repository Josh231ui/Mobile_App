import 'dart:math';

import 'package:flutter/material.dart';
import '../data/content.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/session_page_navigation.dart';
import 'result_screen.dart';
import 'session_one_quiz_screen.dart';

/// Solo quiz — same flow as the original Challenge.
class IndividualChallengeScreen extends StatefulWidget {
  final int? sessionId;
  final String? stageTitle;
  final String? avoidFirstQuestion;
  const IndividualChallengeScreen({
    super.key,
    this.sessionId,
    this.stageTitle,
    this.avoidFirstQuestion,
  });

  @override
  State<IndividualChallengeScreen> createState() =>
      _IndividualChallengeScreenState();
}

class _IndividualChallengeScreenState extends State<IndividualChallengeScreen> {
  late final List<Quiz> _questions;
  int idx = 0;
  int score = 0;
  int? sel;
  final List<int> wrong = [];
  List<Quiz> get questions => _questions;

  bool get _shuffleSessionOneQuiz =>
      widget.sessionId == 1 && widget.stageTitle == 'Quiz';

  @override
  void initState() {
    super.initState();
    _questions = List<Quiz>.of(widget.sessionId == null
        ? quiz
        : sessionQuizzes[widget.sessionId] ?? quiz);
    if (_shuffleSessionOneQuiz) {
      _questions.shuffle(Random());
      final previousFirst = widget.avoidFirstQuestion;
      if (previousFirst != null &&
          _questions.length > 1 &&
          _questions.first.q == previousFirst) {
        final differentFirst =
            _questions.indexWhere((question) => question.q != previousFirst);
        final question = _questions.removeAt(differentFirst);
        _questions.insert(0, question);
      }
    }
  }

  void _pick(int i) {
    if (sel != null) return;
    AppScope.of(context).click();
    setState(() {
      sel = i;
      if (i == questions[idx].answer) {
        score++;
      } else {
        wrong.add(questions[idx].lessonId);
      }
    });
  }

  void _next() {
    if (idx == questions.length - 1) {
      final s = AppScope.of(context);
      s.recordChallenge(score, total: questions.length);
      if (widget.sessionId != null && widget.stageTitle == 'Quiz') {
        s.completeLesson(widget.sessionId!);
      }
      go(
        context,
        ResultScreen(
            score: score,
            total: questions.length,
            wrong: List<int>.of(wrong),
            sessionId: widget.sessionId,
            stageTitle: widget.stageTitle,
            firstQuestion: _shuffleSessionOneQuiz ? questions.first.q : null),
      );
    } else {
      setState(() {
        idx++;
        sel = null;
      });
    }
  }

  Widget _option(BuildContext context, Quiz q, int i) {
    Color bg = cardColor(context);
    Color? border;
    IconData? icon;
    if (sel != null) {
      if (i == q.answer) {
        bg = C.green.withValues(alpha: 0.18);
        border = C.green;
        icon = Icons.check_circle;
      } else if (i == sel) {
        bg = C.red.withValues(alpha: 0.15);
        border = C.red;
        icon = Icons.cancel;
      }
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => _pick(i),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color:
                  border ?? (isDark(context) ? Colors.white12 : Colors.black12),
              width: border == null ? 1 : 2,
            ),
          ),
          child: Row(children: [
            Text('${String.fromCharCode(65 + i)}.',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(width: 10),
            Expanded(
                child: Text(q.optionsFor(AppScope.of(context).tagalog)[i],
                    style: const TextStyle(fontSize: 16))),
            if (icon != null) Icon(icon, color: border),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sessionId == 1 && widget.stageTitle == 'Quiz') {
      return const SessionOneQuizScreen();
    }
    if (widget.sessionId == 7 && widget.stageTitle == 'Quiz') {
      return const _SessionSevenQuizScreen();
    }
    if (widget.sessionId == 8 && widget.stageTitle == 'Quiz') {
      return const _SessionEightQuizScreen();
    }
    final q = questions[idx];
    final tagalog = AppScope.of(context).tagalog;
    final answered = sel != null;
    final correct = answered && sel == q.answer;

    return Scaffold(
      appBar: AppBar(
          title: Text(l10n(
              context,
              widget.sessionId == null
                  ? 'Acceleration Challenge'
                  : 'Session ${widget.sessionId} ${widget.stageTitle ?? 'Quiz'}',
              widget.sessionId == null
                  ? 'Hamon sa Akselerasyon'
                  : 'Sesyon ${widget.sessionId}: ${widget.stageTitle ?? 'Pagsusulit'}'))),
      bottomNavigationBar: widget.sessionId == null
          ? null
          : SessionPageNavigationBar(
              sessionId: widget.sessionId!,
              currentPage: widget.stageTitle == 'Challenge'
                  ? SessionPage.challenge
                  : SessionPage.quiz,
            ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 4),
          child: Column(children: [
            AnimatedBar(
                value: (idx + (answered ? 1 : 0)) / questions.length,
                color: C.green),
            const SizedBox(height: 6),
            Text(
                l10n(context, 'Question ${idx + 1} of ${questions.length}',
                    'Tanong ${idx + 1} sa ${questions.length}'),
                style: TextStyle(color: subText(context))),
          ]),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                        begin: const Offset(0.15, 0), end: Offset.zero)
                    .animate(anim),
                child: child,
              ),
            ),
            child: ListView(
              key: ValueKey(idx),
              padding: const EdgeInsets.all(18),
              children: [
                Text(q.questionFor(tagalog),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.4)),
                const SizedBox(height: 16),
                for (int i = 0; i < q.options.length; i++)
                  _option(context, q, i),
                if (answered)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color:
                          (correct ? C.green : C.red).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              correct
                                  ? l10n(context, 'Correct!', 'Tama!')
                                  : l10n(
                                      context, 'Not quite.', 'Hindi pa tama.'),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: correct ? C.green : C.red)),
                          const SizedBox(height: 4),
                          Text(q.whyFor(tagalog),
                              style: const TextStyle(height: 1.4)),
                        ]),
                  ),
              ],
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
            child: BigButton(
              idx == questions.length - 1
                  ? l10n(context, 'FINISH', 'TAPUSIN')
                  : l10n(context, 'NEXT →', 'SUSUNOD →'),
              color: C.orange,
              onTap: answered ? _next : null,
            ),
          ),
        ),
      ]),
    );
  }
}

class _SessionSevenQuizScreen extends StatefulWidget {
  const _SessionSevenQuizScreen();

  @override
  State<_SessionSevenQuizScreen> createState() =>
      _SessionSevenQuizScreenState();
}

class _SessionSevenQuizScreenState extends State<_SessionSevenQuizScreen> {
  final Map<int, int> _answers = {};
  List<Quiz> get _questions => sessionQuizzes[7]!;

  static const _vehicles = ['🏍️', '🚌', '🚴', '⚽', '✈️'];

  void _pick(int questionIndex, int option) {
    if (_answers.containsKey(questionIndex)) return;
    AppScope.of(context).click();
    setState(() => _answers[questionIndex] = option);
  }

  void _finish() {
    final score = _answers.entries
        .where((entry) => _questions[entry.key].answer == entry.value)
        .length;
    final wrong = _answers.entries
        .where((entry) => _questions[entry.key].answer != entry.value)
        .map((entry) => _questions[entry.key].lessonId)
        .toList();
    final state = AppScope.of(context);
    state.recordChallenge(score, total: _questions.length);
    state.completeLesson(7);
    go(
      context,
      ResultScreen(
        score: score,
        total: _questions.length,
        wrong: wrong,
        sessionId: 7,
        stageTitle: 'Quiz',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tagalog = AppScope.of(context).tagalog;
    final done = _answers.length == _questions.length;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n(context, 'Session 7 · Quiz', 'Sesyon 7 · Pagsusulit')),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0874E2), Color(0xFF064295)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(9, 9, 9, 14),
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF087BEA), Color(0xFF14B7E8)]),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Row(children: [
                const Icon(Icons.quiz_rounded,
                    color: Color(0xFFFFD941), size: 31),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            l10n(context, 'QUIZ: Real-Life Acceleration',
                                'PAGSUSULIT: Akselerasyon sa Tunay na Buhay'),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                height: 1.05)),
                        Text(
                            l10n(
                                context,
                                'Read each question carefully and choose the best answer.',
                                'Basahing mabuti ang bawat tanong at piliin ang pinakamahusay na sagot.'),
                            style: const TextStyle(
                                color: C.navy,
                                fontSize: 10,
                                fontWeight: FontWeight.w800)),
                      ]),
                ),
              ]),
            ),
            const SizedBox(height: 7),
            Row(children: [
              Expanded(
                child: AnimatedBar(
                  value: _answers.length / _questions.length,
                  color: C.green,
                ),
              ),
              const SizedBox(width: 8),
              Text('${_answers.length}/${_questions.length}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 12)),
            ]),
            const SizedBox(height: 7),
            for (var i = 0; i < _questions.length; i++)
              _questionCard(context, i, tagalog),
            Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF0757A9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flag_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Icon(Icons.emoji_events_rounded,
                        color: Color(0xFFFFD343), size: 29),
                  ]),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 8),
            child: BigButton(
              done
                  ? l10n(context, 'FINISH QUIZ', 'TAPUSIN ANG PAGSUSULIT')
                  : l10n(context, 'ANSWER ALL QUESTIONS', 'SAGUTIN LAHAT'),
              color: C.orange,
              onTap: done ? _finish : null,
            ),
          ),
        ),
        const SessionPageNavigationBar(
          sessionId: 7,
          currentPage: SessionPage.quiz,
        ),
      ]),
    );
  }

  Widget _questionCard(BuildContext context, int index, bool tagalog) {
    final question = _questions[index];
    final selected = _answers[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF78D9F4), width: 1.5),
        boxShadow: const [
          BoxShadow(
              color: Color(0x33002F72), blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Column(children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 27,
            height: 27,
            alignment: Alignment.center,
            decoration:
                const BoxDecoration(color: C.blue, shape: BoxShape.circle),
            child: Text('${index + 1}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w900)),
          ),
          const SizedBox(width: 6),
          Container(
            width: 67,
            height: 57,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF7FD),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(_vehicles[index], style: const TextStyle(fontSize: 38)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(question.questionFor(tagalog),
                style: const TextStyle(
                    color: C.navy,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    height: 1.18)),
          ),
        ]),
        const SizedBox(height: 6),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: question.options.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 5,
              mainAxisExtent: 42),
          itemBuilder: (context, option) => _answerButton(
              context, question, index, option, selected, tagalog),
        ),
        if (selected != null) ...[
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              selected == question.answer
                  ? l10n(context, 'Correct! ${question.whyFor(tagalog)}',
                      'Tama! ${question.whyFor(true)}')
                  : l10n(context, 'Review: ${question.whyFor(tagalog)}',
                      'Paliwanag: ${question.whyFor(true)}'),
              style: TextStyle(
                  color: selected == question.answer
                      ? const Color(0xFF16834F)
                      : const Color(0xFF9B5B19),
                  fontSize: 9,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ]),
    );
  }

  Widget _answerButton(BuildContext context, Quiz question, int questionIndex,
      int option, int? selected, bool tagalog) {
    final isAnswer = option == question.answer;
    final isSelected = option == selected;
    final background = selected == null
        ? const Color(0xFFF1F8FF)
        : isAnswer
            ? const Color(0xFFDDF5E5)
            : isSelected
                ? const Color(0xFFFFE2E4)
                : const Color(0xFFF1F8FF);
    final letterColor = [C.blue, C.orange, C.green, C.purple][option % 4];
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: selected == null ? () => _pick(questionIndex, option) : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected != null && (isAnswer || isSelected)
                  ? isAnswer
                      ? C.green
                      : C.red
                  : const Color(0xFFD4E0ED),
            ),
          ),
          child: Row(children: [
            CircleAvatar(
              radius: 9,
              backgroundColor: letterColor,
              child: Text(String.fromCharCode(65 + option),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(question.optionsFor(tagalog)[option],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: C.navy,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      height: 1.05)),
            ),
            if (selected != null && isAnswer)
              const Icon(Icons.check_circle, color: C.green, size: 13),
            if (selected != null && isSelected && !isAnswer)
              const Icon(Icons.cancel, color: C.red, size: 13),
          ]),
        ),
      ),
    );
  }
}

class _SessionEightQuizScreen extends StatefulWidget {
  const _SessionEightQuizScreen();

  @override
  State<_SessionEightQuizScreen> createState() =>
      _SessionEightQuizScreenState();
}

class _SessionEightQuizScreenState extends State<_SessionEightQuizScreen> {
  final Map<int, int> _answers = {};
  List<Quiz> get _questions => sessionQuizzes[8]!;

  static const _vehicles = [
    VehicleType.car,
    VehicleType.car,
    null,
    VehicleType.motorcycle,
    null,
    null,
    null,
    null,
    VehicleType.train,
    null,
  ];

  void _pick(int questionIndex, int option) {
    if (_answers.containsKey(questionIndex)) return;
    AppScope.of(context).click();
    setState(() => _answers[questionIndex] = option);
  }

  void _finish() {
    final score = _answers.entries
        .where((entry) => _questions[entry.key].answer == entry.value)
        .length;
    final wrong = _answers.entries
        .where((entry) => _questions[entry.key].answer != entry.value)
        .map((entry) => _questions[entry.key].lessonId)
        .toList();
    final state = AppScope.of(context);
    state.recordChallenge(score, total: _questions.length);
    state.completeLesson(8);
    go(
      context,
      ResultScreen(
        score: score,
        total: _questions.length,
        wrong: wrong,
        sessionId: 8,
        stageTitle: 'Quiz',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tagalog = AppScope.of(context).tagalog;
    final done = _answers.length == _questions.length;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n(context, 'Session 8 · Final Quiz',
            'Sesyon 8 · Pinal na Pagsusulit')),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0874E2), Color(0xFF063D88)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(9, 9, 9, 12),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF087BEA), Color(0xFF11B9E7)]),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x55002055),
                      blurRadius: 5,
                      offset: Offset(0, 3))
                ],
              ),
              child: Row(children: [
                const Icon(Icons.emoji_events_rounded,
                    color: Color(0xFFFFD83D), size: 36),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n(context, 'FINAL QUIZ', 'PINAL NA PAGSUSULIT'),
                          style: const TextStyle(
                              color: Color(0xFFFFEB27),
                              fontSize: 19,
                              height: 1,
                              fontWeight: FontWeight.w900,
                              shadows: [
                                Shadow(
                                    color: Color(0xFF173B82),
                                    offset: Offset(1, 2),
                                    blurRadius: 1)
                              ])),
                      Text(
                          l10n(context, 'ACCELERATION MASTERY',
                              'PAGKAKAUNAWA SA AKSELERASYON'),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              height: 1.05,
                              fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7C9),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: const Color(0xFFFFC844), width: 1.5),
              ),
              child: Text(
                l10n(
                    context,
                    'Choose the best answer. Write the letter of the correct answer.',
                    'Piliin ang pinakamahusay na sagot. Isulat ang titik ng tamang sagot.'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: C.navy, fontSize: 10, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 6),
            Row(children: [
              Expanded(
                child: Container(
                  height: 25,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      color: const Color(0xFF073978),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(children: [
                    const Icon(Icons.star_rounded,
                        color: Color(0xFFFFD83D), size: 17),
                    const SizedBox(width: 4),
                    Text(l10n(context, 'SCORE', 'ISKOR'),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800)),
                    const Spacer(),
                    Text(
                        '${_answers.entries.where((entry) => _questions[entry.key].answer == entry.value).length}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900)),
                  ]),
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Container(
                  height: 25,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      color: const Color(0xFF073978),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(children: [
                    const Icon(Icons.check_circle_rounded,
                        color: Color(0xFF61E595), size: 15),
                    const SizedBox(width: 4),
                    Text(l10n(context, 'ANSWERED', 'NASAGUTAN'),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800)),
                    const Spacer(),
                    Text('${_answers.length}/${_questions.length}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w900)),
                  ]),
                ),
              ),
            ]),
            const SizedBox(height: 6),
            LayoutBuilder(builder: (context, constraints) {
              final columns = constraints.maxWidth < 330 ? 1 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _questions.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  mainAxisExtent: columns == 1 ? 202 : 190,
                ),
                itemBuilder: (context, index) =>
                    _questionCard(context, index, tagalog),
              );
            }),
            Container(
              margin: const EdgeInsets.only(top: 3),
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: const Color(0xFF073978),
                  borderRadius: BorderRadius.circular(10)),
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flag_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 5),
                    Icon(Icons.emoji_events_rounded,
                        color: Color(0xFFFFD83D), size: 22),
                  ]),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 8),
            child: BigButton(
              done
                  ? l10n(context, 'FINISH QUIZ', 'TAPUSIN ANG PAGSUSULIT')
                  : l10n(context, 'ANSWER ALL QUESTIONS', 'SAGUTIN LAHAT'),
              color: C.orange,
              onTap: done ? _finish : null,
            ),
          ),
        ),
        const SessionPageNavigationBar(
          sessionId: 8,
          currentPage: SessionPage.quiz,
        ),
      ]),
    );
  }

  Widget _questionCard(BuildContext context, int index, bool tagalog) {
    final question = _questions[index];
    final selected = _answers[index];
    final accent = [C.red, C.blue, C.green, C.purple, C.orange][index % 5];
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF1),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: accent, width: 1.4),
        boxShadow: const [
          BoxShadow(
              color: Color(0x33002055), blurRadius: 3, offset: Offset(0, 2))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CircleAvatar(
              radius: 11,
              backgroundColor: accent,
              child: Text('${index + 1}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w900))),
          const SizedBox(width: 4),
          Expanded(
            child: Text(question.questionFor(tagalog),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: C.navy,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    height: 1.12)),
          ),
        ]),
        if (_vehicles[index] != null || [2, 4, 5, 6, 7, 9].contains(index)) ...[
          const SizedBox(height: 3),
          SizedBox(
            height: index == 5 ? 54 : 42,
            child: Center(
              child: _vehicles[index] != null
                  ? VehicleWidget(type: _vehicles[index]!, width: 62)
                  : _illustration(index, accent),
            ),
          ),
        ],
        const Spacer(),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: question.options.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 3,
              mainAxisExtent: 30),
          itemBuilder: (context, option) {
            final isSelected = selected == option;
            final isCorrect = selected != null && option == question.answer;
            final bg = selected == null
                ? const Color(0xFFFFF1B8)
                : isCorrect
                    ? const Color(0xFFD9F5E1)
                    : isSelected
                        ? const Color(0xFFFFD8D8)
                        : const Color(0xFFFFF1B8);
            final letterColor = [C.blue, C.orange, C.green, C.red][option % 4];
            return Material(
              color: bg,
              borderRadius: BorderRadius.circular(7),
              child: InkWell(
                onTap: selected == null ? () => _pick(index, option) : null,
                borderRadius: BorderRadius.circular(7),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                        color: isCorrect
                            ? C.green
                            : isSelected
                                ? C.red
                                : const Color(0xFFE1C45E)),
                  ),
                  child: Row(children: [
                    CircleAvatar(
                        radius: 7,
                        backgroundColor: letterColor,
                        child: Text(String.fromCharCode(65 + option),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 7,
                                fontWeight: FontWeight.w900))),
                    const SizedBox(width: 3),
                    Expanded(
                        child: Text(question.optionsFor(tagalog)[option],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: C.navy,
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                height: 1.0))),
                  ]),
                ),
              ),
            );
          },
        ),
      ]),
    );
  }

  Widget _illustration(int index, Color accent) {
    if (index == 5) {
      return const SizedBox(
        width: 164,
        height: 54,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            VehicleWidget(type: VehicleType.car, width: 58),
            VehicleWidget(type: VehicleType.bicycle, width: 54),
            VehicleWidget(type: VehicleType.bus, width: 52),
          ],
        ),
      );
    }
    if (index == 6) {
      return const VehicleWidget(type: VehicleType.bicycle, width: 62);
    }
    if (index == 7) {
      return const VehicleWidget(type: VehicleType.car, width: 62);
    }
    return SizedBox(
      width: 58,
      height: 42,
      child: CustomPaint(
        painter: _QuizScienceIllustrationPainter(kind: index, color: accent),
      ),
    );
  }
}

class _QuizScienceIllustrationPainter extends CustomPainter {
  final int kind;
  final Color color;

  const _QuizScienceIllustrationPainter(
      {required this.kind, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final axis = Paint()
      ..color = const Color(0xFF425B78)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    final line = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    if (kind == 2) {
      final center = Offset(size.width * .53, size.height * .68);
      final radius = size.height * .42;
      canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius), pi, pi, false, line);
      canvas.drawLine(center,
          Offset(center.dx + radius * .58, center.dy - radius * .55), line);
      canvas.drawCircle(center, 2.2, Paint()..color = const Color(0xFF263B56));
      for (var tick = 0; tick <= 4; tick++) {
        final angle = pi + pi * tick / 4;
        final outer = Offset(
            center.dx + radius * cos(angle), center.dy + radius * sin(angle));
        final inner = Offset(center.dx + (radius - 3) * cos(angle),
            center.dy + (radius - 3) * sin(angle));
        canvas.drawLine(inner, outer, axis);
      }
      return;
    }

    const left = 4.0;
    final right = size.width - 3;
    const top = 3.0;
    final bottom = size.height - 3;
    canvas.drawLine(const Offset(left, top), Offset(left, bottom), axis);
    canvas.drawLine(Offset(left, bottom), Offset(right, bottom), axis);
    final startY = kind == 9 ? top + 2 : bottom - size.height * .42;
    final endY = kind == 4
        ? startY
        : kind == 9
            ? bottom - 2
            : top + 4;
    final path = Path()
      ..moveTo(left + 2, startY)
      ..lineTo(right - 2, endY);
    canvas.drawPath(path, line);
    canvas.drawCircle(Offset(right - 2, endY), 2.2, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_QuizScienceIllustrationPainter oldDelegate) =>
      oldDelegate.kind != kind || oldDelegate.color != color;
}
