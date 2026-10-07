import 'package:flutter/material.dart';
import '../data/content.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'result_screen.dart';

/// Solo quiz — same flow as the original Challenge.
class IndividualChallengeScreen extends StatefulWidget {
  const IndividualChallengeScreen({super.key});

  @override
  State<IndividualChallengeScreen> createState() =>
      _IndividualChallengeScreenState();
}

class _IndividualChallengeScreenState extends State<IndividualChallengeScreen> {
  int idx = 0;
  int score = 0;
  int? sel;
  final List<int> wrong = [];

  void _pick(int i) {
    if (sel != null) return;
    AppScope.of(context).click();
    setState(() {
      sel = i;
      if (i == quiz[idx].answer) {
        score++;
      } else {
        wrong.add(quiz[idx].lessonId);
      }
    });
  }

  void _next() {
    if (idx == quiz.length - 1) {
      final s = AppScope.of(context);
      s.recordChallenge(score);
      go(
        context,
        ResultScreen(
            score: score, total: quiz.length, wrong: List<int>.of(wrong)),
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
    final q = quiz[idx];
    final tagalog = AppScope.of(context).tagalog;
    final answered = sel != null;
    final correct = answered && sel == q.answer;

    return Scaffold(
      appBar: AppBar(
          title: Text(l10n(
              context, 'Acceleration Challenge', 'Hamon sa Akselerasyon'))),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 4),
          child: Column(children: [
            AnimatedBar(
                value: (idx + (answered ? 1 : 0)) / quiz.length,
                color: C.green),
            const SizedBox(height: 6),
            Text(
                l10n(context, 'Question ${idx + 1} of ${quiz.length}',
                    'Tanong ${idx + 1} sa ${quiz.length}'),
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
              idx == quiz.length - 1
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
