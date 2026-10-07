import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

class _Problem {
  final String who;
  final double vi;
  final double vf;
  final double t;
  final double a;
  const _Problem(this.who, this.vi, this.vf, this.t, this.a);
}

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final _rnd = math.Random();
  final _ctrl = TextEditingController();
  late _Problem _p;
  bool? _ok;
  bool _counted = false;

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
    setState(() {
      _p = _gen();
      _ok = null;
      _counted = false;
      _ctrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final p = _p;

    return Scaffold(
      appBar: AppBar(
          title: Text(l10n(
              context, 'Calculation Practice', 'Pagsasanay sa Pagkalkula'))),
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
                      l10n(
                          context,
                          'A ${p.who} changes its velocity from ${fmt(p.vi)} m/s to ${fmt(p.vf)} m/s in ${fmt(p.t)} seconds. What is its acceleration?',
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
                        '${l10n(context, 'Initial velocity', 'Panimulang bilis')}   =  ${fmt(p.vi)} m/s\n'
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
                                      'Correct!\na = (${fmt(p.vf)} − ${fmt(p.vi)}) / ${fmt(p.t)} = ${fmt(p.a)} m/s²',
                                      'Tama!\na = (${fmt(p.vf)} − ${fmt(p.vi)}) / ${fmt(p.t)} = ${fmt(p.a)} m/s²')
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
            BigButton(l10n(context, 'NEXT PROBLEM →', 'SUSUNOD NA PROBLEMA →'),
                color: C.orange, onTap: _next),
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
                      'Hint: use the formula  a = (vf − vi) / t',
                      'Pahiwatig: gamitin ang pormulang a = (vf − vi) / t'))),
            ]),
          ),
        ],
      ),
    );
  }
}

String _whoTl(String who) => const {
      'car': 'kotse',
      'bicycle': 'bisikleta',
      'train': 'tren',
      'bus': 'bus',
      'runner': 'mananakbo',
      'motorcycle': 'motorsiklo',
    }[who]!;
