import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../data/content.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/session_page_navigation.dart';
import 'session_challenge_screen.dart';

class _Problem {
  final String who;
  final double vi;
  final double vf;
  final double t;
  final double a;
  final double? force;
  final double? mass;
  const _Problem(this.who, this.vi, this.vf, this.t, this.a,
      {this.force, this.mass});
}

class PracticeScreen extends StatefulWidget {
  final int? sessionId;
  const PracticeScreen({super.key, this.sessionId});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final _rnd = math.Random();
  final _ctrl = TextEditingController();
  late _Problem _p;
  bool? _ok;
  bool _counted = false;
  int _round = 0;

  @override
  void initState() {
    super.initState();
    _p = _gen();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  _Problem _gen() {
    switch (widget.sessionId) {
      case 1:
        return const [
          _Problem('auto rickshaw', 5, 15, 5, 2),
          _Problem('auto rickshaw', 0, 20, 4, 5),
          _Problem('auto rickshaw', 10, 20, 4, 2.5),
          _Problem('auto rickshaw', 8, 28, 6, 3.333),
        ][_round++ % 4];
      case 2:
        return const [
          _Problem('bicycle', 5, 10, 2, 2.5),
          _Problem('bicycle', 15, 5, 5, -2),
          _Problem('bicycle', 10, 10, 4, 0),
          _Problem('bus', 20, 30, 5, 2),
        ][_round++ % 4];
      case 3:
        return const [
          _Problem('cart', 0, 0, 1, 5, force: 50, mass: 10),
          _Problem('cart', 0, 0, 1, 3, force: 18, mass: 6),
          _Problem('cart', 0, 0, 1, 4, force: 32, mass: 8),
          _Problem('cart', 0, 0, 1, 2, force: 20, mass: 10),
        ][_round++ % 4];
      case 4:
        return const [
          _Problem('car', 5, 25, 4, 5),
          _Problem('car', 0, 18, 3, 6),
          _Problem('motorcycle', 10, 30, 5, 4),
          _Problem('bus', 12, 36, 6, 4),
        ][_round++ % 4];
      case 5:
        return const [
          _Problem('bus', 28, 12, 4, -4),
          _Problem('skateboarder', -4, -16, 4, -3),
          _Problem('car', 20, 10, 5, -2),
          _Problem('car', -15, -5, 5, 2),
        ][_round++ % 4];
      case 6:
        return const [
          _Problem('graph', 4, 16, 4, 3),
          _Problem('graph', 2, 2, 4, 0),
          _Problem('graph', 24, 8, 4, -4),
          _Problem('graph', 0, 20, 5, 4),
        ][_round++ % 4];
      case 7:
        return const [
          _Problem('motorcycle', 12, 24, 6, 2),
          _Problem('bus', 15, 6, 3, -3),
          _Problem('bicycle', 8, 8, 5, 0),
          _Problem('car', 10, 30, 4, 5),
        ][_round++ % 4];
      case 8:
        return const [
          _Problem('car', 5, 20, 5, 3),
          _Problem('motorcycle', 30, 10, 5, -4),
          _Problem('bicycle', 10, 10, 3, 0),
          _Problem('airplane', 0, 70, 10, 7),
          _Problem('bus', 25, 5, 4, -5),
        ][_round++ % 5];
    }
    const options = [2.0, 3.0, 4.0, 5.0, -2.0, -3.0, -4.0];
    const who = ['car', 'bicycle', 'train', 'bus', 'runner', 'motorcycle'];
    final a = options[_rnd.nextInt(options.length)];
    final t = (2 + _rnd.nextInt(5)).toDouble();
    final vi = a > 0 ? _rnd.nextInt(11).toDouble() : (-a * t + _rnd.nextInt(6));
    return _Problem(who[_rnd.nextInt(who.length)], vi, vi + a * t, t, a);
  }

  void _check() {
    final raw = _ctrl.text.replaceAll('−', '-');
    final match = RegExp(r'-?\d+(\.\d+)?').stringMatch(raw);
    final v = double.tryParse(match ?? '');
    if (v == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n(context, 'Type your answer as a number first.',
                'Ilagay muna ang sagot bilang numero.'))),
      );
      return;
    }
    final s = AppScope.of(context);
    s.click();
    final ok = (v - _p.a).abs() < 0.01;
    setState(() => _ok = ok);
    if (ok && !_counted) {
      _counted = true;
      s.solvedOne();
    }
  }

  void _next() {
    final practiceLimit = widget.sessionId == 8 ? 5 : 4;
    if (widget.sessionId != null && _round >= practiceLimit) {
      go(context, SessionChallengeScreen(sessionId: widget.sessionId!));
      return;
    }
    setState(() {
      _p = _gen();
      _ok = null;
      _counted = false;
      _ctrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sessionId == 1) {
      return const _SessionOnePracticeScreen();
    }
    if (widget.sessionId == 7) {
      return const _SessionSevenPracticeScreen();
    }
    if (widget.sessionId == 2) {
      return const _SessionTwoPracticeScreen();
    }
    if (widget.sessionId == 3) {
      return const _SessionThreePracticeScreen();
    }
    if (widget.sessionId == 4) {
      return const _SessionFourPracticeScreen();
    }
    final s = AppScope.of(context);
    final p = _p;

    return Scaffold(
      appBar: AppBar(
          title: Text(l10n(
              context,
              widget.sessionId == null
                  ? 'Calculation Practice'
                  : 'Session ${widget.sessionId} Practice',
              widget.sessionId == null
                  ? 'Pagsasanay sa Pagkalkula'
                  : 'Pagsasanay sa Sesyon ${widget.sessionId}'))),
      bottomNavigationBar: widget.sessionId == null
          ? null
          : SessionPageNavigationBar(
              sessionId: widget.sessionId!,
              currentPage: SessionPage.practice,
            ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
              l10n(context, 'Problems solved: ${s.problemsSolved}',
                  'Mga nalutas na problema: ${s.problemsSolved}'),
              style: TextStyle(
                  color: subText(context), fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: AppCard(
              key: ValueKey('${p.vi}-${p.vf}-${p.t}'),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.force != null
                          ? l10n(
                              context,
                              'A ${fmt(p.mass!)} kg cart experiences a net force of ${fmt(p.force!)} N. What is its acceleration?',
                              'May netong puwersang ${fmt(p.force!)} N sa karitong may bigat na ${fmt(p.mass!)} kg. Ano ang akselerasyon nito?')
                          : l10n(
                              context,
                              p.who == 'graph'
                                  ? 'A velocity-time graph rises from ${fmt(p.vi)} m/s at 2 s to ${fmt(p.vf)} m/s at 6 s. What is its slope (acceleration)?'
                                  : 'A ${p.who} changes its velocity from ${fmt(p.vi)} m/s to ${fmt(p.vf)} m/s in ${fmt(p.t)} seconds. What is its acceleration?',
                              'Nagbago ang bilis ng ${_whoTl(p.who)} mula ${fmt(p.vi)} m/s hanggang ${fmt(p.vf)} m/s sa loob ng ${fmt(p.t)} segundo. Ano ang akselerasyon nito?'),
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: C.blue.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        p.force != null
                            ? 'Fnet = ${fmt(p.force!)} N\nMass = ${fmt(p.mass!)} kg'
                            : '${l10n(context, 'Initial velocity', 'Panimulang bilis')}   =  ${fmt(p.vi)} m/s\n'
                                '${l10n(context, 'Final velocity', 'Huling bilis')}     =  ${fmt(p.vf)} m/s\n'
                                '${l10n(context, 'Time', 'Oras')}                  =  ${fmt(p.t)} s',
                        style: const TextStyle(height: 1.6),
                      ),
                    ),
                  ]),
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n(context, 'Your Answer:', 'Iyong Sagot:'),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _ctrl,
                enabled: _ok != true,
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                decoration: InputDecoration(
                  hintText: l10n(context, 'e.g. 2', 'hal. 2'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text('m/s²',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 12),
          BigButton(l10n(context, 'CHECK ANSWER', 'SURIIN ANG SAGOT'),
              onTap: _ok == true ? null : _check),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _ok == null
                ? const SizedBox(width: double.infinity)
                : Container(
                    key: ValueKey(_ok),
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (_ok! ? C.green : C.red).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(_ok! ? Icons.check_circle : Icons.cancel,
                              color: _ok! ? C.green : C.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _ok!
                                  ? l10n(
                                      context,
                                      p.force != null
                                          ? 'Correct!\na = Fnet / m = ${fmt(p.force!)} / ${fmt(p.mass!)} = ${fmt(p.a)} m/s²'
                                          : 'Correct!\na = (${fmt(p.vf)} − ${fmt(p.vi)}) / ${fmt(p.t)} = ${fmt(p.a)} m/s²',
                                      p.force != null
                                          ? 'Tama!\na = Fnet / m = ${fmt(p.force!)} / ${fmt(p.mass!)} = ${fmt(p.a)} m/s²'
                                          : 'Tama!\na = (${fmt(p.vf)} − ${fmt(p.vi)}) / ${fmt(p.t)} = ${fmt(p.a)} m/s²')
                                  : l10n(
                                      context,
                                      'Not quite. Check the order of vf and vi, and the sign, then try again.',
                                      'Hindi pa tama. Suriin ang pagkakasunod ng vf at vi at ang tanda, saka subukan muli.'),
                              style: const TextStyle(height: 1.4),
                            ),
                          ),
                        ]),
                  ),
          ),
          if (_ok == true) ...[
            const SizedBox(height: 12),
            BigButton(
                widget.sessionId != null &&
                        _round >= (widget.sessionId == 8 ? 5 : 4)
                    ? l10n(context, 'NEXT: CHALLENGE →', 'SUSUNOD: HAMON →')
                    : l10n(context, 'NEXT PROBLEM →', 'SUSUNOD NA PROBLEMA →'),
                color: C.orange,
                onTap: _next),
          ],
          const SizedBox(height: 16),
          AppCard(
            color: C.yellow.withValues(alpha: 0.2),
            child: Row(children: [
              const Icon(Icons.lightbulb, color: C.yellow),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(l10n(
                      context,
                      p.force != null
                          ? 'Hint: use Newton’s Second Law, a = Fnet / m'
                          : 'Hint: use the formula  a = (vf − vi) / t',
                      p.force != null
                          ? 'Pahiwatig: gamitin ang Ikalawang Batas ni Newton, a = Fnet / m'
                          : 'Pahiwatig: gamitin ang pormulang a = (vf − vi) / t'))),
            ]),
          ),
        ],
      ),
    );
  }
}

class _AccelerationProblem {
  final String vehicle;
  final double initial;
  final double finalVelocity;
  final double time;
  final String level;
  const _AccelerationProblem(
      this.vehicle, this.initial, this.finalVelocity, this.time, this.level);

  double get acceleration => (finalVelocity - initial) / time;
  String get prompt =>
      '$vehicle accelerates from ${fmt(initial)} m/s to ${fmt(finalVelocity)} m/s in ${fmt(time)} seconds. What is its acceleration?';
  String promptFor(bool tagalog) => tagalog
      ? '$vehicle bumibilis mula ${fmt(initial)} m/s hanggang ${fmt(finalVelocity)} m/s sa loob ng ${fmt(time)} segundo. Ano ang akselerasyon nito?'
      : prompt;
}

const _sessionOneProblems = <_AccelerationProblem>[
  _AccelerationProblem('A car', 10, 20, 4, 'Easy'),
  _AccelerationProblem('A cyclist', 18, 6, 3, 'Medium'),
  _AccelerationProblem('A motorcycle', 8, 28, 5, 'Challenging'),
  _AccelerationProblem('A train', 12, 36, 9, 'Challenging'),
];

class _SessionOnePracticeScreen extends StatefulWidget {
  const _SessionOnePracticeScreen();

  @override
  State<_SessionOnePracticeScreen> createState() =>
      _SessionOnePracticeScreenState();
}

class _SessionOnePracticeScreenState extends State<_SessionOnePracticeScreen> {
  final _vi = TextEditingController(text: '5');
  final _vf = TextEditingController(text: '15');
  final _time = TextEditingController(text: '5');
  final _answer = TextEditingController();
  final Set<int> _solved = {};
  int _selected = -1; // Warm-up auto-rickshaw example.
  bool? _correct;
  double? _computed;

  @override
  void dispose() {
    _vi.dispose();
    _vf.dispose();
    _time.dispose();
    _answer.dispose();
    super.dispose();
  }

  void _chooseProblem(int index) {
    final problem = _sessionOneProblems[index];
    setState(() {
      _selected = index;
      _correct = null;
      _computed = null;
      _vi.text = fmt(problem.initial);
      _vf.text = fmt(problem.finalVelocity);
      _time.text = fmt(problem.time);
      _answer.clear();
    });
  }

  void _submit() {
    final vi = double.tryParse(_vi.text.trim().replaceAll('−', '-'));
    final vf = double.tryParse(_vf.text.trim().replaceAll('−', '-'));
    final time = double.tryParse(_time.text.trim());
    final answer = double.tryParse(_answer.text.trim().replaceAll('−', '-'));
    if (vi == null ||
        vf == null ||
        time == null ||
        time <= 0 ||
        answer == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n(
              context,
              'Enter valid values and an acceleration answer.',
              'Maglagay ng wastong mga value at sagot sa akselerasyon.'))));
      return;
    }
    final correct = (answer - (vf - vi) / time).abs() < .01;
    AppScope.of(context).click();
    setState(() {
      _correct = correct;
      _computed = (vf - vi) / time;
      if (correct && _selected >= 0 && _solved.add(_selected)) {
        AppScope.of(context).solvedOne();
      }
    });
  }

  void _next() {
    if (_selected == -1) {
      _chooseProblem(0);
      return;
    }
    if (_solved.length == _sessionOneProblems.length) {
      go(context, const SessionChallengeScreen(sessionId: 1));
      return;
    }
    var next = -1;
    for (var i = 0; i < _sessionOneProblems.length; i++) {
      if (!_solved.contains(i)) {
        next = i;
        break;
      }
    }
    if (next >= 0) _chooseProblem(next);
  }

  @override
  Widget build(BuildContext context) {
    final allDone = _solved.length == _sessionOneProblems.length;
    final warmupDone = _selected == -1 && _correct == true;
    final currentDone = _selected >= 0 && _correct == true;
    final canContinue = allDone || warmupDone || currentDone;
    final nextLabel = allDone
        ? l10n(context, 'NEXT: CHALLENGE →', 'SUSUNOD: HAMON →')
        : _selected == -1
            ? l10n(context, 'START PRACTICE →', 'SIMULAN ANG PAGSASANAY →')
            : l10n(context, 'NEXT PROBLEM →', 'SUSUNOD NA PROBLEMA →');
    final title = _selected == -1
        ? 'An auto-rickshaw changes its velocity from 5 m/s to 15 m/s in 5 seconds. Calculate its acceleration.'
        : _sessionOneProblems[_selected]
            .promptFor(AppScope.of(context).tagalog);
    return Scaffold(
      appBar: AppBar(
          title: Text(
              l10n(context, 'Session 1 Practice', 'Pagsasanay sa Sesyon 1'))),
      bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
        SessionContinueBar(
            label: nextLabel, enabled: canContinue, onTap: _next),
        const SessionPageNavigationBar(
          sessionId: 1,
          currentPage: SessionPage.practice,
        ),
      ]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
              l10n(context, 'Calculate the Acceleration',
                  'Kalkulahin ang Akselerasyon'),
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: subText(context), height: 1.35)),
          const SizedBox(height: 12),
          AppCard(
            color: C.sky.withValues(alpha: .1),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l10n(context, 'ENTER THE VALUES', 'ILAGAY ANG MGA VALUE'),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              LayoutBuilder(builder: (context, constraints) {
                final width = (constraints.maxWidth - 16) / 3;
                return Row(children: [
                  _numberField(context, width, 'vi (m/s)', _vi),
                  const SizedBox(width: 8),
                  _numberField(context, width, 'vf (m/s)', _vf),
                  const SizedBox(width: 8),
                  _numberField(context, width, 't (s)', _time),
                ]);
              }),
              const SizedBox(height: 8),
              _numberField(
                  context,
                  double.infinity,
                  l10n(context, 'Your acceleration answer (m/s²)',
                      'Sagot sa akselerasyon (m/s²)'),
                  _answer),
              const SizedBox(height: 8),
              AppCard(
                padding: const EdgeInsets.all(10),
                color: C.purple.withValues(alpha: .1),
                child: Row(children: [
                  const Icon(Icons.functions_rounded, color: C.purple),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(l10n(context, 'FORMULA', 'PORMULA'),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const Text('a = (vf − vi) / t',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(
                            l10n(
                                context,
                                'a: acceleration   vf: final velocity   vi: initial velocity   t: time',
                                'a: akselerasyon   vf: panghuling bilis   vi: panimulang bilis   t: oras'),
                            style: TextStyle(
                                fontSize: 11, color: subText(context))),
                      ])),
                ]),
              ),
              const SizedBox(height: 10),
              BigButton(l10n(context, 'SUBMIT ANSWER', 'IPASA ANG SAGOT'),
                  icon: Icons.send_rounded, color: C.blue, onTap: _submit),
            ]),
          ),
          if (_correct != null) ...[
            const SizedBox(height: 10),
            AppCard(
              color: (_correct! ? C.green : C.red).withValues(alpha: .12),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(_correct! ? Icons.check_circle : Icons.cancel,
                    color: _correct! ? C.green : C.red),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(_correct!
                        ? l10n(
                            context,
                            'Correct! Acceleration = (${_vf.text} − ${_vi.text}) / ${_time.text} = ${fmt(_computed!)} m/s².',
                            'Tama! Akselerasyon = (${_vf.text} − ${_vi.text}) / ${_time.text} = ${fmt(_computed!)} m/s².')
                        : l10n(
                            context,
                            'Not quite. Use a = (vf − vi) / t, then try again.',
                            'Hindi pa tama. Gamitin ang a = (vf − vi) / t at subukang muli.'))),
              ]),
            ),
          ],
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
                child: Text(l10n(context, 'PRACTICE', 'PAGSASANAY'),
                    style: const TextStyle(
                        fontSize: 19, fontWeight: FontWeight.bold))),
            Text(
                l10n(
                    context,
                    'Solved ${_solved.length}/${_sessionOneProblems.length}',
                    'Nalutas ${_solved.length}/${_sessionOneProblems.length}'),
                style: TextStyle(
                    color: subText(context), fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 4),
          Text(
              l10n(context, 'Try these problems and build your skills.',
                  'Sagutan ang mga problema upang hasain ang iyong kakayahan.'),
              style: TextStyle(color: subText(context))),
          const SizedBox(height: 8),
          for (var i = 0; i < _sessionOneProblems.length; i++)
            _SessionProblemTile(
                index: i,
                problem: _sessionOneProblems[i],
                selected: _selected == i,
                solved: _solved.contains(i),
                tagalog: AppScope.of(context).tagalog,
                onTap: () => _chooseProblem(i)),
        ],
      ),
    );
  }

  Widget _numberField(BuildContext context, double width, String label,
          TextEditingController controller) =>
      SizedBox(
        width: width,
        child: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          decoration: InputDecoration(
            labelText: label,
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      );
}

class _SessionProblemTile extends StatelessWidget {
  final int index;
  final _AccelerationProblem problem;
  final bool selected;
  final bool solved;
  final bool tagalog;
  final VoidCallback onTap;
  const _SessionProblemTile(
      {required this.index,
      required this.problem,
      required this.selected,
      required this.solved,
      required this.tagalog,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = problem.level == 'Easy'
        ? C.green
        : problem.level == 'Medium'
            ? C.blue
            : C.orange;
    final level = tagalog
        ? (problem.level == 'Easy'
            ? 'Madali'
            : problem.level == 'Medium'
                ? 'Katamtaman'
                : 'Mahirap')
        : problem.level;
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        color: selected ? color.withValues(alpha: .12) : null,
        onTap: onTap,
        child: Row(children: [
          CircleAvatar(
              radius: 13,
              backgroundColor: color,
              child: Text('${index + 1}',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
          const SizedBox(width: 9),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(problem.promptFor(tagalog),
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
                Text(
                    solved
                        ? l10n(context, 'Solved', 'Nalutas')
                        : l10n(
                            context, 'Tap to answer', 'Pindutin upang sagutan'),
                    style: TextStyle(
                        fontSize: 11,
                        color: solved ? C.green : subText(context))),
              ])),
          Chip(
              label: Text(level, style: const TextStyle(fontSize: 10)),
              backgroundColor: color.withValues(alpha: .15),
              visualDensity: VisualDensity.compact,
              side: BorderSide.none),
          Icon(solved ? Icons.check_circle : Icons.chevron_right,
              color: solved ? C.green : subText(context), size: 20),
        ]),
      ),
    );
  }
}

class _SessionSevenPracticeScreen extends StatefulWidget {
  const _SessionSevenPracticeScreen();

  @override
  State<_SessionSevenPracticeScreen> createState() =>
      _SessionSevenPracticeScreenState();
}

class _SessionSevenPracticeScreenState
    extends State<_SessionSevenPracticeScreen> {
  final Map<int, int> _answers = {};

  static const _situations =
      <({String vehicle, String prompt, int answer, String reason})>[
    (
      vehicle: '🚗',
      prompt:
          'A car starts from rest and becomes faster. How does its velocity change?',
      answer: 0,
      reason:
          'The car is speeding up, so its velocity increases and it has positive acceleration.',
    ),
    (
      vehicle: '🚌',
      prompt: 'A bus slows down before a stop. How does its velocity change?',
      answer: 1,
      reason:
          'The bus is slowing down, so its speed decreases. Its acceleration is opposite its motion.',
    ),
    (
      vehicle: '🚴',
      prompt:
          'A bicycle turns while moving at the same speed. How does its velocity change?',
      answer: 2,
      reason:
          'The bicycle changes direction. Direction is part of velocity, so its velocity changes.',
    ),
    (
      vehicle: '✈️',
      prompt:
          'An airplane speeds up during takeoff. How does its velocity change?',
      answer: 0,
      reason:
          'The airplane is speeding up, so its velocity increases and it has positive acceleration.',
    ),
  ];

  static const _choices = [
    'Increasing speed (Positive acceleration)',
    'Decreasing speed (Negative acceleration)',
    'Changing direction',
  ];

  void _answer(int question, int choice) {
    if (_answers.containsKey(question)) return;
    setState(() => _answers[question] = choice);
    if (choice == _situations[question].answer) {
      AppScope.of(context).solvedOne();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tagalog = AppScope.of(context).tagalog;
    final complete = _answers.length == _situations.length;
    final score = _answers.entries
        .where((entry) => _situations[entry.key].answer == entry.value)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            l10n(context, 'Session 7 · Practice', 'Sesyon 7 · Pagsasanay')),
      ),
      bottomNavigationBar: const SessionPageNavigationBar(
        sessionId: 7,
        currentPage: SessionPage.practice,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0872D9), Color(0xFF063F9B)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 18),
          children: [
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF087BEA), Color(0xFF13B8E7)]),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Column(children: [
                Row(children: [
                  const Icon(Icons.edit_note_rounded,
                      color: Color(0xFFFFD83D), size: 34),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n(context, 'PRACTICE: Identify Acceleration',
                          'PAGSASANAY: Tukuyin ang Akselerasyon'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          height: 1.05),
                    ),
                  ),
                ]),
                const SizedBox(height: 7),
                Text(
                  l10n(
                      context,
                      'Read each situation and identify how velocity changes.',
                      'Basahin ang bawat sitwasyon at tukuyin kung paano nagbabago ang velocity.'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: C.navy, fontSize: 12, fontWeight: FontWeight.w800),
                ),
              ]),
            ),
            const SizedBox(height: 9),
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFB6EBFF), width: 2),
              ),
              child: Row(children: [
                Container(
                  width: 78,
                  height: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F5FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('🏍️', style: TextStyle(fontSize: 43)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n(context, 'EXAMPLE', 'HALIMBAWA'),
                            style: const TextStyle(
                                color: C.green,
                                fontSize: 13,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(height: 3),
                        Text(
                          l10n(
                              context,
                              'A motorcycle increases its speed from 10 m/s to 25 m/s.',
                              'Bumilis ang motorsiklo mula 10 m/s hanggang 25 m/s.'),
                          style: const TextStyle(
                              color: C.navy,
                              fontSize: 11,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n(
                              context,
                              'Increasing speed · Positive acceleration',
                              'Tumataas na bilis · Positibong akselerasyon'),
                          style: const TextStyle(
                              color: Color(0xFF14844F),
                              fontSize: 10,
                              fontWeight: FontWeight.w900),
                        ),
                      ]),
                ),
              ]),
            ),
            const SizedBox(height: 9),
            for (var i = 0; i < _situations.length; i++)
              _practiceQuestion(context, i, tagalog),
            if (complete) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(children: [
                  Text(
                    l10n(context, 'Practice complete: $score / 4',
                        'Tapos na: $score / 4'),
                    style: const TextStyle(
                        color: C.navy,
                        fontSize: 18,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  BigButton(
                    l10n(context, 'NEXT: CHALLENGE →', 'SUSUNOD: HAMON →'),
                    color: C.orange,
                    onTap: () =>
                        go(context, const SessionChallengeScreen(sessionId: 7)),
                  ),
                ]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _practiceQuestion(BuildContext context, int index, bool tagalog) {
    final item = _situations[index];
    final selected = _answers[index];
    final answeredCorrectly = selected == item.answer;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF9DE8F6), width: 2),
      ),
      child: Column(children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 29,
            height: 29,
            alignment: Alignment.center,
            decoration:
                const BoxDecoration(color: C.blue, shape: BoxShape.circle),
            child: Text('${index + 1}',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16)),
          ),
          const SizedBox(width: 7),
          Container(
            width: 62,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF7FD),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(item.vehicle, style: const TextStyle(fontSize: 35)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tagalog ? _scenarioTl(index) : item.prompt,
              style: const TextStyle(
                  color: C.navy, fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ),
        ]),
        const SizedBox(height: 7),
        for (var option = 0; option < _choices.length; option++)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed:
                    selected == null ? () => _answer(index, option) : null,
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                  backgroundColor: selected == null
                      ? const Color(0xFFF4FAFF)
                      : option == item.answer
                          ? const Color(0xFFDDF5E5)
                          : selected == option
                              ? const Color(0xFFFFE0E2)
                              : const Color(0xFFF4FAFF),
                  side: BorderSide(
                    color: selected != null && option == item.answer
                        ? C.green
                        : const Color(0xFFD2DEEA),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  '${String.fromCharCode(65 + option)}. ${tagalog ? _choiceTl(option) : _choices[option]}',
                  style: const TextStyle(
                      color: C.navy, fontSize: 10, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        if (selected != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: answeredCorrectly
                  ? const Color(0xFFE8F7ED)
                  : const Color(0xFFFFF3DF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              tagalog
                  ? answeredCorrectly
                      ? 'Tama! ${_reasonTl(index)}'
                      : 'Subukan itong paliwanag: ${_reasonTl(index)}'
                  : answeredCorrectly
                      ? 'Correct! ${item.reason}'
                      : 'Explanation: ${item.reason}',
              style: TextStyle(
                  color: answeredCorrectly
                      ? const Color(0xFF176B43)
                      : const Color(0xFF8B5C13),
                  fontSize: 10,
                  fontWeight: FontWeight.w700),
            ),
          ),
      ]),
    );
  }

  String _scenarioTl(int index) => const [
        'Huminto ang kotse at bumilis. Paano nagbabago ang velocity nito?',
        'Bumagal ang bus bago huminto. Paano nagbabago ang velocity nito?',
        'Lumiko ang bisikleta kahit pareho ang bilis. Paano nagbabago ang velocity nito?',
        'Bumibilis ang eroplano habang lumilipad paalis. Paano nagbabago ang velocity nito?',
      ][index];

  String _choiceTl(int index) => const [
        'Tumataas ang bilis (Positibong akselerasyon)',
        'Bumababa ang bilis (Negatibong akselerasyon)',
        'Nagbabago ang direksyon',
      ][index];

  String _reasonTl(int index) => const [
        'Bumibilis ang kotse kaya tumataas ang velocity nito.',
        'Bumabagal ang bus kaya bumababa ang bilis nito.',
        'Nagbabago ang direksyon ng bisikleta kaya nagbabago ang velocity.',
        'Bumibilis ang eroplano kaya tumataas ang velocity nito.',
      ][index];
}

class _ConceptPracticeScreen extends StatefulWidget {
  final int sessionId;
  const _ConceptPracticeScreen({required this.sessionId});

  @override
  State<_ConceptPracticeScreen> createState() => _ConceptPracticeScreenState();
}

class _ConceptPracticeScreenState extends State<_ConceptPracticeScreen> {
  int index = 0;
  int? selected;
  int score = 0;
  bool finished = false;

  List<Quiz> get questions => sessionQuizzes[widget.sessionId]!;

  void _select(int option) {
    if (selected != null || finished) return;
    setState(() {
      selected = option;
      if (option == questions[index].answer) {
        score++;
        AppScope.of(context).solvedOne();
      }
    });
  }

  void _next() {
    if (index == questions.length - 1) {
      setState(() => finished = true);
    } else {
      setState(() {
        index++;
        selected = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[index];
    final tagalog = AppScope.of(context).tagalog;
    return Scaffold(
      appBar: AppBar(
          title: Text(l10n(context, 'Session ${widget.sessionId} Practice',
              'Pagsasanay sa Sesyon ${widget.sessionId}'))),
      bottomNavigationBar: SessionPageNavigationBar(
        sessionId: widget.sessionId,
        currentPage: SessionPage.practice,
      ),
      body: finished
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.emoji_events_rounded,
                      color: C.yellow, size: 58),
                  const SizedBox(height: 12),
                  Text(
                      l10n(
                          context,
                          'Practice complete: $score / ${questions.length}',
                          'Tapos na ang pagsasanay: $score / ${questions.length}'),
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 14),
                  BigButton(l10n(context, 'TRY AGAIN', 'SUBUKAN MULI'),
                      onTap: () => setState(() {
                            index = 0;
                            selected = null;
                            score = 0;
                            finished = false;
                          })),
                  const SizedBox(height: 10),
                  BigButton(
                      l10n(context, 'NEXT: CHALLENGE →', 'SUSUNOD: HAMON →'),
                      color: C.orange,
                      onTap: () => go(context,
                          SessionChallengeScreen(sessionId: widget.sessionId))),
                ]),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AnimatedBar(
                    value:
                        (index + (selected == null ? 0 : 1)) / questions.length,
                    color: C.teal),
                const SizedBox(height: 8),
                Text(
                    l10n(
                        context,
                        'Practice ${index + 1} of ${questions.length}',
                        'Pagsasanay ${index + 1} sa ${questions.length}'),
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
                      onPressed: () => _select(i),
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
                              '${String.fromCharCode(65 + i)}. ${q.optionsFor(tagalog)[i]}')),
                    ),
                  ),
                if (selected != null) ...[
                  AppCard(
                      color: (selected == q.answer ? C.green : C.orange)
                          .withValues(alpha: .14),
                      child: Text(q.whyFor(tagalog))),
                  const SizedBox(height: 12),
                  BigButton(
                      l10n(
                          context,
                          index == questions.length - 1
                              ? 'FINISH PRACTICE'
                              : 'NEXT PROBLEM',
                          index == questions.length - 1
                              ? 'TAPUSIN'
                              : 'SUSUNOD'),
                      onTap: _next),
                ],
              ],
            ),
    );
  }
}

String _whoTl(String who) => const {
      'car': 'kotse',
      'auto rickshaw': 'auto-rickshaw',
      'bicycle': 'bisikleta',
      'train': 'tren',
      'bus': 'bus',
      'runner': 'mananakbo',
      'motorcycle': 'motorsiklo',
      'skateboarder': 'nag-i-skateboard',
      'graph': 'grap',
      'airplane': 'eroplano',
    }[who]!;

class _S2Example {
  final String emoji;
  final IconData? arrow;
  final String statement;
  final String statementTl;
  final int answer;
  final String reason;
  final String reasonTl;
  const _S2Example(this.emoji, this.arrow, this.statement, this.statementTl,
      this.answer, this.reason, this.reasonTl);
}

class _SessionTwoPracticeScreen extends StatefulWidget {
  const _SessionTwoPracticeScreen();

  @override
  State<_SessionTwoPracticeScreen> createState() =>
      _SessionTwoPracticeScreenState();
}

class _SessionTwoPracticeScreenState
    extends State<_SessionTwoPracticeScreen> {
  final Map<int, int> _answers = {};
  int _current = 0;

  static const _choices = ['SPEED', 'VELOCITY', 'ACCELERATION'];

  static const _examples = <_S2Example>[
    _S2Example(
        '🚴',
        null,
        'A bicycle travels at 15 m/s.',
        'May bisikletang gumagalaw sa 15 m/s.',
        0,
        'Only how fast the bicycle moves is given. No direction is included.',
        'Tanging kung gaano kabilis ang bisikleta ang binigay. Walang direksiyong kasama.'),
    _S2Example(
        '🚴',
        Icons.arrow_upward_rounded,
        'A bicycle travels at 15 m/s north.',
        'May bisikletang gumagalaw sa 15 m/s pahilaga.',
        1,
        'The statement gives both speed and direction.',
        'Binibigay ng pangungusap ang bilis at direksiyon.'),
    _S2Example(
        '🚌',
        null,
        'The Bachelor Tours bus increases its speed from 10 m/s to 20 m/s.',
        'Pinapabilis ang bus ng Bachelor Tours mula 10 m/s hanggang 20 m/s.',
        2,
        'Its velocity changed because its speed increased.',
        'Nagbago ang velocity nito dahil tumaas ang speed nito.'),
    _S2Example(
        '🚌',
        Icons.turn_right_rounded,
        'The Bachelor Tours bus travels at 20 m/s east and turns north.',
        'Gumagalaw ang bus ng Bachelor Tours sa 20 m/s pasilangan at lumiliko pahilaga.',
        2,
        'Its direction changed, so its velocity changed.',
        'Nagbago ang direksiyon nito, kaya nagbago ang velocity nito.'),
  ];

  void _answer(int index, int choice) {
    if (_answers.containsKey(index)) return;
    setState(() => _answers[index] = choice);
    if (choice == _examples[index].answer) {
      AppScope.of(context).solvedOne();
    }
  }

  void _next() {
    if (_current < _examples.length - 1) {
      setState(() => _current++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tagalog = AppScope.of(context).tagalog;
    final complete = _answers.length == _examples.length;
    final score = _answers.entries
        .where((entry) => _examples[entry.key].answer == entry.value)
        .length;

    return Scaffold(
      appBar: AppBar(
        title:
            Text(l10n(context, 'Session 2 · Practice', 'Sesyon 2 · Pagsasanay')),
      ),
      bottomNavigationBar: const SessionPageNavigationBar(
        sessionId: 2,
        currentPage: SessionPage.practice,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0872D9), Color(0xFF063F9B)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 18),
          children: [
            _header(context),
            const SizedBox(height: 9),
            Center(child: _progressDots()),
            const SizedBox(height: 9),
            _card(context, _current, tagalog),
            if (_answers.containsKey(_current) &&
                _current < _examples.length - 1) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton.icon(
                  onPressed: _next,
                  icon: const Icon(Icons.arrow_forward_rounded,
                      color: Colors.white),
                  label: Text(
                    l10n(context, 'Next Example', 'Susunod na Halimbawa'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 13),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: C.green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
            if (complete) ...[
              const SizedBox(height: 4),
              _scoreBanner(context, score),
              const SizedBox(height: 9),
            ],
            _rememberBanner(context),
            const SizedBox(height: 9),
            _placesFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark(context) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isDark(context)
                  ? Colors.white24
                  : const Color(0xFFB6EBFF),
              width: 2),
        ),
        child: Column(children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                  color: C.blue, shape: BoxShape.circle),
              child:
                  const Icon(Icons.info_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n(context, 'PRACTICE: Speed, Velocity, or Acceleration?',
                    'PAGSASANAY: Speed, Velocity, o Acceleration?'),
                style: TextStyle(
                    color: isDark(context) ? Colors.white : C.navy,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    height: 1.1),
              ),
            ),
          ]),
          const SizedBox(height: 7),
          Text(
            l10n(
                context,
                'Read each situation. Choose whether it describes SPEED, VELOCITY, or ACCELERATION. Then, check the reason why.',
                'Basahin ang bawat sitwasyon. Piliin kung ito ba ay SPEED, VELOCITY, o ACCELERATION. Pagkatapos, tingnan ang dahilan.'),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: isDark(context) ? Colors.white : C.blue,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                height: 1.3),
          ),
        ]),
      );

  Widget _card(BuildContext context, int index, bool tagalog) {
    final e = _examples[index];
    final answered = _answers.containsKey(index);
    final chosen = _answers[index];
    final correct = e.answer;
    final chipColors = [C.blue, C.teal, C.orange];

    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: isDark(context) ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: isDark(context)
                ? Colors.white24
                : const Color(0xFFB6EBFF),
            width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: C.blue,
              child: Text('${index + 1}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 5),
            Text(
                l10n(context, 'Example ${index + 1}',
                    'Halimbawa ${index + 1}'),
                style: TextStyle(
                    color: isDark(context) ? Colors.white : C.navy,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900)),
          ]),
          const SizedBox(height: 6),
          Container(
            height: 52,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F5FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(e.emoji, style: const TextStyle(fontSize: 32)),
                if (e.arrow != null)
                  Positioned(
                    bottom: 2,
                    right: 4,
                    child:
                        Icon(e.arrow, color: C.blue, size: 20),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n(context, e.statement, e.statementTl),
            style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: isDark(context) ? Colors.white : C.navy,
                height: 1.25),
          ),
          const SizedBox(height: 7),
          Row(children: [
            for (var c = 0; c < _choices.length; c++) ...[
              Expanded(
                child: GestureDetector(
                  onTap: answered ? null : () => _answer(index, c),
                  child: Container(
                    height: 23,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: !answered
                          ? chipColors[c].withValues(alpha: .14)
                          : (c == correct
                              ? chipColors[c]
                              : chipColors[c].withValues(alpha: .10)),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: answered && c == correct
                            ? chipColors[c]
                            : chipColors[c].withValues(alpha: .45),
                      ),
                    ),
                    child: Text(
                      _choices[c],
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        color: !answered || c == correct
                            ? (c == correct && answered
                                ? Colors.white
                                : chipColors[c])
                            : chipColors[c].withValues(alpha: .55),
                      ),
                    ),
                  ),
                ),
              ),
              if (c < _choices.length - 1) const SizedBox(width: 4),
            ],
          ]),
          if (answered) ...[
            const SizedBox(height: 6),
            Row(children: [
              Icon(chosen == correct
                  ? Icons.check_circle_rounded
                  : Icons.info_rounded,
                  color: chosen == correct
                      ? const Color(0xFF14844F)
                      : const Color(0xFFD32F2F),
                  size: 13),
              const SizedBox(width: 3),
              Flexible(
                child: Text(
                  l10n(
                      context,
                      chosen == correct
                          ? 'Correct Answer!'
                          : 'Not quite — the correct answer is ${_choices[correct]}',
                      chosen == correct
                          ? 'Tamang Sagot!'
                          : 'Mali — ang tamang sagot ay ${_choices[correct]}'),
                  style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: isDark(context) ? Colors.white : C.navy),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ]),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: C.purple,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.help_rounded, color: Colors.white, size: 11),
                const SizedBox(width: 3),
                Text(
                    l10n(context, 'Why?', 'Bakit?'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900)),
              ]),
            ),
            const SizedBox(height: 4),
            Text(
              l10n(context, e.reason, e.reasonTl),
              style: TextStyle(
                  fontSize: 9.8,
                  height: 1.3,
                  color: isDark(context) ? Colors.white70 : C.navy,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ],
      ),
    );
  }

  Widget _progressDots() => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < _examples.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: i == _current ? 26 : 9,
                height: 9,
                decoration: BoxDecoration(
                  color: i == _current
                      ? Colors.white
                      : _answers.containsKey(i)
                          ? Colors.white.withValues(alpha: .6)
                          : Colors.white.withValues(alpha: .3),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
        ],
      );

  Widget _scoreBanner(BuildContext context, int score) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: isDark(context) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(children: [
          Text(
            l10n(context, 'Practice complete: $score / 4',
                'Tapos na ang pagsasanay: $score / 4'),
            style: TextStyle(
                color: isDark(context) ? Colors.white : C.navy,
                fontSize: 15,
                fontWeight: FontWeight.w900),
          ),
        ]),
      );

  Widget _rememberBanner(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark(context) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration:
                const BoxDecoration(color: C.navy, shape: BoxShape.circle),
            child: const Icon(Icons.lightbulb_rounded,
                color: Color(0xFFFFD83D), size: 17),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      l10n(context, 'Remember!', 'Tandaan!'),
                      style: TextStyle(
                          color: isDark(context) ? Colors.white : C.navy,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(
                    l10n(
                        context,
                        'Speed tells how fast. Velocity tells how fast and where. Acceleration when the velocity changes.',
                        'Ang speed ay nagsasabi kung gaano kabilis. Ang velocity ay gaano kabilis at saan. Acceleration kapag nagbago ang velocity.'),
                    style: TextStyle(
                        fontSize: 9.8,
                        height: 1.3,
                        color: isDark(context) ? Colors.white70 : C.navy,
                        fontWeight: FontWeight.w600),
                  ),
                ]),
          ),
        ]),
      );

  Widget _placesFooter(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .16),
          borderRadius: BorderRadius.circular(999),
        ),
        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.location_on, color: Colors.white, size: 13),
          SizedBox(width: 5),
          Text(
            'TAGBINA, SURIGAO DEL SUR',
            style: TextStyle(
                color: Colors.white,
                fontSize: 9.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1),
          ),
        ]),
      );
}

class _S3Problem {
  final String statement;
  final String statementTl;
  final List<String> options;
  final List<String> optionsTl;
  final int answer;
  final String reason;
  final String reasonTl;
  const _S3Problem(this.statement, this.statementTl, this.options,
      this.optionsTl, this.answer, this.reason, this.reasonTl);
}

// NOTE: per physics, #1 = 2 m/s² to the right (20−10 N, 5 kg) and #3 = 40 N
// (15+25 N) — corrected from the poster's answer key.
const _s3Problems = <_S3Problem>[
  _S3Problem(
      'A box is pushed with 20 N to the right and 10 N to the left. Its mass is 5 kg. What is its acceleration?',
      'Tinulak ang kahon ng 20 N pakanan at 10 N pakaliwa. Ang masa nito ay 5 kg. Ano ang akselerasyon nito?',
      [
        '2 m/s² to the right',
        '3 m/s² to the right',
        '6 m/s² to the left',
        '10 m/s² to the right',
      ],
      [
        '2 m/s² pakanan',
        '3 m/s² pakanan',
        '6 m/s² pakaliwa',
        '10 m/s² pakanan',
      ],
      0,
      'Fnet = 20 − 10 = 10 N, so a = Fnet / m = 10 / 5 = 2 m/s² to the right.',
      'Fnet = 20 − 10 = 10 N, kaya a = Fnet / m = 10 / 5 = 2 m/s² pakanan.'),
  _S3Problem(
      'A car experiences a net force of 30 N. Its mass is 10 kg. What is its acceleration?',
      'Nakakaranas ang kotse ng netong puwersang 30 N. Ang masa nito ay 10 kg. Ano ang akselerasyon nito?',
      ['2 m/s²', '3 m/s²', '10 m/s²', '300 m/s²'],
      ['2 m/s²', '3 m/s²', '10 m/s²', '300 m/s²'],
      1,
      'a = Fnet / m = 30 / 10 = 3 m/s².',
      'a = Fnet / m = 30 / 10 = 3 m/s².'),
  _S3Problem(
      'Two students push a box to the right with forces of 15 N and 25 N. What is the total force if both push in the same direction?',
      'Nagtulak ang dalawang estudyante ng kahon pakanan gamit ang 15 N at 25 N. Ano ang kabuuang puwersa kung sa parehong direksyon sila nagtulak?',
      ['10 N', '25 N', '40 N', '50 N'],
      ['10 N', '25 N', '40 N', '50 N'],
      2,
      'Forces in the same direction add: 15 N + 25 N = 40 N.',
      'Pinagdaragdag ang mga puwersa sa parehong direksyon: 15 N + 25 N = 40 N.'),
  _S3Problem(
      'A 10 kg cart experiences a net force of 20 N to the left. What is its acceleration?',
      'Ang karitong 10 kg ay nakakaranas ng netong puwersang 20 N pakaliwa. Ano ang akselerasyon nito?',
      [
        '2 m/s² to the left',
        '2 m/s² to the right',
        '10 m/s² to the left',
        '200 m/s² to the right',
      ],
      [
        '2 m/s² pakaliwa',
        '2 m/s² pakanan',
        '10 m/s² pakaliwa',
        '200 m/s² pakanan',
      ],
      0,
      'a = Fnet / m = 20 / 10 = 2 m/s², same direction as the net force (left).',
      'a = Fnet / m = 20 / 10 = 2 m/s², pareho ng direksyon ng netong puwersa (pakaliwa).'),
  _S3Problem(
      'Two cars experience the same net force of 60 N. Car A has a mass of 10 kg while Car B has a mass of 20 kg. Which car has greater acceleration?',
      'Pareho ang netong puwersang 60 N ng dalawang kotse. Ang Car A ay may masang 10 kg habang ang Car B ay 20 kg. Aling kotse ang mas malaki ang akselerasyon?',
      [
        'Car A',
        'Car B',
        'Both have the same acceleration',
        'Neither car accelerates',
      ],
      [
        'Car A',
        'Car B',
        'Pareho ito ng akselerasyon',
        'Walang umaakselerasyon sa kanila',
      ],
      0,
      'a = Fnet / m. Same force but smaller mass gives bigger acceleration: Car A = 6 m/s², Car B = 3 m/s².',
      'a = Fnet / m. Parehong puwersa pero mas maliit na masa ay mas malaking akselerasyon: Car A = 6 m/s², Car B = 3 m/s².'),
];

class _SessionThreePracticeScreen extends StatefulWidget {
  const _SessionThreePracticeScreen();

  @override
  State<_SessionThreePracticeScreen> createState() =>
      _SessionThreePracticeScreenState();
}

class _SessionThreePracticeScreenState
    extends State<_SessionThreePracticeScreen> {
  final Map<int, int> _answers = {};

  static const _problemColors = [C.red, C.orange, C.green, C.blue, C.navy];
  static const _letterColors = [C.red, C.orange, C.green, Color(0xFF8BC34A)];

  void _answer(int problem, int option) {
    if (_answers.containsKey(problem)) return;
    setState(() => _answers[problem] = option);
    if (option == _s3Problems[problem].answer) {
      AppScope.of(context).solvedOne();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tagalog = AppScope.of(context).tagalog;
    final complete = _answers.length == _s3Problems.length;
    final score = _answers.entries
        .where((entry) => _s3Problems[entry.key].answer == entry.value)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            l10n(context, 'Session 3 · Practice', 'Sesyon 3 · Pagsasanay')),
      ),
      bottomNavigationBar: const SessionPageNavigationBar(
        sessionId: 3,
        currentPage: SessionPage.practice,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0872D9), Color(0xFF063F9B)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 18),
          children: [
            _header(context),
            const SizedBox(height: 9),
            for (var i = 0; i < _s3Problems.length; i++)
              _problemCard(context, i, tagalog),
            if (complete) ...[
              const SizedBox(height: 9),
              _scoreBanner(context, score),
              const SizedBox(height: 9),
              BigButton(
                l10n(context, 'NEXT: CHALLENGE →', 'SUSUNOD: HAMON →'),
                color: C.orange,
                onTap: () =>
                    go(context, const SessionChallengeScreen(sessionId: 3)),
              ),
            ],
            const SizedBox(height: 9),
            _rememberBanner(context),
            const SizedBox(height: 9),
            _placesFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF087BEA), Color(0xFF13B8E7)]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(children: [
          Text(l10n(context, 'PRACTICE', 'PAGSASANAY'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  height: 1.0)),
          const SizedBox(height: 4),
          Text(
              l10n(context, 'Net Force Causes Acceleration',
                  'Sanhi ng Akselerasyon ang Netong Puwersa'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color(0xFFFFD83D),
                  fontSize: 14,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 5),
          Text(
            l10n(context, 'Solve each problem. Choose the correct answer.',
                'Lutasin ang bawat problema. Piliin ang tamang sagot.'),
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700),
          ),
        ]),
      );

  Widget _problemCard(BuildContext context, int index, bool tagalog) {
    final p = _s3Problems[index];
    final answered = _answers.containsKey(index);
    final chosen = _answers[index];
    final correct = p.answer;
    final dark = isDark(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: dark ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: dark ? Colors.white24 : const Color(0xFFB6EBFF), width: 2),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _problemColors[index],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('${index + 1}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900)),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  l10n(context, p.statement, p.statementTl),
                  style: TextStyle(
                      fontSize: 11.5,
                      height: 1.3,
                      fontWeight: FontWeight.w800,
                      color: dark ? Colors.white : C.navy),
                ),
              ),
            ]),
            const SizedBox(height: 7),
            _illustration(context, index, dark),
            const SizedBox(height: 7),
            Row(children: [
              _chip(context, index, 0, dark),
              const SizedBox(width: 4),
              _chip(context, index, 1, dark),
            ]),
            const SizedBox(height: 5),
            Row(children: [
              _chip(context, index, 2, dark),
              const SizedBox(width: 4),
              _chip(context, index, 3, dark),
            ]),
            if (answered) ...[
              const SizedBox(height: 6),
              Row(children: [
                Icon(
                    chosen == correct
                        ? Icons.check_circle_rounded
                        : Icons.info_rounded,
                    color: chosen == correct
                        ? const Color(0xFF14844F)
                        : const Color(0xFFD32F2F),
                    size: 13),
                const SizedBox(width: 3),
                Flexible(
                  child: Text(
                    l10n(
                        context,
                        chosen == correct
                            ? 'Correct Answer!'
                            : 'Not quite — check the green answer',
                        chosen == correct
                            ? 'Tamang Sagot!'
                            : 'Hindi tama — tingnan ang berdeng sagot'),
                    style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: dark ? Colors.white : C.navy),
                  ),
                ),
              ]),
              const SizedBox(height: 5),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFDDF5E5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l10n(context, p.reason, p.reasonTl),
                  style: const TextStyle(
                      fontSize: 9.8,
                      height: 1.3,
                      color: Color(0xFF176B43),
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ]),
    );
  }

  Widget _chip(BuildContext context, int problem, int option, bool dark) {
    final p = _s3Problems[problem];
    final answered = _answers.containsKey(problem);
    final chosen = _answers[problem];
    final isCorrect = option == p.answer;
    final letterColor = _letterColors[option];
    final color = !answered
        ? letterColor.withValues(alpha: .14)
        : isCorrect
            ? const Color(0xFFDDF5E5)
            : chosen == option
                ? const Color(0xFFFFE0E2)
                : letterColor.withValues(alpha: .10);
    final borderColor = !answered
        ? letterColor.withValues(alpha: .45)
        : isCorrect
            ? C.green
            : chosen == option
                ? C.red
                : Colors.transparent;
    return Expanded(
      child: GestureDetector(
        onTap: answered ? null : () => _answer(problem, option),
        child: Container(
          constraints: const BoxConstraints(minHeight: 30),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: Row(children: [
            Container(
              width: 17,
              height: 17,
              alignment: Alignment.center,
              decoration:
                  BoxDecoration(color: letterColor, shape: BoxShape.circle),
              child: Text(String.fromCharCode(65 + option),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                l10n(context, p.options[option], p.optionsTl[option]),
                style: TextStyle(
                    fontSize: 8.8,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    color: dark ? Colors.white : C.navy),
                maxLines: 3,
                overflow: TextOverflow.visible,
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _illustration(BuildContext context, int index, bool dark) {
    final List<Widget> kids;
    switch (index) {
      case 0:
        kids = [
          _forceTag('10 N', C.blue, Icons.arrow_back_rounded),
          const SizedBox(width: 5),
          _crateBox(),
          const SizedBox(width: 5),
          _forceTag('20 N', C.red, Icons.arrow_forward_rounded),
          const SizedBox(width: 7),
          _massTag('m = 5 kg'),
        ];
        break;
      case 1:
        kids = [
          _forceTag('30 N', C.red, Icons.arrow_forward_rounded),
          const SizedBox(width: 5),
          const Text('🚗', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 7),
          _massTag('m = 10 kg'),
        ];
        break;
      case 2:
        kids = [
          _pushingStudent(),
          const SizedBox(width: 3),
          _forceTag('15 N', C.red, Icons.arrow_forward_rounded),
          const SizedBox(width: 4),
          _crateBox(),
          const SizedBox(width: 4),
          _forceTag('25 N', C.red, Icons.arrow_forward_rounded),
          const SizedBox(width: 3),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.diagonal3Values(-1, 1, 1),
            child: _pushingStudent(),
          ),
        ];
        break;
      case 3:
        kids = [
          _forceTag('20 N', C.blue, Icons.arrow_back_rounded),
          const SizedBox(width: 5),
          const Text('🛒', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 7),
          _massTag('m = 10 kg'),
        ];
        break;
      default:
        kids = [
          _carCompare('Car A', '🚗', 'm = 10 kg'),
          const SizedBox(width: 10),
          _carCompare('Car B', '🚙', 'm = 20 kg'),
          const SizedBox(width: 10),
          _forceTag('Fnet = 60 N', C.blue, Icons.arrow_forward_rounded),
        ];
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFE6F5FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Wrap(
          spacing: 6,
          runSpacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: kids),
    );
  }

  Widget _forceTag(String label, Color color, IconData icon) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(999)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 2),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w900)),
        ]),
      );

  Widget _crateBox() => Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: const Color(0xffad6b3b),
          border: Border.all(color: C.navy, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.grid_on_rounded,
            size: 13, color: Color(0xffffd79b)),
      );

  // Student pushing right, from the user-provided sprite image.
  Widget _pushingStudent() => SizedBox(
        width: 34,
        height: 30,
        child: Image.asset('assets/images/pushing_student.png',
            fit: BoxFit.cover, alignment: Alignment.center),
      );

  Widget _massTag(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: C.navy, width: 1),
        ),
        child: Text(text,
            style: const TextStyle(
                fontSize: 8.5,
                fontWeight: FontWeight.w900,
                color: C.navy)),
      );

  Widget _carCompare(String name, String emoji, String mass) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(name,
              style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: C.navy)),
          Text(emoji, style: const TextStyle(fontSize: 17)),
          Text(mass,
              style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: C.navy)),
        ],
      );

  Widget _scoreBanner(BuildContext context, int score) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: isDark(context) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(children: [
          Text(
            l10n(context, 'Practice complete: $score / 5',
                'Tapos na ang pagsasanay: $score / 5'),
            style: TextStyle(
                color: isDark(context) ? Colors.white : C.navy,
                fontSize: 15,
                fontWeight: FontWeight.w900),
          ),
        ]),
      );

  Widget _rememberBanner(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark(context) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration:
                const BoxDecoration(color: C.navy, shape: BoxShape.circle),
            child: const Icon(Icons.lightbulb_rounded,
                color: Color(0xFFFFD83D), size: 17),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n(context, 'Remember!', 'Tandaan!'),
                      style: TextStyle(
                          color: isDark(context) ? Colors.white : C.navy,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(
                    l10n(
                        context,
                        'a = Fnet / m. Acceleration depends on the net force and the mass.',
                        'a = Fnet / m. Nakadepende ang akselerasyon sa netong puwersa at sa masa.'),
                    style: TextStyle(
                        fontSize: 9.8,
                        height: 1.3,
                        color: isDark(context) ? Colors.white70 : C.navy,
                        fontWeight: FontWeight.w600),
                  ),
                ]),
          ),
        ]),
      );

  Widget _placesFooter(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .16),
          borderRadius: BorderRadius.circular(999),
        ),
        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.location_on, color: Colors.white, size: 13),
          SizedBox(width: 5),
          Text(
            'TAGBINA, SURIGAO DEL SUR',
            style: TextStyle(
                color: Colors.white,
                fontSize: 9.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1),
          ),
        ]),
      );
}

class _S4Problem {
  final String emoji;
  final String statement;
  final String statementTl;
  final double vi;
  final double vf;
  final double t;
  final double a;
  const _S4Problem(
      this.emoji, this.statement, this.statementTl, this.vi, this.vf, this.t, this.a);
}

const _s4Problems = <_S4Problem>[
  _S4Problem(
      '🚗',
      'A car changes from 5 m/s to 15 m/s in 5 seconds.',
      'Ang kotse ay nagbago mula 5 m/s hanggang 15 m/s sa loob ng 5 segundo.',
      5, 15, 5, 2),
  _S4Problem(
      '🚴',
      'A bicycle changes from 4 m/s to 16 m/s in 6 seconds.',
      'Ang bisikleta ay nagbago mula 4 m/s hanggang 16 m/s sa loob ng 6 segundo.',
      4, 16, 6, 2),
  _S4Problem(
      '🚌',
      'A bus changes from 10 m/s to 30 m/s in 10 seconds.',
      'Ang bus ay nagbago mula 10 m/s hanggang 30 m/s sa loob ng 10 segundo.',
      10, 30, 10, 2),
  _S4Problem(
      '🚚',
      'A truck changes from 20 m/s to 5 m/s in 5 seconds.',
      'Ang truck ay nagbago mula 20 m/s hanggang 5 m/s sa loob ng 5 segundo.',
      20, 5, 5, -3),
];

class _SessionFourPracticeScreen extends StatefulWidget {
  const _SessionFourPracticeScreen();

  @override
  State<_SessionFourPracticeScreen> createState() =>
      _SessionFourPracticeScreenState();
}

class _SessionFourPracticeScreenState
    extends State<_SessionFourPracticeScreen> {
  final Map<int, bool> _solved = {};
  final Map<int, bool> _wrong = {};
  late final List<TextEditingController> _ctrls;

  @override
  void initState() {
    super.initState();
    _ctrls = [
      for (var i = 0; i < _s4Problems.length; i++) TextEditingController()
    ];
  }

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _check(int index) {
    final p = _s4Problems[index];
    final raw = _ctrls[index].text.replaceAll('−', '-');
    final v = double.tryParse(raw);
    final scope = AppScope.of(context);
    scope.click();
    if (v == null) return;
    if ((v - p.a).abs() < 0.01) {
      if (_solved[index] != true) scope.solvedOne();
      setState(() {
        _solved[index] = true;
        _wrong.remove(index);
      });
    } else {
      setState(() => _wrong[index] = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final complete = _solved.length == _s4Problems.length;
    final score = _solved.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            l10n(context, 'Session 4 · Practice', 'Sesyon 4 · Pagsasanay')),
      ),
      bottomNavigationBar: const SessionPageNavigationBar(
        sessionId: 4,
        currentPage: SessionPage.practice,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0872D9), Color(0xFF063F9B)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 18),
          children: [
            _header(context),
            const SizedBox(height: 9),
            for (var i = 0; i < _s4Problems.length; i++)
              _problemCard(context, i),
            if (complete) ...[
              const SizedBox(height: 9),
              _scoreBanner(context, score),
              const SizedBox(height: 9),
              BigButton(
                l10n(context, 'NEXT: CHALLENGE →', 'SUSUNOD: HAMON →'),
                color: C.orange,
                onTap: () =>
                    go(context, const SessionChallengeScreen(sessionId: 4)),
              ),
            ],
            const SizedBox(height: 9),
            _rememberBanner(context),
            const SizedBox(height: 9),
            _placesFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF087BEA), Color(0xFF13B8E7)]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(children: [
          Row(children: [
            const Icon(Icons.search_rounded,
                color: Color(0xFFFFD83D), size: 30),
            const SizedBox(width: 8),
            Expanded(
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: l10n(context, 'PRACTICE: ', 'PAGSASANAY: '),
                      style: const TextStyle(
                          color: Color(0xFFFFD83D), fontSize: 16.5)),
                  TextSpan(
                      text: l10n(context, 'SOLVE FOR ACCELERATION',
                          'SOLUSYUNAN ANG AKSELERASYON'),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 15)),
                ]),
                style: const TextStyle(fontWeight: FontWeight.w900, height: 1.05),
              ),
            ),
          ]),
          const SizedBox(height: 6),
          Text(
            l10n(
                context,
                'Find the acceleration using the formula. Show your solution.',
                'Hanapin ang akselerasyon gamit ang pormula. Ipakita ang solusyon.'),
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 10.5,
                fontWeight: FontWeight.w700),
          ),
        ]),
      );

  Widget _problemCard(BuildContext context, int index) {
    final p = _s4Problems[index];
    final solved = _solved[index] == true;
    final wrong = _wrong[index] == true;
    final dark = isDark(context);
    final badgeColor = const [C.red, C.orange, C.green, C.blue][index];
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: dark ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: dark ? Colors.white24 : const Color(0xFFB6EBFF), width: 2),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('${index + 1}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900)),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              l10n(context, p.statement, p.statementTl),
              style: TextStyle(
                  fontSize: 11.5,
                  height: 1.3,
                  fontWeight: FontWeight.w800,
                  color: dark ? Colors.white : C.navy),
            ),
          ),
        ]),
        const SizedBox(height: 6),
        IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            width: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F5FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(p.emoji, style: const TextStyle(fontSize: 27)),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: C.blue.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n(context, 'Given:', 'Bigay:'),
                        style: const TextStyle(
                            color: C.blue,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: .5)),
                    const SizedBox(height: 2),
                    Text('vᵢ = ${fmt(p.vi)} m/s',
                        style: TextStyle(
                            color: dark ? Colors.white : C.navy,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            height: 1.25)),
                    Text('v_f = ${fmt(p.vf)} m/s',
                        style: TextStyle(
                            color: dark ? Colors.white : C.navy,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            height: 1.25)),
                    Text('t = ${fmt(p.t)} s',
                        style: TextStyle(
                            color: dark ? Colors.white : C.navy,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            height: 1.25)),
                  ]),
            ),
          ),
        ]),
        ),
        const SizedBox(height: 7),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration:
              BoxDecoration(color: C.blue, borderRadius: BorderRadius.circular(999)),
          child: Text(l10n(context, 'Solution:', 'Solusyon:'),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w900)),
        ),
        const SizedBox(height: 4),
        Text('a = (vf − vi) ÷ t',
            style: TextStyle(
                color: dark ? Colors.white : C.navy,
                fontSize: 12,
                fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        if (!solved) ...[
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: const Color(0xFFFFC7D9),
                  borderRadius: BorderRadius.circular(999)),
              child: Text(l10n(context, 'Acceleration', 'Akselerasyon'),
                  style: const TextStyle(
                      color: C.navy,
                      fontSize: 9,
                      fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: TextField(
                controller: _ctrls[index],
                readOnly: wrong,
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: C.navy),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: '?',
                  hintStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: C.navy),
                  suffixText: ' m/s²',
                  suffixStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: C.navy),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: wrong ? C.red : const Color(0xFFB6EBFF),
                          width: 1.4)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: C.blue, width: 1.4)),
                ),
                onChanged: (_) {
                  if (wrong) setState(() => _wrong.remove(index));
                },
                onSubmitted: (_) => _check(index),
              ),
            ),
            const SizedBox(width: 6),
            SizedBox(
              height: 32,
              width: 44,
              child: ElevatedButton(
                onPressed: () => _check(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: C.blue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Icon(Icons.check_rounded, size: 19),
              ),
            ),
          ]),
          if (wrong) ...[
            const SizedBox(height: 5),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.info_rounded,
                  color: Color(0xFFB41F07), size: 13),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                    l10n(
                        context,
                        'Not quite. Take vf − vi first, then divide by t. Watch the sign!',
                        'Hindi pa tama. Kunin muna ang vf − vi, tapos hatiin sa t. Pansinin ang tanda!'),
                    style: const TextStyle(
                        color: Color(0xFFB41F07),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        height: 1.25)),
              ),
            ]),
          ],
        ] else ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFDDF5E5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('a = ( ${fmt(p.vf)} − ${fmt(p.vi)} ) ÷ ${fmt(p.t)}',
                      style: const TextStyle(
                          color: C.navy,
                          fontSize: 11,
                          fontWeight: FontWeight.w800)),
                  Text('a = ${fmt(p.vf - p.vi)} ÷ ${fmt(p.t)}',
                      style: const TextStyle(
                          color: C.navy,
                          fontSize: 11,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(
                      l10n(context, 'Acceleration = ${fmt(p.a)} m/s²',
                          'Akselerasyon = ${fmt(p.a)} m/s²'),
                      style: const TextStyle(
                          color: Color(0xFF176B43),
                          fontSize: 12,
                          fontWeight: FontWeight.w900)),
                ]),
          ),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.check_circle_rounded,
                color: Color(0xFF14844F), size: 14),
            const SizedBox(width: 4),
            Text(l10n(context, 'Correct Answer!', 'Tamang Sagot!'),
                style: const TextStyle(
                    color: Color(0xFF14844F),
                    fontSize: 10,
                    fontWeight: FontWeight.w900)),
          ]),
        ],
      ]),
    );
  }

  Widget _scoreBanner(BuildContext context, int score) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: isDark(context) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            l10n(context, 'Practice complete: $score / 4',
                'Tapos na ang pagsasanay: $score / 4'),
            style: TextStyle(
                color: isDark(context) ? Colors.white : C.navy,
                fontSize: 15,
                fontWeight: FontWeight.w900),
          ),
        ),
      );

  Widget _rememberBanner(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark(context) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration:
                const BoxDecoration(color: C.navy, shape: BoxShape.circle),
            child: const Icon(Icons.lightbulb_rounded,
                color: Color(0xFFFFD83D), size: 17),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n(context, 'Remember!', 'Tandaan!'),
                      style: TextStyle(
                          color: isDark(context) ? Colors.white : C.navy,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text('a = (vf − vi) ÷ t',
                      style: TextStyle(
                          color: isDark(context) ? Colors.white : C.navy,
                          fontSize: 15,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(
                    l10n(
                        context,
                        'Acceleration is the change in velocity divided by time.',
                        'Ang akselerasyon ay ang pagbabago ng velocity na hinati sa oras.'),
                    style: TextStyle(
                        fontSize: 9.8,
                        height: 1.3,
                        color: isDark(context) ? Colors.white70 : C.navy,
                        fontWeight: FontWeight.w600),
                  ),
                ]),
          ),
        ]),
      );

  Widget _placesFooter(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .16),
          borderRadius: BorderRadius.circular(999),
        ),
        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.location_on, color: Colors.white, size: 13),
          SizedBox(width: 5),
          Text(
            'TAGBINA, SURIGAO DEL SUR',
            style: TextStyle(
                color: Colors.white,
                fontSize: 9.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1),
          ),
        ]),
      );
}
