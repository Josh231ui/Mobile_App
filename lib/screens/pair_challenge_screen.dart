import 'package:flutter/material.dart';
import '../data/content.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Two players share one device: same questions, alternate turns, then compare.
class PairChallengeScreen extends StatefulWidget {
  const PairChallengeScreen({super.key});

  @override
  State<PairChallengeScreen> createState() => _PairChallengeScreenState();
}

enum _PairPhase { p1, p2, reveal, done }

class _PairChallengeScreenState extends State<PairChallengeScreen> {
  int idx = 0;
  int score1 = 0;
  int score2 = 0;
  int? sel1;
  int? sel2;
  _PairPhase phase = _PairPhase.p1;

  void _pick(int i) {
    if (phase == _PairPhase.reveal || phase == _PairPhase.done) return;
    AppScope.of(context).click();
    setState(() {
      if (phase == _PairPhase.p1) {
        sel1 = i;
        phase = _PairPhase.p2;
      } else if (phase == _PairPhase.p2) {
        sel2 = i;
        final q = quiz[idx];
        if (sel1 == q.answer) score1++;
        if (sel2 == q.answer) score2++;
        phase = _PairPhase.reveal;
      }
    });
  }

  void _next() {
    if (idx == quiz.length - 1) {
      setState(() => phase = _PairPhase.done);
      // Count toward challenge progress using the higher score.
      AppScope.of(context).recordChallenge(score1 > score2 ? score1 : score2);
    } else {
      setState(() {
        idx++;
        sel1 = null;
        sel2 = null;
        phase = _PairPhase.p1;
      });
    }
  }

  Widget _option(BuildContext context, Quiz q, int i) {
    final revealing = phase == _PairPhase.reveal;
    final answering = phase == _PairPhase.p1 || phase == _PairPhase.p2;
    final currentSel = phase == _PairPhase.p1 ? sel1 : sel2;

    Color bg = cardColor(context);
    Color? border;
    IconData? icon;

    if (revealing) {
      if (i == q.answer) {
        bg = C.green.withValues(alpha: 0.18);
        border = C.green;
        icon = Icons.check_circle;
      } else if (i == sel1 || i == sel2) {
        bg = C.red.withValues(alpha: 0.12);
        border = C.red;
      }
    } else if (answering && currentSel == i) {
      border = phase == _PairPhase.p1 ? C.blue : C.orange;
      bg = (phase == _PairPhase.p1 ? C.blue : C.orange).withValues(alpha: 0.12);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: answering ? () => _pick(i) : null,
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
            if (revealing) ...[
              if (sel1 == i)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: _miniBadge('1', C.blue),
                ),
              if (sel2 == i)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: _miniBadge('2', C.orange),
                ),
              if (icon != null) Icon(icon, color: border),
            ],
          ]),
        ),
      ),
    );
  }

  Widget _miniBadge(String label, Color color) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _turnBanner(BuildContext context) {
    if (phase == _PairPhase.done) return const SizedBox.shrink();

    late Color color;
    late String title;
    late String hint;

    switch (phase) {
      case _PairPhase.p1:
        color = C.blue;
        title = l10n(context, 'Player 1 — your turn', 'Manlalaro 1 — ikaw na');
        hint = l10n(context, 'Choose an answer, then pass the device.',
            'Pumili ng sagot, tapos ipasa ang device.');
        break;
      case _PairPhase.p2:
        color = C.orange;
        title = l10n(context, 'Player 2 — your turn', 'Manlalaro 2 — ikaw na');
        hint = l10n(context, 'Player 1 answered. Now you choose.',
            'Sumagot na si Manlalaro 1. Ikaw naman.');
        break;
      case _PairPhase.reveal:
        color = C.green;
        title = l10n(context, 'Results for this question',
            'Resulta ng tanong na ito');
        hint = '';
        break;
      case _PairPhase.done:
        break;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(18, 10, 18, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: color, fontSize: 15)),
        if (hint.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(hint, style: TextStyle(color: subText(context), fontSize: 13)),
        ],
        if (phase == _PairPhase.reveal) ...[
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
                child: Text(
                    '${l10n(context, 'Player 1', 'Manlalaro 1')}: ${sel1 == quiz[idx].answer ? l10n(context, 'Correct', 'Tama') : l10n(context, 'Incorrect', 'Mali')}',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: sel1 == quiz[idx].answer ? C.green : C.red))),
            Expanded(
                child: Text(
                    '${l10n(context, 'Player 2', 'Manlalaro 2')}: ${sel2 == quiz[idx].answer ? l10n(context, 'Correct', 'Tama') : l10n(context, 'Incorrect', 'Mali')}',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: sel2 == quiz[idx].answer ? C.green : C.red))),
          ]),
        ],
      ]),
    );
  }

  Widget _scoreBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
      child: Row(children: [
        Expanded(
          child: _ScoreChip(
            label: l10n(context, 'Player 1', 'Manlalaro 1'),
            score: score1,
            color: C.blue,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ScoreChip(
            label: l10n(context, 'Player 2', 'Manlalaro 2'),
            score: score2,
            color: C.orange,
          ),
        ),
      ]),
    );
  }

  Widget _doneView(BuildContext context) {
    final tie = score1 == score2;
    final p1Wins = score1 > score2;
    final winner = tie
        ? l10n(context, "It's a tie!", 'Tabla!')
        : p1Wins
            ? l10n(context, 'Player 1 wins!', 'Nanalo si Manlalaro 1!')
            : l10n(context, 'Player 2 wins!', 'Nanalo si Manlalaro 2!');

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Reveal(
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [C.navy, Color(0xFF14409A)],
              ),
            ),
            child: Column(children: [
              Text(l10n(context, 'Pair Result', 'Resulta ng Magkapareha'),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Icon(Icons.emoji_events, color: C.yellow, size: 72),
              const SizedBox(height: 10),
              Text(winner,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                  child: _finalScore(
                      l10n(context, 'Player 1', 'Manlalaro 1'),
                      score1,
                      C.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _finalScore(
                      l10n(context, 'Player 2', 'Manlalaro 2'),
                      score2,
                      C.orange),
                ),
              ]),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        BigButton(l10n(context, 'PLAY AGAIN', 'MAGLARO MULI'),
            color: C.orange,
            onTap: () => goReplace(context, const PairChallengeScreen())),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(
              l10n(context, 'BACK TO MODES', 'BUMALIK SA MGA URI'),
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _finalScore(String label, int score, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.7), width: 2),
      ),
      child: Column(children: [
        Text(label,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 4),
        Text('$score / ${quiz.length}',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (phase == _PairPhase.done) {
      return Scaffold(
        appBar: AppBar(
            title: Text(l10n(context, 'PAIR', 'MAGKAPAREHA'))),
        body: _doneView(context),
      );
    }

    final q = quiz[idx];
    final tagalog = AppScope.of(context).tagalog;

    return Scaffold(
      appBar: AppBar(
          title: Text(l10n(context, 'PAIR', 'MAGKAPAREHA'))),
      body: Column(children: [
        _scoreBar(context),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
          child: Column(children: [
            AnimatedBar(
                value: (idx + (phase == _PairPhase.reveal ? 1 : 0)) /
                    quiz.length,
                color: C.orange),
            const SizedBox(height: 6),
            Text(
                l10n(context, 'Question ${idx + 1} of ${quiz.length}',
                    'Tanong ${idx + 1} sa ${quiz.length}'),
                style: TextStyle(color: subText(context))),
          ]),
        ),
        _turnBanner(context),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            child: ListView(
              key: ValueKey('$idx-$phase'),
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
                if (phase == _PairPhase.reveal)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: C.green.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(q.whyFor(tagalog),
                        style: const TextStyle(height: 1.4)),
                  ),
              ],
            ),
          ),
        ),
        if (phase == _PairPhase.reveal)
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
              child: BigButton(
                idx == quiz.length - 1
                    ? l10n(context, 'SEE RESULTS', 'TINGNAN ANG RESULTA')
                    : l10n(context, 'NEXT →', 'SUSUNOD →'),
                color: C.orange,
                onTap: _next,
              ),
            ),
          ),
      ]),
    );
  }
}

class _ScoreChip extends StatelessWidget {
  final String label;
  final int score;
  final Color color;
  const _ScoreChip(
      {required this.label, required this.score, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: color, fontSize: 13)),
          Text('$score',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: color, fontSize: 18)),
        ],
      ),
    );
  }
}
