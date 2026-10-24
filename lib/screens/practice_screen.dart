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
      return _ConceptPracticeScreen(sessionId: widget.sessionId!);
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
