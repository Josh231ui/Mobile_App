import 'package:flutter/material.dart';
import '../data/content.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'individual_challenge_screen.dart';
import 'lesson_screen.dart';
import 'review_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final List<int> wrong; // lesson ids for the questions answered wrong

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.wrong,
  });

  Lesson? get _recommended {
    if (wrong.isEmpty) return null;
    final counts = <int, int>{};
    for (final id in wrong) {
      counts[id] = (counts[id] ?? 0) + 1;
    }
    final best =
        counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    return lessons.firstWhere((l) => l.id == best);
  }

  String _message(bool tagalog) {
    final pct = score / total;
    if (tagalog) {
      if (pct == 1) return 'Perpektong iskor! 🎉';
      if (pct >= 0.8) return 'Magaling!';
      if (pct >= 0.5) return 'Mahusay na pagsisikap, magpatuloy!';
      return 'Patuloy na magsanay, kaya mo ito!';
    }
    if (pct == 1) return 'Perfect score! 🎉';
    if (pct >= 0.8) return 'Great job!';
    if (pct >= 0.5) return 'Good effort, keep going!';
    return 'Keep practicing, you can do it!';
  }

  Widget _statCard(String label, String value, Color color) {
    return Expanded(
      child: AppCard(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12, color: color, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pct = score / total;
    final rec = _recommended;
    final s = AppScope.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Reveal(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [C.navy, Color(0xFF14409A)],
                  ),
                ),
                child: Column(children: [
                  Text(l10n(context, 'Quiz Result', 'Resulta ng Pagsusulit'),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 1100),
                          curve: Curves.elasticOut,
                          builder: (_, v, child) =>
                              Transform.scale(scale: v, child: child),
                          child: const Icon(Icons.emoji_events,
                              color: C.yellow, size: 92),
                        ),
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: pct),
                          duration: const Duration(milliseconds: 1300),
                          curve: Curves.easeOutCubic,
                          builder: (_, v, __) => SizedBox(
                            width: 100,
                            height: 100,
                            child:
                                Stack(alignment: Alignment.center, children: [
                              SizedBox.expand(
                                child: CircularProgressIndicator(
                                  value: v,
                                  strokeWidth: 10,
                                  color: C.green,
                                  backgroundColor: Colors.white24,
                                ),
                              ),
                              Text('${(v * 100).round()}%',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                            ]),
                          ),
                        ),
                      ]),
                  const SizedBox(height: 12),
                  Text(
                      l10n(context, 'Score: $score/$total',
                          'Iskor: $score/$total'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Text(_message(s.tagalog),
                      style: const TextStyle(color: Colors.white70)),
                ]),
              ),
            ),
            const SizedBox(height: 14),
            Reveal(
              index: 1,
              child: Row(children: [
                _statCard(l10n(context, 'Correct', 'Tama'), '$score', C.green),
                const SizedBox(width: 10),
                _statCard(l10n(context, 'Incorrect', 'Mali'),
                    '${total - score}', C.red),
                const SizedBox(width: 10),
                _statCard(l10n(context, 'Percentage', 'Porsiyento'),
                    '${(pct * 100).round()}%', C.blue),
              ]),
            ),
            const SizedBox(height: 14),
            Reveal(
              index: 2,
              child: AppCard(
                child: rec == null
                    ? Text(
                        l10n(
                            context,
                            'No review needed. You got every question right!',
                            'Hindi na kailangang magbalik-aral. Tama ang lahat ng sagot mo!'),
                        style: TextStyle(fontWeight: FontWeight.w600))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(
                                l10n(context, 'Recommended Review:',
                                    'Inirerekomendang Balikan:'),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: subText(context))),
                            const SizedBox(height: 6),
                            Text(rec.titleFor(s.tagalog),
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            BigButton(l10n(context, 'REVIEW →', 'BALIKAN →'),
                                onTap: () =>
                                    go(context, LessonScreen(lesson: rec))),
                          ]),
              ),
            ),
            const SizedBox(height: 14),
            Reveal(
              index: 3,
              child: Row(children: [
                Expanded(
                  child: BigButton(l10n(context, 'TRY AGAIN', 'SUBUKAN MULI'),
                      onTap: () =>
                          goReplace(context, const IndividualChallengeScreen())),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: BigButton(
                      l10n(context, 'REVIEW LESSON', 'BALIKAN ANG ARALIN'),
                      color: C.yellow,
                      onTap: () => go(context, const ReviewScreen())),
                ),
              ]),
            ),
            const SizedBox(height: 10),
            Reveal(
              index: 4,
              child: OutlinedButton(
                onPressed: () =>
                    Navigator.of(context).popUntil((r) => r.isFirst),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                    l10n(context, 'BACK TO HOME',
                        'BUMALIK SA PANGUNAHING PAHINA'),
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
