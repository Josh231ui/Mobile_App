import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../data/content.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/session_page_navigation.dart';
import 'individual_challenge_screen.dart';

/// Session 1 uses the three-level Acceleration Rush challenge; other sessions
/// use their question-based mission sequence.
class SessionChallengeScreen extends StatelessWidget {
  final int sessionId;
  const SessionChallengeScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) => sessionId == 1
      ? const AccelerationRushScreen()
      : sessionId == 7
          ? const TrafficMissionChallengeScreen()
          : _SessionQuizChallengeScreen(sessionId: sessionId);
}

class _AccelerationMission {
  final String title;
  final String prompt;
  final List<String> choices;
  final int answer;
  final String explanation;

  const _AccelerationMission({
    required this.title,
    required this.prompt,
    required this.choices,
    required this.answer,
    required this.explanation,
  });
}

const _sessionEightMissions = <_AccelerationMission>[
  _AccelerationMission(
    title: 'Acceleration Race',
    prompt:
        'A car changes from 5 m/s to 20 m/s in 5 seconds. What is its acceleration?',
    choices: ['3 m/s²', '4 m/s²', '5 m/s²', '6 m/s²'],
    answer: 0,
    explanation: 'a = (20 − 5) ÷ 5 = 3 m/s².',
  ),
  _AccelerationMission(
    title: 'Target Acceleration',
    prompt:
        'A car starts at 10 m/s and accelerates at 5 m/s² for 5 seconds. What is its final velocity?',
    choices: ['20 m/s', '25 m/s', '30 m/s', '35 m/s'],
    answer: 3,
    explanation: 'vf = vi + at = 10 + (5 × 5) = 35 m/s.',
  ),
  _AccelerationMission(
    title: 'Graph Builder',
    prompt:
        'Which velocity–time graph shows a car speeding up in the positive direction?',
    choices: [
      'An upward-sloping line',
      'A horizontal line',
      'A downward-sloping line'
    ],
    answer: 0,
    explanation:
        'An upward slope means velocity increases, so acceleration is positive.',
  ),
  _AccelerationMission(
    title: 'Traffic Challenge',
    prompt: 'The traffic light turns red. What should the driver do?',
    choices: ['Accelerate', 'Maintain speed', 'Brake and stop'],
    answer: 2,
    explanation: 'Brake and stop safely at a red light.',
  ),
  _AccelerationMission(
    title: 'Acceleration Quiz Battle',
    prompt: 'When does acceleration happen?',
    choices: [
      'When speed changes',
      'When direction changes',
      'When speed or direction changes',
      'Only when an object moves backward',
    ],
    answer: 2,
    explanation:
        'Acceleration happens whenever velocity changes, including a change in speed or direction.',
  ),
];

class SessionEightChallengeScreen extends StatefulWidget {
  const SessionEightChallengeScreen({super.key});

  @override
  State<SessionEightChallengeScreen> createState() =>
      _SessionEightChallengeScreenState();
}

class _SessionEightChallengeScreenState
    extends State<SessionEightChallengeScreen>
    with SingleTickerProviderStateMixin {
  final List<int?> _selections =
      List<int?>.filled(_sessionEightMissions.length, null);
  AnimationController? _visualAnimation;

  AnimationController get _animation =>
      _visualAnimation ??= AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2200),
      )..repeat();

  @override
  void dispose() {
    _visualAnimation?.dispose();
    super.dispose();
  }

  int get _completed => List.generate(_selections.length, (index) => index)
      .where(
          (index) => _selections[index] == _sessionEightMissions[index].answer)
      .length;

  @override
  Widget build(BuildContext context) {
    final allComplete = _completed == _sessionEightMissions.length;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n(context, 'Session 8 · Challenge', 'Sesyon 8 · Hamon')),
      ),
      bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
        SessionContinueBar(
          label: l10n(context, 'NEXT: QUIZ', 'SUSUNOD: PAGSUSULIT'),
          enabled: allComplete,
          onTap: () => go(
            context,
            IndividualChallengeScreen(sessionId: 8, stageTitle: 'Quiz'),
          ),
        ),
        const SessionPageNavigationBar(
          sessionId: 8,
          currentPage: SessionPage.challenge,
        ),
      ]),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xff0755ce), Color(0xff168df0)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(children: [
              const Icon(Icons.emoji_events_rounded, color: C.yellow, size: 30),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n(context, 'CHALLENGE: ACCELLAB MISSION',
                            'HAMON: MISYON NG ACCELLAB'),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 15),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        l10n(
                            context,
                            'Complete all 5 missions. Choose the correct answer.',
                            'Tapusin ang 5 misyon. Piliin ang tamang sagot.'),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ]),
              ),
            ]),
          ),
          const SizedBox(height: 8),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            color: C.blue.withValues(alpha: .08),
            child: Row(children: [
              const Icon(Icons.flag_rounded, color: C.orange),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  l10n(context, 'MISSIONS', 'MGA MISYON'),
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              Text('$_completed / ${_sessionEightMissions.length}',
                  style: const TextStyle(
                      color: C.blue, fontWeight: FontWeight.w900)),
            ]),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < _sessionEightMissions.length; i++) ...[
            _buildMission(context, i),
            if (i < _sessionEightMissions.length - 1) const SizedBox(height: 8),
          ],
          if (allComplete) ...[
            const SizedBox(height: 8),
            AppCard(
              color: C.green.withValues(alpha: .12),
              child: Row(children: [
                const Icon(Icons.emoji_events_rounded,
                    color: C.orange, size: 30),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    l10n(
                        context,
                        'Mission complete! You are an AccelLab acceleration master!',
                        'Tapos na ang misyon! Dalubhasa ka na sa akselerasyon!'),
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMission(BuildContext context, int index) {
    final mission = _sessionEightMissions[index];
    final selected = _selections[index];
    final isCorrect = selected == mission.answer;
    final colors = [C.red, C.blue, C.green, C.purple, C.orange];
    final color = colors[index];

    return AppCard(
      padding: const EdgeInsets.all(10),
      color: color.withValues(alpha: .07),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: color,
            child: Text('${index + 1}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w900)),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(mission.title,
                style: TextStyle(color: color, fontWeight: FontWeight.w900)),
          ),
          if (isCorrect)
            const Icon(Icons.check_circle_rounded, color: C.green, size: 20),
        ]),
        const SizedBox(height: 6),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            child: Text(mission.prompt,
                style: const TextStyle(fontSize: 12, height: 1.25)),
          ),
          const SizedBox(width: 7),
          _buildMissionVisual(index),
        ]),
        const SizedBox(height: 7),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (var choice = 0; choice < mission.choices.length; choice++)
              ChoiceChip(
                label: Text(mission.choices[choice]),
                selected: selected == choice,
                onSelected: (_) {
                  AppScope.of(context).click();
                  setState(() => _selections[index] = choice);
                },
                selectedColor: selected == choice
                    ? (isCorrect ? C.green : C.red).withValues(alpha: .2)
                    : null,
                labelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: selected == choice
                        ? (isCorrect ? C.green : C.red)
                        : null),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
          ],
        ),
        if (selected != null) ...[
          const SizedBox(height: 5),
          Text(
            isCorrect
                ? mission.explanation
                : l10n(context, 'Try again. Review the choices.',
                    'Subukan muli. Suriin ang mga pagpipilian.'),
            style: TextStyle(
                color: isCorrect ? C.green : C.red,
                fontSize: 11,
                fontWeight: FontWeight.w700),
          ),
        ],
      ]),
    );
  }

  Widget _buildMissionVisual(int index) {
    final animation = _animation;
    return Container(
      width: 90,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .85),
        borderRadius: BorderRadius.circular(9),
      ),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final phase = animation.value * math.pi * 2;
          final illustration = switch (index) {
            0 => Transform.translate(
                offset: Offset(math.sin(phase) * 4, 0),
                child: VehicleWidget(
                    type: VehicleType.car, width: 82, color: C.red),
              ),
            1 => Transform.translate(
                offset: Offset(math.sin(phase) * 4, 0),
                child: VehicleWidget(
                    type: VehicleType.car, width: 82, color: C.blue),
              ),
            2 => SizedBox(
                width: 80,
                height: 48,
                child: CustomPaint(
                    painter: _MissionGraphPainter(progress: animation.value)),
              ),
            3 => Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: const Color(0xff263746),
                      borderRadius: BorderRadius.circular(8)),
                  child:
                      const Column(mainAxisSize: MainAxisSize.min, children: [
                    _SignalLamp(color: C.red, active: true),
                    _SignalLamp(color: C.yellow),
                    _SignalLamp(color: C.green),
                  ]),
                ),
                const SizedBox(width: 5),
                Transform.rotate(
                  angle: math.sin(phase) * .14,
                  child: const Icon(Icons.turn_right_rounded,
                      color: C.orange, size: 25),
                ),
              ]),
            _ => Transform.translate(
                offset: Offset(0, math.sin(phase) * 2),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.directions_car_rounded, color: C.red, size: 21),
                  Icon(Icons.directions_bus_rounded, color: C.blue, size: 21),
                  Icon(Icons.pedal_bike_rounded, color: C.green, size: 21),
                ]),
              ),
          };
          return illustration;
        },
      ),
    );
  }
}

class _SignalLamp extends StatelessWidget {
  final Color color;
  final bool active;

  const _SignalLamp({required this.color, this.active = false});

  @override
  Widget build(BuildContext context) => Container(
        width: 9,
        height: 9,
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: active ? color : color.withValues(alpha: .25),
          boxShadow: active
              ? [BoxShadow(color: color.withValues(alpha: .6), blurRadius: 5)]
              : null,
        ),
      );
}

class _MissionGraphPainter extends CustomPainter {
  final double progress;

  const _MissionGraphPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final axes = Paint()
      ..color = const Color(0xff334155)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    final line = Paint()
      ..color = C.red
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final left = size.width * .12;
    final right = size.width * .90;
    final top = size.height * .12;
    final bottom = size.height * .82;
    canvas.drawLine(Offset(left, top), Offset(left, bottom), axes);
    canvas.drawLine(Offset(left, bottom), Offset(right, bottom), axes);
    final start = Offset(left + 5, bottom - 4);
    final end = Offset(right - 6, top + 5);
    final current = Offset.lerp(start, end, progress)!;
    canvas.drawLine(start, current, line);
    canvas.drawCircle(current, 3, Paint()..color = C.red);
  }

  @override
  bool shouldRepaint(covariant _MissionGraphPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _TrafficMission {
  final String situation;
  final String situationTl;
  final String correctAction;
  final String explanation;
  final String explanationTl;
  final IconData icon;
  const _TrafficMission({
    required this.situation,
    required this.situationTl,
    required this.correctAction,
    required this.explanation,
    required this.explanationTl,
    required this.icon,
  });
}

const _trafficMissions = <_TrafficMission>[
  _TrafficMission(
    situation: 'The traffic light turns RED. What should you do?',
    situationTl: 'NAGPULA ang ilaw-trapiko. Ano ang dapat mong gawin?',
    correctAction: 'brake',
    explanation: 'Correct! Brake and stop at the red light.',
    explanationTl: 'Tama! Magpreno at huminto sa pulang ilaw.',
    icon: Icons.traffic_rounded,
  ),
  _TrafficMission(
    situation: 'The road is clear. Increase your speed.',
    situationTl: 'Maluwag ang kalsada. Bilisan ang takbo.',
    correctAction: 'accelerate',
    explanation: 'Correct! The clear road is safe for accelerating.',
    explanationTl: 'Tama! Ligtas bumilis dahil maluwag ang kalsada.',
    icon: Icons.add_road_rounded,
  ),
  _TrafficMission(
    situation: 'Turn left at the corner. Watch for pedestrians.',
    situationTl: 'Kumaliwa sa kanto. Mag-ingat sa mga tumatawid.',
    correctAction: 'left',
    explanation:
        'Correct! Turning left changes the vehicle’s direction and velocity.',
    explanationTl:
        'Tama! Binabago ng pagliko sa kaliwa ang direksyon at velocity.',
    icon: Icons.turn_left_rounded,
  ),
  _TrafficMission(
    situation: 'A bus ahead is slowing down. What should you do?',
    situationTl: 'Bumabagal ang bus sa unahan. Ano ang dapat mong gawin?',
    correctAction: 'brake',
    explanation: 'Correct! Brake to slow down safely behind the bus.',
    explanationTl: 'Tama! Magpreno upang ligtas na bumagal sa likod ng bus.',
    icon: Icons.directions_bus_rounded,
  ),
  _TrafficMission(
    situation: 'There is an obstacle in the road. What should you do?',
    situationTl: 'May harang sa kalsada. Ano ang dapat mong gawin?',
    correctAction: 'brake',
    explanation: 'Correct! Brake to avoid the obstacle safely.',
    explanationTl: 'Tama! Magpreno upang ligtas na maiwasan ang harang.',
    icon: Icons.warning_rounded,
  ),
];

class TrafficMissionChallengeScreen extends StatefulWidget {
  const TrafficMissionChallengeScreen({super.key});

  @override
  State<TrafficMissionChallengeScreen> createState() =>
      _TrafficMissionChallengeScreenState();
}

class _TrafficMissionChallengeScreenState
    extends State<TrafficMissionChallengeScreen> {
  Timer? _timer;
  Timer? _feedbackTimer;
  int _secondsLeft = 60;
  int _lives = 3;
  int _score = 0;
  int _missionIndex = 0;
  int _correctCount = 0;
  double _speed = 20;
  double _lanePosition = 0;
  String _direction = 'east';
  String? _feedback;
  bool? _feedbackIsCorrect;
  bool _finished = false;
  bool _won = false;

  _TrafficMission get _mission => _trafficMissions[_missionIndex];
  int get _level => _missionIndex < 2
      ? 1
      : _missionIndex < 4
          ? 2
          : 3;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _finished) return;
      if (_secondsLeft <= 1) {
        setState(() => _secondsLeft = 0);
        _finish(false);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _feedbackTimer?.cancel();
    super.dispose();
  }

  void _act(String action) {
    if (_finished || _feedback != null) return;
    AppScope.of(context).click();
    setState(() {
      switch (action) {
        case 'accelerate':
          _speed += 5;
          break;
        case 'brake':
          _speed = (_speed - 8).clamp(0, 100).toDouble();
          break;
        case 'left':
          _lanePosition = (_lanePosition - .7).clamp(-1, 1).toDouble();
          _direction = 'west';
          break;
        case 'right':
          _lanePosition = (_lanePosition + .7).clamp(-1, 1).toDouble();
          _direction = 'east';
          break;
      }

      final correct = action == _mission.correctAction;
      _feedbackIsCorrect = correct;
      if (correct) {
        _score += 10;
        _correctCount++;
        _feedback = _mission.explanation;
      } else {
        _score = (_score - 5).clamp(0, 9999).toInt();
        _lives--;
        _feedback = 'Not quite. Try again: ${_mission.situation}';
      }
    });

    if (_lives <= 0) {
      _feedbackTimer = Timer(const Duration(milliseconds: 900), () {
        if (mounted) _finish(false);
      });
    } else if (_feedbackIsCorrect == true) {
      _feedbackTimer = Timer(const Duration(milliseconds: 950), () {
        if (!mounted || _finished) return;
        if (_missionIndex == _trafficMissions.length - 1) {
          _finish(true);
        } else {
          setState(() {
            _missionIndex++;
            _lanePosition = 0;
            _direction = 'east';
            _feedback = null;
            _feedbackIsCorrect = null;
          });
        }
      });
    } else {
      _feedbackTimer = Timer(const Duration(milliseconds: 1400), () {
        if (mounted && !_finished) {
          setState(() {
            _lanePosition = 0;
            _direction = 'east';
            _feedback = null;
            _feedbackIsCorrect = null;
          });
        }
      });
    }
  }

  void _finish(bool won) {
    if (_finished) return;
    _timer?.cancel();
    _feedbackTimer?.cancel();
    AppScope.of(context).recordChallenge(_correctCount, total: 5);
    setState(() {
      _lanePosition = 0;
      _direction = 'east';
      _finished = true;
      _won = won;
    });
  }

  void _restart() {
    _timer?.cancel();
    _feedbackTimer?.cancel();
    setState(() {
      _secondsLeft = 60;
      _lives = 3;
      _score = 0;
      _missionIndex = 0;
      _correctCount = 0;
      _speed = 20;
      _lanePosition = 0;
      _direction = 'east';
      _feedback = null;
      _feedbackIsCorrect = null;
      _finished = false;
      _won = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _finished) return;
      if (_secondsLeft <= 1) {
        setState(() => _secondsLeft = 0);
        _finish(false);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tagalog = AppScope.of(context).tagalog;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n(context, 'Session 7 · Challenge', 'Sesyon 7 · Hamon')),
      ),
      bottomNavigationBar: const SessionPageNavigationBar(
        sessionId: 7,
        currentPage: SessionPage.challenge,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F5FF), Color(0xFFC8E7FF)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 18),
          children: [
            _challengeHeader(context),
            const SizedBox(height: 8),
            _scoreboard(context),
            const SizedBox(height: 8),
            _currentScene(),
            const SizedBox(height: 8),
            _situationCard(tagalog),
            const SizedBox(height: 8),
            _actionButtons(context),
            if (_feedback != null) ...[
              const SizedBox(height: 7),
              _feedbackCard(tagalog),
            ],
            const SizedBox(height: 10),
            _missionStrip(context),
            const SizedBox(height: 9),
            _mechanicsAndLevels(context),
            if (_finished) ...[
              const SizedBox(height: 10),
              _resultPanel(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _challengeHeader(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF0873E6), Color(0xFF11B8E7)]),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Row(children: [
          const Icon(Icons.sports_esports_rounded,
              color: Color(0xFFFFD839), size: 32),
          const SizedBox(width: 8),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                  l10n(context, 'CHALLENGE: Traffic Challenge',
                      'HAMON: Hamon sa Trapiko'),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      height: 1.05)),
              Text(
                  l10n(
                      context,
                      'React to traffic situations and choose the correct action.',
                      'Tumugon sa mga sitwasyon sa kalsada at piliin ang tamang kilos.'),
                  style: const TextStyle(
                      color: C.navy,
                      fontSize: 10,
                      fontWeight: FontWeight.w800)),
            ]),
          ),
        ]),
      );

  Widget _scoreboard(BuildContext context) => Row(children: [
        Expanded(
          child: _scoreBox(
            icon: Icons.star_rounded,
            label: 'SCORE',
            value: '$_score',
            color: C.blue,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: _scoreBox(
            icon: Icons.favorite_rounded,
            label: 'LIVES',
            value: '♥' * _lives,
            color: C.red,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: _scoreBox(
            icon: Icons.timer_rounded,
            label: 'TIME',
            value: '$_secondsLeft s',
            color: _secondsLeft <= 10 ? C.red : C.navy,
          ),
        ),
      ]);

  Widget _scoreBox({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(11),
          boxShadow: const [
            BoxShadow(
                color: Color(0x330B1F4B), blurRadius: 4, offset: Offset(0, 2))
          ],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: Colors.white, size: 17),
          const SizedBox(width: 4),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 8,
                    fontWeight: FontWeight.w900)),
            Text(value,
                maxLines: 1,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w900)),
          ]),
        ]),
      );

  Widget _currentScene() => Container(
        height: 205,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [
            BoxShadow(
                color: Color(0x330B1F4B), blurRadius: 6, offset: Offset(0, 3))
          ],
        ),
        child: Stack(children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _TrafficScenePainter(missionIndex: _missionIndex),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            alignment: Alignment(_lanePosition * .58, .65),
            child: const SizedBox(
              width: 96,
              height: 68,
              child: CustomPaint(painter: _PlayerCarPainter()),
            ),
          ),
          Positioned(
            left: 8,
            bottom: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                  color: C.navy.withValues(alpha: .8),
                  borderRadius: BorderRadius.circular(7)),
              child: Text('$_speed m/s · $_direction',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900)),
            ),
          ),
        ]),
      );

  Widget _situationCard(bool tagalog) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: C.red.withValues(alpha: .65), width: 1.5),
      ),
      child: Row(children: [
        Icon(_mission.icon, color: C.red, size: 29),
        const SizedBox(width: 8),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
                l10n(
                    context,
                    'CURRENT SITUATION · MISSION ${_missionIndex + 1}',
                    'KASALUKUYANG SITWASYON · MISYON ${_missionIndex + 1}'),
                style: const TextStyle(
                    color: C.red, fontSize: 10, fontWeight: FontWeight.w900)),
            Text(tagalog ? _mission.situationTl : _mission.situation,
                style: const TextStyle(
                    color: C.navy, fontSize: 13, fontWeight: FontWeight.w800)),
          ]),
        ),
      ]),
    );
  }

  Widget _actionButtons(BuildContext context) => Row(children: [
        _gameButton(context, 'ACCELERATE', 'BUMILIS', Icons.bolt_rounded,
            C.green, 'accelerate'),
        const SizedBox(width: 4),
        _gameButton(context, 'BRAKE', 'PRENO', Icons.stop_circle_rounded, C.red,
            'brake'),
        const SizedBox(width: 4),
        _gameButton(context, 'TURN LEFT', 'KALIWA', Icons.turn_left_rounded,
            C.blue, 'left'),
        const SizedBox(width: 4),
        _gameButton(context, 'TURN RIGHT', 'KANAN', Icons.turn_right_rounded,
            C.orange, 'right'),
      ]);

  Widget _gameButton(BuildContext context, String title, String titleTl,
          IconData icon, Color color, String action) =>
      Expanded(
        child: SizedBox(
          height: 58,
          child: FilledButton(
            onPressed:
                _finished || _feedback != null ? null : () => _act(action),
            style: FilledButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, size: 19),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(l10n(context, title, titleTl),
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 8, fontWeight: FontWeight.w900)),
              ),
            ]),
          ),
        ),
      );

  Widget _feedbackCard(bool tagalog) => Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: _feedbackIsCorrect == true
              ? const Color(0xFFE2F6E8)
              : const Color(0xFFFFE8E5),
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: _feedbackIsCorrect == true ? C.green : C.red),
        ),
        child: Row(children: [
          Icon(
              _feedbackIsCorrect == true
                  ? Icons.check_circle_rounded
                  : Icons.error_rounded,
              color: _feedbackIsCorrect == true ? C.green : C.red),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              tagalog && _feedbackIsCorrect == true
                  ? _mission.explanationTl
                  : _feedbackIsCorrect == true
                      ? _mission.explanation
                      : tagalog
                          ? 'Maling kilos! Nawalan ka ng isang buhay at 5 puntos.'
                          : 'Wrong action! You lost one life and 5 points.',
              style: const TextStyle(
                  color: C.navy, fontSize: 11, fontWeight: FontWeight.w800),
            ),
          ),
        ]),
      );

  Widget _missionStrip(BuildContext context) => Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(l10n(context, 'MISSIONS', 'MGA MISYON'),
                style: const TextStyle(
                    color: C.navy, fontSize: 12, fontWeight: FontWeight.w900)),
            Text('${_missionIndex + 1} / 5',
                style: const TextStyle(
                    color: C.navy, fontSize: 11, fontWeight: FontWeight.w800)),
          ]),
          const SizedBox(height: 6),
          Row(children: [
            for (var i = 0; i < _trafficMissions.length; i++) ...[
              if (i > 0) const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 29,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: i < _missionIndex
                        ? C.green
                        : i == _missionIndex
                            ? C.blue
                            : const Color(0xFFE5EDF5),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    i < _missionIndex ? '✓' : '${i + 1}',
                    style: TextStyle(
                        color: i <= _missionIndex ? Colors.white : C.navy,
                        fontSize: 12,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ]),
        ]),
      );

  Widget _mechanicsAndLevels(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _infoPanel(
              icon: Icons.settings_rounded,
              title: l10n(context, 'GAME MECHANICS', 'MEKANIKA'),
              children: [
                'Correct action: +10 points',
                'Wrong action: −5 points',
                '3 lives · 60 seconds',
              ],
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _infoPanel(
              icon: Icons.emoji_events_rounded,
              title: l10n(context, 'LEVEL $_level', 'ANTAS $_level'),
              children: [
                '1 · Basic motion',
                '2 · Traffic situations',
                '3 · Direction challenge',
              ],
            ),
          ),
        ],
      );

  Widget _infoPanel({
    required IconData icon,
    required String title,
    required List<String> children,
  }) =>
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(11)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, size: 15, color: C.orange),
            const SizedBox(width: 4),
            Expanded(
              child: Text(title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: C.navy, fontSize: 9, fontWeight: FontWeight.w900)),
            ),
          ]),
          const SizedBox(height: 4),
          for (final line in children)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text('• $line',
                  style: const TextStyle(
                      color: C.navy, fontSize: 8, fontWeight: FontWeight.w600)),
            ),
        ]),
      );

  Widget _resultPanel(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _won ? const Color(0xFFFFF5C8) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: _won ? C.yellow : C.red, width: 2),
        ),
        child: Column(children: [
          Icon(_won ? Icons.emoji_events_rounded : Icons.sentiment_dissatisfied,
              size: 48, color: _won ? C.yellow : C.red),
          const SizedBox(height: 5),
          Text(
            _won
                ? l10n(context, 'Traffic Master!', 'Dalubhasa sa Trapiko!')
                : l10n(context, 'Challenge over', 'Tapos na ang hamon'),
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: C.navy, fontSize: 19, fontWeight: FontWeight.w900),
          ),
          Text(
            _won
                ? l10n(
                    context,
                    'You can identify acceleration in real-life situations!',
                    'Kaya mong tukuyin ang akselerasyon sa mga totoong sitwasyon!')
                : l10n(
                    context,
                    'Try again to complete all five traffic missions.',
                    'Subukan muli upang matapos ang limang misyon sa trapiko.'),
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: C.navy, fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text('Score: $_score  ·  Missions correct: $_correctCount / 5',
              style:
                  const TextStyle(color: C.navy, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          BigButton(l10n(context, 'PLAY AGAIN', 'MAGLARO MULI'),
              color: C.blue, onTap: _restart),
          if (_won) ...[
            const SizedBox(height: 6),
            BigButton(
              l10n(context, 'NEXT: QUIZ →', 'SUSUNOD: PAGSUSULIT →'),
              color: C.orange,
              onTap: () => go(
                context,
                const IndividualChallengeScreen(
                    sessionId: 7, stageTitle: 'Quiz'),
              ),
            ),
          ],
        ]),
      );
}

class _PlayerCarPainter extends CustomPainter {
  const _PlayerCarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(w * .5, h * .87), width: w * .8, height: h * .2),
      Paint()..color = Colors.black.withValues(alpha: .38),
    );
    final tire = Paint()..color = const Color(0xFF172331);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * .12, h * .6, w * .16, h * .32),
          const Radius.circular(6)),
      tire,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * .72, h * .6, w * .16, h * .32),
          const Radius.circular(6)),
      tire,
    );

    final body = Path()
      ..moveTo(w * .05, h * .72)
      ..lineTo(w * .12, h * .46)
      ..quadraticBezierTo(w * .17, h * .39, w * .33, h * .36)
      ..lineTo(w * .4, h * .17)
      ..quadraticBezierTo(w * .5, h * .1, w * .6, h * .17)
      ..lineTo(w * .68, h * .36)
      ..quadraticBezierTo(w * .84, h * .39, w * .89, h * .46)
      ..lineTo(w * .96, h * .72)
      ..lineTo(w * .91, h * .83)
      ..lineTo(w * .09, h * .83)
      ..close();
    canvas.drawPath(
      body,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFF756C), Color(0xFFE92738), Color(0xFF9F1024)],
          stops: [0, .42, 1],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      body,
      Paint()
        ..color = const Color(0xFFFFB1A8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    final rearWindow = Path()
      ..moveTo(w * .35, h * .39)
      ..lineTo(w * .42, h * .2)
      ..quadraticBezierTo(w * .5, h * .15, w * .58, h * .2)
      ..lineTo(w * .65, h * .39)
      ..close();
    canvas.drawPath(rearWindow, Paint()..color = const Color(0xFF9BDAF0));
    canvas.drawPath(
      rearWindow,
      Paint()
        ..color = Colors.white.withValues(alpha: .75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * .13, h * .53, w * .19, h * .12),
          const Radius.circular(3)),
      Paint()..color = const Color(0xFFFFD2A0),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * .68, h * .53, w * .19, h * .12),
          const Radius.circular(3)),
      Paint()..color = const Color(0xFFFFD2A0),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * .12, h * .7, w * .18, h * .08),
          const Radius.circular(3)),
      Paint()..color = const Color(0xFFFF263B),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * .7, h * .7, w * .18, h * .08),
          const Radius.circular(3)),
      Paint()..color = const Color(0xFFFF263B),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * .35, h * .76, w * .3, h * .05),
          const Radius.circular(3)),
      Paint()..color = const Color(0xFFCCD6DE),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TrafficScenePainter extends CustomPainter {
  final int missionIndex;
  const _TrafficScenePainter({required this.missionIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF53C5F7), Color(0xFFD4F2FF)],
        ).createShader(Offset.zero & size),
    );
    final terrain = Path()
      ..moveTo(0, h * .43)
      ..quadraticBezierTo(w * .25, h * .38, w * .48, h * .44)
      ..quadraticBezierTo(w * .76, h * .38, w, h * .43)
      ..lineTo(w, h * .7)
      ..lineTo(0, h * .7)
      ..close();
    canvas.drawPath(
      terrain,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF91D983), Color(0xFF38A95D)],
        ).createShader(Rect.fromLTWH(0, h * .38, w, h * .32)),
    );

    for (var i = 0; i < 11; i++) {
      final depth = .45 + (i % 5) * .11;
      final bw = w * (.032 + (i % 3) * .009) * depth;
      final bh = h * (.22 + (i % 4) * .055) * depth;
      final x = w * i / 10 - bw / 2;
      final y = h * .43 - bh;
      final rect = Rect.fromLTWH(x, y, bw, bh);
      final sideDepth = math.max(2.0, bw * .2).toDouble();
      final side = Path()
        ..moveTo(rect.right, rect.top)
        ..lineTo(rect.right + sideDepth, rect.top - sideDepth * .35)
        ..lineTo(rect.right + sideDepth, rect.bottom - sideDepth * .35)
        ..lineTo(rect.right, rect.bottom)
        ..close();
      canvas.drawPath(side, Paint()..color = const Color(0xFF315E85));
      final roof = Path()
        ..moveTo(rect.left, rect.top)
        ..lineTo(rect.left + sideDepth, rect.top - sideDepth * .35)
        ..lineTo(rect.right + sideDepth, rect.top - sideDepth * .35)
        ..lineTo(rect.right, rect.top)
        ..close();
      canvas.drawPath(roof, Paint()..color = const Color(0xFF8EC3DC));
      canvas.drawRect(
        rect,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF78B1CE), Color(0xFF3678A7)],
          ).createShader(rect),
      );
      final windowW = math.max(2.0, bw * .12).toDouble();
      final windowH = math.max(3.0, bh * .075).toDouble();
      for (var wx = x + bw * .16; wx + windowW < x + bw * .9; wx += bw * .25) {
        for (var wy = y + bh * .13;
            wy + windowH < rect.bottom - 3;
            wy += bh * .19) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(Rect.fromLTWH(wx, wy, windowW, windowH),
                const Radius.circular(1)),
            Paint()..color = const Color(0xFFE5F8FF),
          );
        }
      }
    }

    _drawTree(canvas, Offset(w * .09, h * .61), .55);
    _drawTree(canvas, Offset(w * .17, h * .55), .38);
    _drawTree(canvas, Offset(w * .9, h * .61), .55);
    _drawTree(canvas, Offset(w * .82, h * .55), .38);

    // Raised sidewalks sit between the grass and the sloping road shoulders.
    final leftWalk = Path()
      ..moveTo(w * .41, h * .43)
      ..lineTo(w * .43, h * .43)
      ..lineTo(w * .04, h)
      ..lineTo(0, h)
      ..close();
    final rightWalk = Path()
      ..moveTo(w * .57, h * .43)
      ..lineTo(w * .59, h * .43)
      ..lineTo(w, h)
      ..lineTo(w * .96, h)
      ..close();
    canvas.drawPath(leftWalk, Paint()..color = const Color(0xFFCCD5D8));
    canvas.drawPath(rightWalk, Paint()..color = const Color(0xFFCCD5D8));

    final road = Path()
      ..moveTo(w * .43, h * .43)
      ..lineTo(w * .57, h * .43)
      ..lineTo(w * 1.04, h)
      ..lineTo(-w * .04, h)
      ..close();
    canvas.drawPath(
      road,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF596573), Color(0xFF273342)],
        ).createShader(Rect.fromLTWH(0, h * .43, w, h * .57)),
    );
    final edgePaint = Paint()
      ..color = const Color(0xFFFFF1CE)
      ..strokeWidth = 3;
    canvas.drawLine(Offset(w * .43, h * .43), Offset(-w * .04, h), edgePaint);
    canvas.drawLine(Offset(w * .57, h * .43), Offset(w * 1.04, h), edgePaint);
    final dashPaint = Paint()..color = Colors.white;
    for (var i = 0; i < 4; i++) {
      final t = (i + 1) / 5;
      final y = h * (.45 + t * .51);
      final dashW = w * (.009 + t * .019);
      final dashH = h * (.018 + t * .035);
      final dash = Path()
        ..moveTo(w * .5 - dashW * .4, y - dashH / 2)
        ..lineTo(w * .5 + dashW * .4, y - dashH / 2)
        ..lineTo(w * .5 + dashW / 2, y + dashH / 2)
        ..lineTo(w * .5 - dashW / 2, y + dashH / 2)
        ..close();
      canvas.drawPath(dash, dashPaint);
    }

    // Roadside signal: red for the red-light mission, amber near the bus,
    // and green when the road is clear.
    final pole = Paint()
      ..color = const Color(0xFF263643)
      ..strokeWidth = 4;
    canvas.drawLine(Offset(w * .2, h * .35), Offset(w * .2, h * .69), pole);
    canvas.drawLine(Offset(w * .2 + 2, h * .69), Offset(w * .2 + 8, h * .69),
        pole..strokeWidth = 3);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * .16, h * .26, w * .08, h * .2),
          const Radius.circular(5)),
      Paint()..color = const Color(0xFF202A34),
    );
    final activeSignal = missionIndex == 0
        ? 0
        : missionIndex == 3
            ? 1
            : 2;
    final signalColors = [
      const Color(0xFFF14747),
      const Color(0xFFFFD35D),
      const Color(0xFF4CBB78),
    ];
    for (var i = 0; i < signalColors.length; i++) {
      canvas.drawCircle(
        Offset(w * .2, h * (.3 + i * .06)),
        4.4,
        Paint()
          ..color = i == activeSignal
              ? signalColors[i]
              : signalColors[i].withValues(alpha: .24),
      );
    }

    // A roadside speed-limit sign adds another recognizable traffic cue.
    canvas.drawLine(
      Offset(w * .87, h * .4),
      Offset(w * .87, h * .57),
      Paint()
        ..color = const Color(0xFF475867)
        ..strokeWidth = 3,
    );
    final speedSign = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * .82, h * .29, w * .1, h * .13),
      const Radius.circular(6),
    );
    canvas.drawRRect(speedSign, Paint()..color = Colors.white);
    canvas.drawRRect(
      speedSign,
      Paint()
        ..color = C.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    final signText = TextPainter(
      text: const TextSpan(
          text: '50',
          style: TextStyle(
              color: C.navy, fontSize: 10, fontWeight: FontWeight.w900)),
      textDirection: TextDirection.ltr,
    )..layout();
    signText.paint(
      canvas,
      Offset(speedSign.left + (speedSign.width - signText.width) / 2,
          speedSign.top + (speedSign.height - signText.height) / 2),
    );
    if (missionIndex == 1 || missionIndex == 3) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(w * .61, h * .52, w * .15, h * .09),
            const Radius.circular(6)),
        Paint()..color = missionIndex == 1 ? C.yellow : C.blue,
      );
      canvas.drawRect(Rect.fromLTWH(w * .64, h * .49, w * .08, h * .05),
          Paint()..color = const Color(0xFF9BE4F5));
    }
    if (missionIndex == 2) {
      final sign = Paint()..color = C.yellow;
      canvas.drawRect(Rect.fromLTWH(w * .79, h * .24, 3, h * .19),
          Paint()..color = const Color(0xFF394B58));
      final diamond = Path()
        ..moveTo(w * .81, h * .22)
        ..lineTo(w * .87, h * .27)
        ..lineTo(w * .81, h * .32)
        ..lineTo(w * .75, h * .27)
        ..close();
      canvas.drawPath(diamond, sign);
      canvas.drawLine(
          Offset(w * .79, h * .28),
          Offset(w * .83, h * .26),
          Paint()
            ..color = C.navy
            ..strokeWidth = 2);
    }
    if (missionIndex == 4) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(w * .68, h * .58, w * .11, h * .07),
            const Radius.circular(4)),
        Paint()..color = const Color(0xFFE24A3B),
      );
      canvas.drawLine(
          Offset(w * .67, h * .57),
          Offset(w * .81, h * .66),
          Paint()
            ..color = Colors.white
            ..strokeWidth = 3);
    }
  }

  void _drawTree(Canvas canvas, Offset base, double scale) {
    final shadow = Paint()..color = const Color(0x330D3425);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(base.dx, base.dy + 2 * scale),
          width: 42 * scale,
          height: 9 * scale),
      shadow,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            base.dx - 4 * scale, base.dy - 30 * scale, 8 * scale, 32 * scale),
        Radius.circular(2 * scale),
      ),
      Paint()..color = const Color(0xFF805A3C),
    );
    final foliage = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF8FE76E), Color(0xFF188A52)],
      ).createShader(Rect.fromCircle(
          center: Offset(base.dx, base.dy - 37 * scale), radius: 25 * scale));
    canvas.drawCircle(
        Offset(base.dx, base.dy - 38 * scale), 20 * scale, foliage);
    canvas.drawCircle(Offset(base.dx - 11 * scale, base.dy - 29 * scale),
        12 * scale, Paint()..color = const Color(0xFF36AC5B));
    canvas.drawCircle(Offset(base.dx + 12 * scale, base.dy - 29 * scale),
        12 * scale, Paint()..color = const Color(0xFF42B963));
    canvas.drawCircle(
        Offset(base.dx - 6 * scale, base.dy - 45 * scale),
        5 * scale,
        Paint()..color = const Color(0xFFBEF493).withValues(alpha: .8));
  }

  @override
  bool shouldRepaint(_TrafficScenePainter oldDelegate) =>
      oldDelegate.missionIndex != missionIndex;
}

/// A session-specific mission sequence with immediate feedback and progress.
class _SessionQuizChallengeScreen extends StatefulWidget {
  final int sessionId;
  const _SessionQuizChallengeScreen({required this.sessionId});

  @override
  State<_SessionQuizChallengeScreen> createState() =>
      _SessionChallengeScreenState();
}

class _SessionChallengeScreenState extends State<_SessionQuizChallengeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int index = 0;
  int? selected;
  int score = 0;
  bool finished = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppScope.of(context).animation) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      _controller.stop();
      _controller.value = .55;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Quiz> get questions => sessionQuizzes[widget.sessionId]!
      .take(widget.sessionId == 1 ? 3 : 5)
      .toList();

  void _choose(int option) {
    if (selected != null || finished) return;
    AppScope.of(context).click();
    setState(() {
      selected = option;
      if (option == questions[index].answer) score++;
    });
  }

  void _next() {
    if (index == questions.length - 1) {
      AppScope.of(context).recordChallenge(score, total: questions.length);
      setState(() => finished = true);
      return;
    }
    setState(() {
      index++;
      selected = null;
    });
  }

  void _restart() => setState(() {
        index = 0;
        selected = null;
        score = 0;
        finished = false;
      });

  @override
  Widget build(BuildContext context) {
    final q = questions[index];
    final tagalog = AppScope.of(context).tagalog;
    final lesson = lessons[widget.sessionId - 1];
    return Scaffold(
      appBar: AppBar(
          title: Text(l10n(context, 'Session ${widget.sessionId} Challenge',
              'Hamon sa Sesyon ${widget.sessionId}'))),
      bottomNavigationBar: SessionPageNavigationBar(
        sessionId: widget.sessionId,
        currentPage: SessionPage.challenge,
      ),
      body: finished
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.emoji_events_rounded,
                      color: C.yellow, size: 64),
                  const SizedBox(height: 12),
                  Text(lesson.titleFor(tagalog),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 23, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                      l10n(
                          context,
                          'Missions complete: $score / ${questions.length}',
                          'Mga natapos na misyon: $score / ${questions.length}'),
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  BigButton(l10n(context, 'TRY AGAIN', 'SUBUKAN MULI'),
                      onTap: _restart),
                  const SizedBox(height: 10),
                  BigButton(
                      l10n(context, 'NEXT: SESSION QUIZ →',
                          'SUSUNOD: PAGSUSULIT →'),
                      color: C.orange,
                      onTap: () => go(
                          context,
                          IndividualChallengeScreen(
                              sessionId: widget.sessionId,
                              stageTitle: 'Quiz'))),
                ]),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SizedBox(
                  height: 104,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(children: [
                      Positioned.fill(
                          child: Container(color: const Color(0xFF303A4A))),
                      Positioned(
                          left: 0,
                          right: 0,
                          bottom: 22,
                          child: Container(height: 4, color: Colors.white70)),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) => Align(
                          alignment: Alignment(-1 + 2 * _controller.value, 0),
                          child: VehicleWidget(
                            type: widget.sessionId == 1
                                ? VehicleType.autoRickshaw
                                : widget.sessionId == 2
                                    ? VehicleType.bicycle
                                    : widget.sessionId == 7
                                        ? VehicleType.bus
                                        : VehicleType.car,
                            width: 70,
                            spin: _controller.value * 18,
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 12),
                AppCard(
                  color: C.orange.withValues(alpha: .12),
                  child: Row(children: [
                    const Icon(Icons.flag_rounded, color: C.orange, size: 30),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                l10n(context, 'MISSION ${index + 1}',
                                    'MISYON ${index + 1}'),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17)),
                            Text(lesson.titleFor(tagalog),
                                style: TextStyle(color: subText(context))),
                          ]),
                    ),
                    Text('$score pts',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ]),
                ),
                const SizedBox(height: 12),
                AnimatedBar(
                    value:
                        (index + (selected == null ? 0 : 1)) / questions.length,
                    color: C.orange),
                const SizedBox(height: 6),
                Text(
                    l10n(context, 'Mission ${index + 1} of ${questions.length}',
                        'Misyon ${index + 1} sa ${questions.length}'),
                    style: TextStyle(color: subText(context))),
                const SizedBox(height: 12),
                AppCard(
                    child: Text(q.questionFor(tagalog),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            height: 1.4))),
                const SizedBox(height: 12),
                for (int i = 0; i < q.options.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: OutlinedButton(
                      onPressed: () => _choose(i),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(14),
                        backgroundColor: selected == null
                            ? null
                            : i == q.answer
                                ? C.green.withValues(alpha: .16)
                                : selected == i
                                    ? C.red.withValues(alpha: .14)
                                    : null,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            '${String.fromCharCode(65 + i)}. ${q.optionsFor(tagalog)[i]}'),
                      ),
                    ),
                  ),
                if (selected != null) ...[
                  AppCard(
                    color: (selected == q.answer ? C.green : C.orange)
                        .withValues(alpha: .14),
                    child: Text(q.whyFor(tagalog)),
                  ),
                  const SizedBox(height: 12),
                  BigButton(
                      l10n(
                          context,
                          index == questions.length - 1
                              ? 'FINISH MISSION'
                              : 'NEXT MISSION',
                          index == questions.length - 1
                              ? 'TAPUSIN ANG MISYON'
                              : 'SUSUNOD NA MISYON'),
                      color: C.orange,
                      onTap: _next),
                ],
              ],
            ),
    );
  }
}

class _RushLevel {
  final String title;
  final String subtitle;
  final double initialVelocity;
  final double targetVelocity;
  final int timeLimit;
  final Color color;
  const _RushLevel({
    required this.title,
    required this.subtitle,
    required this.initialVelocity,
    required this.targetVelocity,
    required this.timeLimit,
    required this.color,
  });
}

const _rushLevels = <_RushLevel>[
  _RushLevel(
      title: 'Starting Motion',
      subtitle: 'Accelerate from 5 m/s to the target.',
      initialVelocity: 5,
      targetVelocity: 15,
      timeLimit: 30,
      color: C.blue),
  _RushLevel(
      title: 'Speed Change',
      subtitle: 'Raise the speed from 10 m/s to 25 m/s.',
      initialVelocity: 10,
      targetVelocity: 25,
      timeLimit: 45,
      color: C.green),
  _RushLevel(
      title: 'Acceleration Master',
      subtitle: 'Choose acceleration to reach 28 m/s in time.',
      initialVelocity: 8,
      targetVelocity: 28,
      timeLimit: 40,
      color: C.purple),
];

String _rushNumber(double value) {
  final fixed = value.toStringAsFixed(2);
  if (fixed.endsWith('00')) return fixed.substring(0, fixed.length - 3);
  if (fixed.endsWith('0')) return fixed.substring(0, fixed.length - 1);
  return fixed;
}

class AccelerationRushScreen extends StatefulWidget {
  const AccelerationRushScreen({super.key});

  @override
  State<AccelerationRushScreen> createState() => _AccelerationRushScreenState();
}

class _AccelerationRushScreenState extends State<AccelerationRushScreen>
    with SingleTickerProviderStateMixin {
  Timer? _gameTimer;
  late final AnimationController _heroController;
  int _selectedLevel = 1;
  double _acceleration = 0;
  double _elapsed = 0;
  double _velocity = 5;
  int _runScore = 0;
  String _hint = 'Choose an acceleration, then start the level.';
  bool _running = false;
  bool? _won;
  bool _initialized = false;
  bool _showLevel = false;

  _RushLevel get _level => _rushLevels[_selectedLevel - 1];

  @override
  void initState() {
    super.initState();
    _velocity = _level.initialVelocity;
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppScope.of(context).animation) {
      if (!_heroController.isAnimating) _heroController.repeat();
    } else {
      _heroController.stop();
      _heroController.value = .5;
    }
    if (_initialized) return;
    final unlocked = AppScope.of(context).session1RushUnlocked;
    _selectedLevel = unlocked.clamp(1, 3).toInt();
    _acceleration = 0;
    _velocity = _level.initialVelocity;
    _initialized = true;
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _heroController.dispose();
    super.dispose();
  }

  void _selectLevel(int level) {
    final state = AppScope.of(context);
    if (_running || level > state.session1RushUnlocked) return;
    setState(() {
      _selectedLevel = level;
      _acceleration = 0;
      _elapsed = 0;
      _velocity = _level.initialVelocity;
      _won = null;
      _runScore = 0;
      _hint = _levelQuestion(level);
    });
  }

  void _openLevel(int level) {
    final state = AppScope.of(context);
    if (_running || level > state.session1RushUnlocked) return;
    _selectLevel(level);
    setState(() => _showLevel = true);
  }

  void _backToLevels() {
    _gameTimer?.cancel();
    setState(() {
      _running = false;
      _won = null;
      _showLevel = false;
    });
  }

  void _startLevel() {
    final state = AppScope.of(context);
    if (_running || _selectedLevel > state.session1RushUnlocked) return;
    state.click();
    setState(() {
      _running = true;
      _won = null;
      _elapsed = 0;
      _velocity = _level.initialVelocity;
      _runScore = 0;
      _hint =
          'Watch the speed and adjust acceleration while the rickshaw moves.';
    });
    _gameTimer?.cancel();
    _gameTimer =
        Timer.periodic(const Duration(milliseconds: 100), (_) => _tick());
  }

  void _tick() {
    if (!mounted || !_running) return;
    const dt = .1;
    final elapsed = (_elapsed + dt).clamp(0.0, _level.timeLimit.toDouble());
    final velocity = (_velocity + _acceleration * dt)
        .clamp(0.0, _level.targetVelocity)
        .toDouble();
    // The written acceleration is rounded to two decimals. Treat a result
    // within one displayed tenth of a m/s as reaching the target.
    if (velocity >= _level.targetVelocity - 0.1) {
      final reachedVelocity = _level.targetVelocity;
      setState(() {
        _elapsed = elapsed;
        _velocity = reachedVelocity;
      });
      _finishRun(won: true);
      return;
    }
    if (elapsed >= _level.timeLimit) {
      setState(() {
        _elapsed = elapsed;
        _velocity = velocity;
      });
      _finishRun(won: false);
      return;
    }
    setState(() {
      _elapsed = elapsed;
      _velocity = velocity;
      final remainingSeconds = _level.timeLimit - elapsed;
      final needed = remainingSeconds <= 0
          ? double.infinity
          : (_level.targetVelocity - velocity) / remainingSeconds;
      _hint = _acceleration < 0
          ? 'Negative acceleration is slowing the rickshaw down.'
          : _acceleration == 0
              ? 'Zero acceleration keeps the current speed steady.'
              : _acceleration < needed
                  ? "You're accelerating too slowly. Increase acceleration."
                  : 'Good pace. Keep the target in sight!';
    });
  }

  void _finishRun({required bool won}) {
    _gameTimer?.cancel();
    if (won) {
      _runScore = 10;
      AppScope.of(context).completeRushLevel(_selectedLevel);
      _hint = _selectedLevel == 3
          ? 'Acceleration Master! You completed all three levels.'
          : 'Target reached! +10 points. Great acceleration!';
    } else {
      _hint =
          "TIME'S UP! Final speed: ${fmt(_velocity)} m/s. Review a = (vf − vi) / t, then try again.";
    }
    setState(() {
      _running = false;
      _won = won;
    });
  }

  String _levelQuestion(int level) => switch (level) {
        1 => 'What is the acceleration?',
        2 => 'What acceleration should you use?',
        _ => 'What acceleration will reach the target in time?',
      };

  void _primaryAction() {
    final state = AppScope.of(context);
    if (!_showLevel && state.session1RushUnlocked < 4) {
      _openLevel(state.session1RushUnlocked);
      return;
    }
    if (state.session1RushUnlocked >= 4) {
      go(context,
          const IndividualChallengeScreen(sessionId: 1, stageTitle: 'Quiz'));
      return;
    }
    if (_won == true) {
      _openLevel(state.session1RushUnlocked);
      return;
    }
    _startLevel();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final unlocked = state.session1RushUnlocked;
    final allComplete = unlocked >= 4;
    final progress = (unlocked - 1) / 3;
    final actionLabel = !_showLevel && allComplete
        ? l10n(context, 'NEXT: SESSION QUIZ →', 'SUSUNOD: PAGSUSULIT →')
        : !_showLevel
            ? l10n(context, 'OPEN LEVEL $unlocked →',
                'BUKSAN ANG ANTAS $unlocked →')
            : allComplete
                ? l10n(context, 'NEXT: SESSION QUIZ →', 'SUSUNOD: PAGSUSULIT →')
                : _won == true
                    ? l10n(context, 'NEXT LEVEL →', 'SUSUNOD NA ANTAS →')
                    : _won == false
                        ? l10n(context, 'RETRY LEVEL', 'ULITIN ANG ANTAS')
                        : l10n(context, 'START LEVEL $_selectedLevel',
                            'SIMULAN ANG ANTAS $_selectedLevel');

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _showLevel ? null : 68,
        leading: _showLevel
            ? IconButton(
                tooltip:
                    l10n(context, 'Back to levels', 'Bumalik sa mga antas'),
                onPressed: _backToLevels,
                icon: const Icon(Icons.arrow_back_rounded),
              )
            : IconButton(
                tooltip: l10n(context, 'Back', 'Bumalik'),
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
        title: _showLevel
            ? Text(
                l10n(context, 'LEVEL $_selectedLevel', 'ANTAS $_selectedLevel'))
            : const Row(children: [
                Icon(Icons.speed_rounded, color: C.yellow, size: 27),
                SizedBox(width: 7),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CHALLENGE:',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              height: 1,
                              fontWeight: FontWeight.w900)),
                      SizedBox(height: 3),
                      Text('ACCELERATION RUSH',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              height: 1,
                              fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              ]),
        actions: [
          if (!_showLevel)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(l10n(context, 'YOUR PROGRESS', 'IYONG PAG-UNLAD'),
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 8,
                            fontWeight: FontWeight.w800)),
                    Text('${unlocked - 1}/3',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
        SessionContinueBar(
          label: actionLabel,
          enabled: !_running,
          onTap: _primaryAction,
        ),
        const SessionPageNavigationBar(
          sessionId: 1,
          currentPage: SessionPage.challenge,
        ),
      ]),
      body: _showLevel
          ? _buildLevelDetail(context)
          : _buildLevelSelect(context, state, unlocked, progress),
    );
  }

  Widget _buildLevelSelect(
      BuildContext context, AppState state, int unlocked, double progress) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xff35e7ff), width: 1.4),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff18d9ff).withValues(alpha: .22),
                blurRadius: 16,
                spreadRadius: 1,
              ),
            ],
            gradient: const LinearGradient(
                colors: [C.navy, Color(0xff087cc1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 164,
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: CustomPaint(painter: _RushCityPainter()),
                  ),
                  AnimatedBuilder(
                    animation: _heroController,
                    builder: (context, _) => Align(
                      alignment: Alignment(-1 + 2 * _heroController.value, 1),
                      child: const VehicleWidget(
                          type: VehicleType.autoRickshaw, width: 118, spin: 3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: C.navy.withValues(alpha: .82),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white24),
              ),
              child: Text(
                l10n(context, 'Can you become an Acceleration Master?',
                    'Kaya mo bang maging dalubhasa sa akselerasyon?'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(C.yellow)),
            ),
          ]),
        ),
        const SizedBox(height: 14),
        for (var index = 0; index < _rushLevels.length; index++)
          _RushLevelTile(
            number: index + 1,
            level: _rushLevels[index],
            unlocked: index + 1 <= unlocked,
            completed: index + 1 < unlocked,
            selected: index + 1 == _selectedLevel,
            enabled: !_running,
            tagalog: state.tagalog,
            onTap: () => _openLevel(index + 1),
          ),
      ],
    );
  }

  Widget _calculationPanel(BuildContext context) {
    final change = _level.targetVelocity - _level.initialVelocity;
    final required = change / _level.timeLimit;
    final exact = _selectedLevel == 3;
    return AppCard(
      color: _level.color.withValues(alpha: .1),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l10n(context, 'ACCELERATION FORMULA', 'PORMULA NG AKSELERASYON'),
            style: TextStyle(
                color: _level.color,
                fontSize: 12,
                fontWeight: FontWeight.w900)),
        const SizedBox(height: 5),
        const Text('a = (vf − vi) ÷ t',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
        const SizedBox(height: 3),
        Text(
          'a = (${fmt(_level.targetVelocity)} − ${fmt(_level.initialVelocity)}) ÷ ${_level.timeLimit}',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        Text(
          'a = ${fmt(change)} ÷ ${_level.timeLimit} ${exact ? '=' : '≈'} ${_rushNumber(required)} m/s²',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 3),
        Text(
          l10n(context, 'Set the acceleration with the game control.',
              'Itakda ang akselerasyon gamit ang kontrol ng laro.'),
          style: TextStyle(color: subText(context), fontSize: 11),
        ),
      ]),
    );
  }

  Widget _buildLevelDetail(BuildContext context) {
    final tagalog = AppScope.of(context).tagalog;
    final liveVelocity = _velocity;
    final remaining =
        (_level.timeLimit - _elapsed).ceil().clamp(0, _level.timeLimit);
    final estimatedFinal = _velocity + _acceleration * remaining;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(colors: [_level.color, C.navy]),
          ),
          child: Row(children: [
            const Icon(Icons.flag_rounded, color: Colors.white, size: 26),
            const SizedBox(width: 8),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('${tagalog ? 'ANTAS' : 'LEVEL'} $_selectedLevel',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 19)),
                  Text(_rushTitle(_selectedLevel, tagalog),
                      style: const TextStyle(color: Colors.white70)),
                ])),
            Text(
                _selectedLevel == 1
                    ? '🔵'
                    : _selectedLevel == 2
                        ? '🟢'
                        : '🟣',
                style: const TextStyle(fontSize: 25)),
          ]),
        ),
        const SizedBox(height: 12),
        AppCard(
          color: _level.color.withValues(alpha: .1),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.track_changes_rounded, color: _level.color),
              const SizedBox(width: 7),
              Text(l10n(context, 'CHALLENGE', 'HAMON'),
                  style: const TextStyle(fontWeight: FontWeight.bold))
            ]),
            const SizedBox(height: 5),
            Text(
                '${_levelQuestion(_selectedLevel)} ${fmt(_level.initialVelocity)} m/s → ${fmt(_level.targetVelocity)} m/s',
                style: TextStyle(color: subText(context))),
            const SizedBox(height: 4),
            Text('Time limit: ${_level.timeLimit} seconds',
                style: TextStyle(color: subText(context), fontSize: 12)),
          ]),
        ),
        const SizedBox(height: 10),
        Row(children: [
          _RushStat(
              label: l10n(context, 'TIME LEFT', 'NATITIRANG ORAS'),
              value: '$remaining s'),
          _RushStat(
              label: l10n(context, 'START', 'SIMULA'),
              value: '${fmt(_level.initialVelocity)} m/s'),
          _RushStat(
              label: l10n(context, 'TARGET', 'TARGET'),
              value: '${fmt(_level.targetVelocity)} m/s'),
        ]),
        const SizedBox(height: 10),
        _calculationPanel(context),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final p = AppScope.of(context).animation
                ? (_elapsed / _level.timeLimit).clamp(0.0, 1.0)
                : 0.0;
            final left = 8 + (constraints.maxWidth - 104) * p;
            return Container(
              height: 126,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff91d2f3), Color(0xffd9f0ff)])),
              child: Stack(children: [
                const Positioned.fill(
                    child: CustomPaint(painter: _RushCityPainter())),
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 38,
                    child: Container(color: const Color(0xff394454))),
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 17,
                    height: 3,
                    child: Container(color: Colors.white70)),
                Positioned(
                    left: left,
                    bottom: 22,
                    child: VehicleWidget(
                        type: VehicleType.autoRickshaw,
                        width: 96,
                        spin: p * 16)),
                Positioned(
                    top: 8,
                    right: 8,
                    child: Text('${fmt(liveVelocity)} m/s',
                        style: const TextStyle(fontWeight: FontWeight.bold))),
              ]),
            );
          },
        ),
        const SizedBox(height: 10),
        AppCard(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
                l10n(
                    context, 'ACCELERATION CONTROL', 'KONTROL NG AKSELERASYON'),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${_rushNumber(_acceleration)} m/s²',
                style: TextStyle(
                    color: _level.color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Slider(
              value: _acceleration.clamp(-5.0, 5.0).toDouble(),
              min: -5,
              max: 5,
              divisions: 1000,
              onChanged: (value) => setState(() {
                _acceleration = value;
                _won = null;
                if (_running) {
                  _hint = 'Acceleration changed to ${fmt(value)} m/s².';
                }
              }),
            ),
            Text(
                l10n(
                    context,
                    'Current: ${fmt(liveVelocity)} m/s   •   Target: ${fmt(_level.targetVelocity)} m/s   •   Score: $_runScore',
                    'Kasalukuyan: ${fmt(liveVelocity)} m/s   •   Target: ${fmt(_level.targetVelocity)} m/s   •   Puntos: $_runScore'),
                style: TextStyle(color: subText(context))),
            const SizedBox(height: 6),
            Text(
                'Predicted after ${_level.timeLimit} s: ${fmt(estimatedFinal)} m/s',
                style: TextStyle(color: subText(context))),
          ]),
        ),
        if (_won != null) ...[
          const SizedBox(height: 10),
          AppCard(
            color: (_won! ? C.green : C.orange).withValues(alpha: .15),
            child: Text(
                _won!
                    ? l10n(
                        context,
                        _selectedLevel == 3
                            ? 'TARGET REACHED! Acceleration Master! +10 points'
                            : 'TARGET REACHED! +10 points',
                        _selectedLevel == 3
                            ? 'NAABOT ANG TARGET! Acceleration Master! +10 puntos'
                            : 'NAABOT ANG TARGET! +10 puntos')
                    : l10n(
                        context,
                        "TIME'S UP! Final speed ${fmt(_velocity)} m/s of ${fmt(_level.targetVelocity)} m/s. Review the formula and retry.",
                        'UBOS NA ANG ORAS! Huling bilis: ${fmt(_velocity)} m/s sa target na ${fmt(_level.targetVelocity)} m/s. Balikan ang pormula at subukan muli.'),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _won! ? C.green : C.orange)),
          ),
        ],
        const SizedBox(height: 10),
        Text(_hint, style: TextStyle(color: subText(context))),
      ],
    );
  }
}

class _RushLevelTile extends StatelessWidget {
  final int number;
  final _RushLevel level;
  final bool unlocked;
  final bool completed;
  final bool selected;
  final bool enabled;
  final bool tagalog;
  final VoidCallback onTap;
  const _RushLevelTile(
      {required this.number,
      required this.level,
      required this.unlocked,
      required this.completed,
      required this.selected,
      required this.enabled,
      required this.tagalog,
      required this.onTap});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          color: selected ? level.color.withValues(alpha: .13) : null,
          onTap: unlocked && enabled ? onTap : null,
          child: Row(children: [
            CircleAvatar(
                backgroundColor: unlocked ? level.color : subText(context),
                child: Text('$number',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(
                      '${tagalog ? 'ANTAS' : 'LEVEL'} $number · ${_rushTitle(number, tagalog)}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(tagalog ? _rushSubtitleTl(number) : level.subtitle,
                      style: TextStyle(fontSize: 12, color: subText(context))),
                ])),
            Icon(
                completed
                    ? Icons.check_circle
                    : unlocked
                        ? Icons.play_circle_fill
                        : Icons.lock_rounded,
                color: completed
                    ? C.green
                    : unlocked
                        ? level.color
                        : subText(context)),
          ]),
        ),
      );
}

class _RushStat extends StatelessWidget {
  final String label;
  final String value;
  const _RushStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          margin: const EdgeInsets.only(right: 6),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: cardColor(context),
              borderRadius: BorderRadius.circular(10)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 9, color: subText(context))),
            const SizedBox(height: 3),
            Text(value,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ]),
        ),
      );
}

String _rushSubtitleTl(int level) => switch (level) {
      1 => 'Paandarin ang auto-rickshaw mula sa paghinto.',
      2 => 'Abutin ang target mula sa umaandar nang sasakyan.',
      _ => 'Pumili ng tiyak na akselerasyon upang maabot ang target.',
    };

String _rushTitle(int level, bool tagalog) => !tagalog
    ? _rushLevels[level - 1].title
    : switch (level) {
        1 => 'Pagsisimula ng Galaw',
        2 => 'Pagbabago ng Bilis',
        _ => 'Dalubhasa sa Akselerasyon',
      };

class _RushCityPainter extends CustomPainter {
  const _RushCityPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0x22355f83);
    canvas.drawCircle(Offset(size.width * .84, size.height * .23), 19, paint);
    final buildings = <Rect>[
      Rect.fromLTWH(size.width * .02, size.height * .31, 27, size.height * .37),
      Rect.fromLTWH(size.width * .14, size.height * .18, 34, size.height * .5),
      Rect.fromLTWH(size.width * .30, size.height * .34, 25, size.height * .34),
      Rect.fromLTWH(size.width * .47, size.height * .12, 37, size.height * .56),
      Rect.fromLTWH(size.width * .66, size.height * .29, 27, size.height * .39),
      Rect.fromLTWH(size.width * .81, size.height * .17, 31, size.height * .51),
      Rect.fromLTWH(size.width * .93, size.height * .32, 27, size.height * .36),
    ];
    for (var i = 0; i < buildings.length; i++) {
      paint.color =
          i.isEven ? const Color(0xff8bc8e8) : const Color(0xff73b9dc);
      canvas.drawRRect(
          RRect.fromRectAndRadius(buildings[i], const Radius.circular(3)),
          paint);
      paint.color = const Color(0xffe8f7ff);
      final rect = buildings[i];
      for (double x = rect.left + 6; x < rect.right - 3; x += 10) {
        for (double y = rect.top + 8; y < rect.bottom - 4; y += 12) {
          canvas.drawRect(Rect.fromLTWH(x, y, 3, 4), paint);
        }
      }
    }
    paint.color = const Color(0xff4eaf68);
    canvas.drawRect(
        Rect.fromLTWH(0, size.height * .67, size.width, size.height * .08),
        paint);
    paint.color = const Color(0xff293746);
    canvas.drawRect(
        Rect.fromLTWH(0, size.height * .75, size.width, size.height * .25),
        paint);
    paint.color = const Color(0xffffde63);
    for (double x = 0; x < size.width; x += 42) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(x, size.height * .88, 22, 3),
              const Radius.circular(2)),
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
