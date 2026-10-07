import 'package:flutter/material.dart';
import '../data/content.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Teacher projects questions; teams answer with physical cards.
/// Teacher reveals the answer and can award points to teams.
class ClassroomChallengeScreen extends StatefulWidget {
  const ClassroomChallengeScreen({super.key});

  @override
  State<ClassroomChallengeScreen> createState() =>
      _ClassroomChallengeScreenState();
}

class _ClassroomChallengeScreenState extends State<ClassroomChallengeScreen> {
  int idx = 0;
  bool revealed = false;
  bool done = false;
  int teamA = 0;
  int teamB = 0;
  bool awardedA = false;
  bool awardedB = false;

  void _reveal() {
    AppScope.of(context).click();
    setState(() => revealed = true);
  }

  void _award(bool isA) {
    if (!revealed) return;
    setState(() {
      if (isA && !awardedA) {
        teamA++;
        awardedA = true;
      } else if (!isA && !awardedB) {
        teamB++;
        awardedB = true;
      }
    });
  }

  void _next() {
    if (idx == quiz.length - 1) {
      // Classroom is a projected group session — no personal score stored.
      setState(() => done = true);
    } else {
      setState(() {
        idx++;
        revealed = false;
        awardedA = false;
        awardedB = false;
      });
    }
  }

  Widget _optionTile(BuildContext context, Quiz q, int i) {
    final isAnswer = i == q.answer;
    final highlight = revealed && isAnswer;
    final letter = String.fromCharCode(65 + i);
    final color = highlight ? C.green : C.navy;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: highlight
            ? C.green.withValues(alpha: 0.18)
            : cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlight
              ? C.green
              : (isDark(context) ? Colors.white12 : Colors.black12),
          width: highlight ? 3 : 1,
        ),
      ),
      child: Row(children: [
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withValues(alpha: highlight ? 1 : 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(letter,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: highlight ? Colors.white : color,
              )),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            q.optionsFor(AppScope.of(context).tagalog)[i],
            style: TextStyle(
              fontSize: 18,
              fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
              height: 1.35,
            ),
          ),
        ),
        if (highlight) const Icon(Icons.check_circle, color: C.green, size: 28),
      ]),
    );
  }

  Widget _doneView(BuildContext context) {
    final tie = teamA == teamB;
    final aWins = teamA > teamB;
    final headline = tie
        ? l10n(context, "It's a tie!", 'Tabla!')
        : aWins
            ? l10n(context, 'Team A wins!', 'Nanalo ang Grupo A!')
            : l10n(context, 'Team B wins!', 'Nanalo ang Grupo B!');

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
                colors: [C.navy, Color(0xFF0E6B5C)],
              ),
            ),
            child: Column(children: [
              Text(l10n(context, 'Classroom Session', 'Sesyon sa Silid-aralan'),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Icon(Icons.school_rounded, color: C.yellow, size: 64),
              const SizedBox(height: 10),
              Text(headline,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                  l10n(context, '${quiz.length} questions reviewed',
                      '${quiz.length} tanong ang natalakay'),
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 18),
              Row(children: [
                Expanded(child: _teamFinal('A', teamA, C.blue)),
                const SizedBox(width: 12),
                Expanded(child: _teamFinal('B', teamB, C.orange)),
              ]),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        BigButton(l10n(context, 'PLAY AGAIN', 'MAGLARO MULI'),
            color: C.teal,
            onTap: () =>
                goReplace(context, const ClassroomChallengeScreen())),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(
              l10n(context, 'BACK TO MODES', 'BUMALIK SA MGA URI'),
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _teamFinal(String letter, int score, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.8), width: 2),
      ),
      child: Column(children: [
        Text('${l10n(context, 'Team', 'Grupo')} $letter',
            style: TextStyle(
                color: color, fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 4),
        Text('$score',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (done) {
      return Scaffold(
        appBar: AppBar(
            title: Text(l10n(context, 'CLASSROOM', 'SILID-ARALAN'))),
        body: _doneView(context),
      );
    }

    final q = quiz[idx];
    final tagalog = AppScope.of(context).tagalog;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n(context, 'CLASSROOM', 'SILID-ARALAN')),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                'A $teamA  ·  B $teamB',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, letterSpacing: 0.3),
              ),
            ),
          ),
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 4),
          child: Column(children: [
            AnimatedBar(
                value: (idx + (revealed ? 1 : 0)) / quiz.length, color: C.teal),
            const SizedBox(height: 6),
            Text(
                l10n(context, 'Question ${idx + 1} of ${quiz.length}',
                    'Tanong ${idx + 1} sa ${quiz.length}'),
                style: TextStyle(color: subText(context))),
            const SizedBox(height: 6),
            Text(
                l10n(
                    context,
                    'Teams: hold up your answer cards',
                    'Mga grupo: itaas ang inyong sagot na card'),
                style: TextStyle(
                    color: subText(context),
                    fontSize: 13,
                    fontStyle: FontStyle.italic)),
          ]),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Text(q.questionFor(tagalog),
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.35)),
              const SizedBox(height: 20),
              for (int i = 0; i < q.options.length; i++)
                _optionTile(context, q, i),
              if (revealed) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: C.green.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          l10n(
                              context,
                              'Answer: ${String.fromCharCode(65 + q.answer)}',
                              'Sagot: ${String.fromCharCode(65 + q.answer)}'),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: C.green,
                              fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(q.whyFor(tagalog),
                          style: const TextStyle(height: 1.4, fontSize: 15)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                    l10n(context, 'Award a point to teams that got it right:',
                        'Magbigay ng puntos sa mga grupong tama:'),
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: subText(context))),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                    child: BigButton(
                      awardedA
                          ? l10n(context, 'Team A ✓', 'Grupo A ✓')
                          : l10n(context, '+ Team A', '+ Grupo A'),
                      color: awardedA ? C.green : C.blue,
                      onTap: awardedA ? null : () => _award(true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: BigButton(
                      awardedB
                          ? l10n(context, 'Team B ✓', 'Grupo B ✓')
                          : l10n(context, '+ Team B', '+ Grupo B'),
                      color: awardedB ? C.green : C.orange,
                      onTap: awardedB ? null : () => _award(false),
                    ),
                  ),
                ]),
              ],
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
            child: revealed
                ? BigButton(
                    idx == quiz.length - 1
                        ? l10n(context, 'FINISH SESSION', 'TAPUSIN ANG SESYON')
                        : l10n(context, 'NEXT →', 'SUSUNOD →'),
                    color: C.teal,
                    onTap: _next,
                  )
                : BigButton(
                    l10n(context, 'REVEAL ANSWER', 'IPAKITA ANG SAGOT'),
                    color: C.orange,
                    onTap: _reveal,
                  ),
          ),
        ),
      ]),
    );
  }
}
