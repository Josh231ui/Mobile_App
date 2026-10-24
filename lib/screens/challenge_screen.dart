import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'classroom_challenge_screen.dart';
import 'individual_challenge_screen.dart';
import 'pair_challenge_screen.dart';

/// Challenge tab entry: pick Individual, Pair, or Classroom mode.
class ChallengeScreen extends StatelessWidget {
  final int? sessionId;
  const ChallengeScreen({super.key, this.sessionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n(context, 'Challenge', 'Hamon')),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          children: [
            Reveal(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Text(
                  l10n(context, 'Choose Game Mode:', 'Pumili ng Uri ng Laro:'),
                  style: TextStyle(color: subText(context), fontSize: 15),
                ),
              ),
            ),
            Reveal(
              index: 1,
              child: _ModeCard(
                emoji: '📱',
                title: l10n(context, 'INDIVIDUAL', 'INDIBIDWAL'),
                subtitle: l10n(context, 'Play on your own device',
                    'Maglaro sa sarili mong device'),
                color: C.blue,
                onTap: () {
                  AppScope.of(context).click();
                  go(context, IndividualChallengeScreen(
                      sessionId: sessionId, stageTitle: 'Challenge'));
                },
              ),
            ),
            const SizedBox(height: 12),
            Reveal(
              index: 2,
              child: _ModeCard(
                emoji: '👥',
                title: l10n(context, 'PAIR', 'MAGKAPAREHA'),
                subtitle: l10n(context, 'Share one device',
                    'Magbahagi sa isang device'),
                color: C.orange,
                onTap: () {
                  AppScope.of(context).click();
                  go(context, PairChallengeScreen(sessionId: sessionId));
                },
              ),
            ),
            const SizedBox(height: 12),
            Reveal(
              index: 3,
              child: _ModeCard(
                emoji: '🏫',
                title: l10n(context, 'CLASSROOM', 'SILID-ARALAN'),
                subtitle: l10n(
                  context,
                  'Teacher projects the game\nTeams answer using cards',
                  'Ipapakita ng guro ang laro\nSasagot ang mga grupo gamit ang card',
                ),
                color: C.teal,
                onTap: () {
                  AppScope.of(context).click();
                  go(context, ClassroomChallengeScreen(sessionId: sessionId));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ModeCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cardColor(context),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withValues(alpha: 0.35), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 28)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: color)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: TextStyle(
                            color: subText(context),
                            height: 1.35,
                            fontSize: 14)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
