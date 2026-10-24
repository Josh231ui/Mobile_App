import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/content.dart';

// Everything is saved on the device with SharedPreferences (no internet).
class AppState extends ChangeNotifier {
  late SharedPreferences _p;

  Set<int> completed = {};
  int bestScore = 0;
  int challengesDone = 0;
  int problemsSolved = 0;
  bool usedSimulator = false;
  int session1RushUnlocked = 1;

  bool sound = true;
  bool animation = true;
  bool dark = false;
  bool tagalog = false;
  double textScale = 1.0;

  Future<void> load() async {
    _p = await SharedPreferences.getInstance();
    // Earlier releases stored topic IDs with a different curriculum. Clear only
    // those completion flags so old topics cannot unlock the new sessions.
    if ((_p.getInt('curriculumVersion') ?? 1) < 2) {
      await _p.remove('completed');
      await _p.setInt('curriculumVersion', 2);
    }
    completed =
        (_p.getStringList('completed') ?? <String>[]).map(int.parse).toSet();
    bestScore = _p.getInt('bestScore') ?? 0;
    challengesDone = _p.getInt('challengesDone') ?? 0;
    problemsSolved = _p.getInt('problemsSolved') ?? 0;
    usedSimulator = _p.getBool('usedSimulator') ?? false;
    session1RushUnlocked =
        (_p.getInt('session1RushUnlocked') ?? 1).clamp(1, 4).toInt();
    sound = _p.getBool('sound') ?? true;
    animation = _p.getBool('animation') ?? true;
    dark = _p.getBool('dark') ?? false;
    tagalog = _p.getBool('tagalog') ?? false;
    textScale = _p.getDouble('textScale') ?? 1.0;
  }

  void _save() {
    _p.setStringList('completed', completed.map((e) => e.toString()).toList());
    _p.setInt('bestScore', bestScore);
    _p.setInt('challengesDone', challengesDone);
    _p.setInt('problemsSolved', problemsSolved);
    _p.setBool('usedSimulator', usedSimulator);
    _p.setInt('session1RushUnlocked', session1RushUnlocked);
    _p.setBool('sound', sound);
    _p.setBool('animation', animation);
    _p.setBool('dark', dark);
    _p.setBool('tagalog', tagalog);
    _p.setDouble('textScale', textScale);
    notifyListeners();
  }

  // ----- progress numbers -----
  double get lessonsPct => completed.length / lessons.length;
  double get practicePct => (problemsSolved > 10 ? 10 : problemsSolved) / 10;
  double get challengePct => bestScore / quiz.length;
  double get overall => (lessonsPct + practicePct + challengePct) / 3;

  int get level {
    var current = 1;
    for (var difficulty = 1; difficulty < levels.length; difficulty++) {
      final sessions =
          lessons.where((lesson) => lesson.difficulty == difficulty);
      if (sessions.isNotEmpty &&
          sessions.every((lesson) => completed.contains(lesson.id))) {
        current = difficulty + 1;
      } else {
        break;
      }
    }
    return current;
  }

  bool isDifficultyUnlocked(int difficulty) => difficulty <= level;

  // ----- actions -----
  void toggleLesson(int id) {
    if (completed.contains(id)) {
      completed.remove(id);
    } else {
      completed.add(id);
    }
    _save();
  }

  void completeLesson(int id) {
    if (completed.add(id)) _save();
  }

  void completeRushLevel(int level) {
    if (level == session1RushUnlocked && session1RushUnlocked < 4) {
      session1RushUnlocked++;
      _save();
    }
  }

  void solvedOne() {
    problemsSolved++;
    _save();
  }

  void simulatorUsed() {
    if (!usedSimulator) {
      usedSimulator = true;
      _save();
    }
  }

  void recordChallenge(int score, {int total = 10}) {
    challengesDone++;
    final normalized = total == 0 ? 0 : (score * quiz.length / total).round();
    if (normalized > bestScore) bestScore = normalized;
    _save();
  }

  void resetProgress() {
    completed = {};
    bestScore = 0;
    challengesDone = 0;
    problemsSolved = 0;
    usedSimulator = false;
    session1RushUnlocked = 1;
    _save();
  }

  void setSound(bool v) {
    sound = v;
    _save();
  }

  void setAnimation(bool v) {
    animation = v;
    _save();
  }

  void setDark(bool v) {
    dark = v;
    _save();
  }

  void setTagalog(bool v) {
    tagalog = v;
    _save();
  }

  void setTextScale(double v) {
    textScale = v;
    _save();
  }

  void click() {
    if (sound) SystemSound.play(SystemSoundType.click);
  }
}

// Gives every screen access to the app state.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
