import 'package:flutter/material.dart';
import '../data/content.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

class ExamplesScreen extends StatefulWidget {
  const ExamplesScreen({super.key});

  @override
  State<ExamplesScreen> createState() => _ExamplesScreenState();
}

class _ExamplesScreenState extends State<ExamplesScreen> {
  int sel = 1;
  bool? answered; // what the learner picked (true = YES)

  void _answer(bool yes) {
    AppScope.of(context).click();
    setState(() => answered = yes);
  }

  @override
  Widget build(BuildContext context) {
    final ex = examples[sel];
    final correct = answered == ex.answer;

    return Scaffold(
      appBar: AppBar(title: const Text('Acceleration in Real Life')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.15,
            children: [
              for (int i = 0; i < examples.length; i++)
                Reveal(
                  index: i,
                  child: GestureDetector(
                    onTap: () => setState(() {
                      sel = i;
                      answered = null;
                    }),
                    child: AnimatedScale(
                      scale: sel == i ? 1.06 : 1,
                      duration: const Duration(milliseconds: 250),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        decoration: BoxDecoration(
                          color: sel == i ? C.blue.withValues(alpha: 0.15) : cardColor(context),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: sel == i ? C.blue : Colors.transparent, width: 2),
                        ),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(examples[i].icon,
                              size: 32, color: sel == i ? C.blue : subText(context)),
                          const SizedBox(height: 4),
                          Text(examples[i].name,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        ]),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: KeyedSubtree(
              key: ValueKey(sel),
              child: AppCard(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Icon(ex.icon, color: C.blue),
                    const SizedBox(width: 8),
                    Text(ex.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ]),
                  const SizedBox(height: 10),
                  Text(ex.story, style: const TextStyle(fontSize: 15, height: 1.4)),
                  const SizedBox(height: 14),
                  Text(ex.question,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                      child: BigButton('YES',
                          color: C.green, onTap: answered == null ? () => _answer(true) : null),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: BigButton('NO',
                          color: C.red, onTap: answered == null ? () => _answer(false) : null),
                    ),
                  ]),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: answered == null
                        ? const SizedBox(width: double.infinity)
                        : Container(
                            key: ValueKey(answered),
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: (correct ? C.green : C.red).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Icon(correct ? Icons.check_circle : Icons.cancel,
                                  color: correct ? C.green : C.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${correct ? 'Correct!' : 'Not quite.'} ${ex.why}',
                                  style: const TextStyle(height: 1.4),
                                ),
                              ),
                            ]),
                          ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
