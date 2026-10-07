import 'package:flutter/material.dart';
import '../theme.dart';

// Everything here is bundled inside the app, so AccelLab works fully offline.

enum Motion { intro, positive, negative, zero, formula }

class Lesson {
  final int id;
  final int difficulty;
  final String title;
  final String short;
  final String body;
  final String? remember;
  final String? formula;
  final String? example;
  final Motion motion;
  final Color color;
  const Lesson({
    required this.id,
    required this.difficulty,
    required this.title,
    required this.short,
    required this.body,
    required this.motion,
    required this.color,
    this.remember,
    this.formula,
    this.example,
  });

  String titleFor(bool tagalog) =>
      tagalog ? (_lessonTitlesTl[id] ?? title) : title;
  String shortFor(bool tagalog) =>
      tagalog ? (_lessonShortsTl[id] ?? short) : short;
  String bodyFor(bool tagalog) =>
      tagalog ? (_lessonBodiesTl[id] ?? body) : body;
  String? rememberFor(bool tagalog) =>
      tagalog ? (_lessonRemindersTl[id] ?? remember) : remember;
  String? exampleFor(bool tagalog) =>
      tagalog ? (_lessonExamplesTl[id] ?? example) : example;
}

const List<Lesson> lessons = [
  Lesson(
    id: 1,
    difficulty: 1,
    title: 'What is Acceleration?',
    short: 'Acceleration tells us how quickly velocity changes.',
    body: 'Acceleration tells us how quickly velocity changes.\n\n'
        'A car that goes from 0 m/s to 5 m/s to 10 m/s is speeding up. '
        'Its velocity changes every second.',
    remember: 'Acceleration happens when velocity changes.',
    motion: Motion.intro,
    color: C.sky,
  ),
  Lesson(
    id: 2,
    difficulty: 1,
    title: 'Positive Acceleration',
    short: 'When an object speeds up, it has positive acceleration.',
    body: 'When an object speeds up, it has positive acceleration.\n\n'
        'Watch the dots: they spread further apart as the car gains speed.',
    remember: 'Speeding up means positive acceleration.',
    motion: Motion.positive,
    color: C.teal,
  ),
  Lesson(
    id: 3,
    difficulty: 1,
    title: 'Negative Acceleration',
    short: 'When an object slows down, it has negative acceleration.',
    body: 'When an object slows down, it has negative acceleration.\n\n'
        'Braking is a good example. The dots bunch closer together as the '
        'car loses speed.',
    remember: 'Slowing down means negative acceleration.',
    motion: Motion.negative,
    color: C.orange,
  ),
  Lesson(
    id: 4,
    difficulty: 1,
    title: 'Zero Acceleration',
    short: 'When velocity stays constant, acceleration is zero.',
    body: 'When velocity stays constant, acceleration is zero.\n\n'
        'A car cruising at a steady speed covers the same distance every '
        'second, so the dots stay evenly spaced.',
    remember: 'Constant velocity means zero acceleration.',
    motion: Motion.zero,
    color: C.yellow,
  ),
  Lesson(
    id: 5,
    difficulty: 2,
    title: 'Acceleration Formula',
    short: 'a = (vf − vi) / t',
    body: 'Use this formula to calculate acceleration:',
    formula: 'a = (vf − vi) / t',
    example:
        'a = acceleration\nvf = final velocity\nvi = initial velocity\nt = time\n\n'
        'Worked example:\nA car speeds up from 0 m/s to 20 m/s in 4 seconds.\n'
        'a = (20 − 0) / 4 = 5 m/s²',
    motion: Motion.formula,
    color: C.purple,
  ),
  Lesson(
    id: 6,
    difficulty: 2,
    title: 'Acceleration and Direction',
    short: 'The sign of acceleration depends on your chosen direction.',
    body: 'Choose one direction as positive before interpreting acceleration. '
        'If a cart moves to the right and speeds up, its acceleration is positive. '
        'If it moves right and slows down, its acceleration points left and is negative.\n\n'
        'An object moving left can have positive acceleration when it is slowing down. '
        'The sign describes direction, while speeding up or slowing down depends on how velocity and acceleration point.',
    remember:
        'Velocity and acceleration in the same direction: speed increases. In opposite directions: speed decreases.',
    motion: Motion.negative,
    color: C.blue,
  ),
  Lesson(
    id: 7,
    difficulty: 2,
    title: 'Reading a Velocity–Time Graph',
    short: 'The slope of a velocity–time graph is acceleration.',
    body:
        'A velocity–time graph shows how velocity changes over time. Acceleration is the graph’s slope: change in velocity divided by change in time.\n\n'
        'An upward sloping line means positive acceleration, a downward sloping line means negative acceleration, and a horizontal line means zero acceleration.',
    formula: 'a = (v₂ − v₁) / (t₂ − t₁)',
    example:
        'If velocity rises from 4 m/s at 2 s to 16 m/s at 6 s, then a = (16 − 4) / (6 − 2) = 3 m/s².',
    motion: Motion.formula,
    color: C.teal,
  ),
  Lesson(
    id: 8,
    difficulty: 3,
    title: 'Finding Final Velocity',
    short: 'Use elapsed time and acceleration to predict velocity.',
    body:
        'When acceleration is constant, final velocity equals initial velocity plus acceleration multiplied by elapsed time. Keep track of direction with positive and negative signs.',
    formula: 'vf = vi + at',
    example:
        'A runner moving at 3 m/s accelerates at 2 m/s² for 5 s. vf = 3 + (2 × 5) = 13 m/s.',
    motion: Motion.formula,
    color: C.orange,
  ),
  Lesson(
    id: 9,
    difficulty: 3,
    title: 'Displacement with Constant Acceleration',
    short: 'Calculate how far an object travels while its velocity changes.',
    body:
        'For constant acceleration, displacement can be found from initial velocity, time, and acceleration. This works even when the object is slowing down, as long as signs are consistent.',
    formula: 'Δx = vi t + ½at²',
    example:
        'A bike starts at 2 m/s and accelerates at 1.5 m/s² for 4 s. Δx = (2 × 4) + ½(1.5)(4²) = 20 m.',
    motion: Motion.formula,
    color: C.purple,
  ),
  Lesson(
    id: 10,
    difficulty: 3,
    title: 'Acceleration from a Graph',
    short: 'Find acceleration over an interval using graph values.',
    body:
        'Select two points on a velocity–time graph and calculate rise over run. For a curved graph, this gives average acceleration across the interval; the slope at one instant is instantaneous acceleration.',
    formula: 'Average a = Δv / Δt',
    example:
        'A graph shows velocity changing from −4 m/s to 8 m/s over 3 s. Average acceleration = (8 − (−4)) / 3 = 4 m/s².',
    motion: Motion.formula,
    color: C.sky,
  ),
  Lesson(
    id: 11,
    difficulty: 4,
    title: 'Multi-Stage Motion',
    short: 'Break a journey into stages and track velocity between them.',
    body:
        'Many motion problems have multiple stages. Calculate the velocity at the end of each stage, then use that velocity as the starting value for the next stage. Keep each time interval and sign separate.',
    formula: 'Stage by stage: vf = vi + at',
    example:
        'A vehicle starts at 4 m/s, accelerates at 2 m/s² for 3 s, then brakes at −1 m/s² for 4 s. After stage 1: 10 m/s. After stage 2: 6 m/s.',
    motion: Motion.formula,
    color: C.orange,
  ),
  Lesson(
    id: 12,
    difficulty: 4,
    title: 'Braking Distance and Reaction Time',
    short:
        'Separate the distance traveled before braking from the braking distance.',
    body:
        'A driver travels during reaction time before the brakes take effect, then continues moving while slowing down. Total stopping distance is reaction distance plus braking distance. Use consistent units and remember that braking acceleration is opposite the motion.',
    formula: 'Stopping distance = reaction distance + braking distance',
    example:
        'At 20 m/s, a 0.75 s reaction takes 15 m. With braking acceleration −5 m/s², the relation vf² = vi² + 2aΔx gives 40 m of braking distance, for 55 m total.',
    motion: Motion.negative,
    color: C.red,
  ),
  Lesson(
    id: 13,
    difficulty: 4,
    title: 'Choose the Right Motion Equation',
    short:
        'Solve unfamiliar problems by identifying known and unknown quantities.',
    body:
        'Constant-acceleration problems can use several linked equations. List the known values, identify the requested value, and choose an equation that contains those quantities without adding unnecessary unknowns. Check units and whether the answer’s direction makes sense.',
    formula: 'vf² = vi² + 2aΔx',
    example:
        'A car slows from 24 m/s to rest with acceleration −6 m/s². Δx = (0² − 24²) / (2 × −6) = 48 m.',
    motion: Motion.formula,
    color: C.yellow,
  ),
];

const Map<int, String> _lessonTitlesTl = {
  1: 'Ano ang Akselerasyon?',
  2: 'Positibong Akselerasyon',
  3: 'Negatibong Akselerasyon',
  4: 'Serong Akselerasyon',
  5: 'Pormula ng Akselerasyon',
  6: 'Akselerasyon at Direksiyon',
  7: 'Pagbasa ng Grap ng Bilis at Oras',
  8: 'Paghahanap ng Huling Bilis',
  9: 'Displacement sa Pare-parehong Akselerasyon',
  10: 'Akselerasyon mula sa Grap',
  11: 'Galaw na May Maraming Yugto',
  12: 'Distansiya ng Pagpreno at Oras ng Reaksiyon',
  13: 'Pagpili ng Tamang Ekuwasyon ng Galaw',
};

const Map<int, String> _lessonShortsTl = {
  1: 'Ipinapakita ng akselerasyon kung gaano kabilis nagbabago ang bilis.',
  2: 'May positibong akselerasyon kapag bumibilis ang isang bagay.',
  3: 'May negatibong akselerasyon kapag bumabagal ang isang bagay.',
  4: 'Serong akselerasyon kapag hindi nagbabago ang bilis.',
  5: 'a = (vf − vi) / t',
  6: 'Nakadepende sa piniling direksiyon ang tanda ng akselerasyon.',
  7: 'Akselerasyon ang slope ng grap ng bilis at oras.',
  8: 'Gamitin ang oras at akselerasyon upang malaman ang huling bilis.',
  9: 'Kalkulahin ang nilakbay habang nagbabago ang bilis.',
  10: 'Kunin ang akselerasyon mula sa mga halaga sa grap.',
  11: 'Hatiin sa mga yugto ang biyahe at subaybayan ang bilis.',
  12: 'Paghiwalayin ang distansiya sa reaksiyon at sa pagpreno.',
  13: 'Lutasin ang mga problema sa pamamagitan ng pagpili ng angkop na pormula.',
};

const Map<int, String> _lessonBodiesTl = {
  1: 'Ipinapakita ng akselerasyon kung gaano kabilis nagbabago ang bilis.\n\n'
      'Bumibilis ang kotse kapag nagbabago ang takbo nito mula 0 m/s papuntang 5 m/s at saka 10 m/s. Nagbabago ang bilis nito bawat segundo.',
  2: 'May positibong akselerasyon kapag bumibilis ang isang bagay.\n\n'
      'Pansinin ang mga tuldok: palayo nang palayo ang pagitan ng mga ito habang bumibilis ang kotse.',
  3: 'May negatibong akselerasyon kapag bumabagal ang isang bagay.\n\n'
      'Halimbawa nito ang pagpreno. Nagdidikit ang mga tuldok habang bumabagal ang kotse.',
  4: 'Serong akselerasyon kapag hindi nagbabago ang bilis.\n\n'
      'Pare-pareho ang distansiyang nalalakbay bawat segundo ng kotse na bumibiyahe sa tuloy-tuloy na bilis, kaya magkakapantay ang pagitan ng mga tuldok.',
  5: 'Gamitin ang pormulang ito upang kalkulahin ang akselerasyon:',
  6: 'Pumili muna ng direksiyong ituturing na positibo. Kung gumagalaw pakanan ang kariton at bumibilis ito, positibo ang akselerasyon. Kung pakanan ito ngunit bumabagal, pakaliwa ang akselerasyon kaya negatibo ang tanda.\n\n'
      'Maaari ring positibo ang akselerasyon ng bagay na gumagalaw pakaliwa kung bumabagal ito. Ipinapakita ng tanda ang direksiyon; nakadepende naman sa pagtutugma ng bilis at akselerasyon kung bumibilis o bumabagal ang bagay.',
  7: 'Ipinapakita ng grap ng bilis at oras kung paano nagbabago ang bilis sa paglipas ng oras. Ang slope nito ang akselerasyon: pagbabago ng bilis na hinati sa pagbabago ng oras.\n\n'
      'Ang linyang pataas ay nangangahulugang positibong akselerasyon; pababang linya ay negatibo; at pahalang na linya ay sero.',
  8: 'Kapag pare-pareho ang akselerasyon, ang huling bilis ay katumbas ng panimulang bilis dagdag ang akselerasyon na minultiplika sa lumipas na oras. Gamitin nang tama ang positibo at negatibong tanda upang maisama ang direksiyon.',
  9: 'Kapag pare-pareho ang akselerasyon, makukuha ang displacement mula sa panimulang bilis, oras, at akselerasyon. Gumagana ito kahit bumabagal ang bagay basta pare-pareho ang paggamit ng mga tanda.',
  10: 'Pumili ng dalawang punto sa grap ng bilis at oras at kalkulahin ang taas na hinati sa haba. Sa kurbadong grap, katamtamang akselerasyon ang makukuha sa pagitan ng dalawang punto; ang slope sa isang sandali naman ang agarang akselerasyon.',
  11: 'May ilang problema sa galaw na binubuo ng maraming yugto. Kalkulahin ang bilis sa dulo ng bawat yugto at gamitin iyon bilang panimulang bilis ng susunod. Itala nang magkahiwalay ang oras at tanda ng bawat yugto.',
  12: 'May distansiyang nalalakbay ang drayber habang nagrereaksiyon bago gumana ang preno, at may dagdag na distansiya habang bumabagal ang sasakyan. Ang kabuuang distansiya ng paghinto ay distansiya sa reaksiyon dagdag ang distansiya sa pagpreno. Panatilihing magkakapareho ang unit at tandaan na salungat sa direksiyon ng galaw ang akselerasyon sa pagpreno.',
  13: 'May ilang magkaugnay na pormula para sa galaw na may pare-parehong akselerasyon. Ilista ang mga alam na halaga, tukuyin ang hinahanap, at piliin ang pormulang naglalaman ng mga iyon nang walang dagdag na hindi kailangang unknown. Suriin ang mga unit at kung makatuwiran ang direksiyon ng sagot.',
};

const Map<int, String> _lessonRemindersTl = {
  1: 'May akselerasyon kapag nagbabago ang bilis.',
  2: 'Ang pagbilis ay nangangahulugan ng positibong akselerasyon.',
  3: 'Ang pagbagal ay nangangahulugan ng negatibong akselerasyon.',
  4: 'Nangangahulugan ng serong akselerasyon ang hindi nagbabagong bilis.',
  6: 'Kapag magkapareho ang direksiyon ng bilis at akselerasyon, bumibilis ang bagay. Kapag magkasalungat, bumabagal ito.',
};

const Map<int, String> _lessonExamplesTl = {
  1: 'Halimbawa: Nagbabago ang bilis ng kotse mula 0 m/s papuntang 20 m/s sa loob ng 4 na segundo.\na = (20 − 0) / 4 = 5 m/s²',
  5: 'a = akselerasyon\nvf = huling bilis\nvi = panimulang bilis\nt = oras\n\nHalimbawa:\nBumilis ang kotse mula 0 m/s hanggang 20 m/s sa loob ng 4 na segundo.\na = (20 − 0) / 4 = 5 m/s²',
  6: 'Kung bumibilis ang kariton habang gumagalaw pakanan, positibo ang akselerasyon nito. Kung bumabagal ito, negatibo ang akselerasyon.',
  7: 'Kung tumaas ang bilis mula 4 m/s sa 2 s hanggang 16 m/s sa 6 s, a = (16 − 4) / (6 − 2) = 3 m/s².',
  8: 'Gumagalaw ang mananakbo sa 3 m/s at bumibilis nang 2 m/s² sa loob ng 5 s. vf = 3 + (2 × 5) = 13 m/s.',
  9: 'Nagsisimula ang bisikleta sa 2 m/s at bumibilis nang 1.5 m/s² sa loob ng 4 s. Δx = (2 × 4) + ½(1.5)(4²) = 20 m.',
  10: 'Nagbabago ang bilis mula −4 m/s hanggang 8 m/s sa loob ng 3 s. Katamtamang akselerasyon = (8 − (−4)) / 3 = 4 m/s².',
  11: 'Nagsisimula ang sasakyan sa 4 m/s, bumibilis nang 2 m/s² sa loob ng 3 s, at saka nagpreno nang −1 m/s² sa loob ng 4 s. Pagkatapos ng unang yugto: 10 m/s. Pagkatapos ng ikalawa: 6 m/s.',
  12: 'Sa bilis na 20 m/s, nakakabiyahe ng 15 m sa loob ng 0.75 s na reaksiyon. Sa akselerasyong −5 m/s², 40 m ang distansiya ng pagpreno, kaya 55 m ang kabuuang distansiya.',
  13: 'Bumagal ang kotse mula 24 m/s hanggang huminto sa akselerasyong −6 m/s². Δx = (0² − 24²) / (2 × −6) = 48 m.',
};

class Example {
  final String name;
  final IconData icon;
  final String story;
  final String question;
  final bool answer;
  final String why;
  const Example(
      this.name, this.icon, this.story, this.question, this.answer, this.why);
}

const List<Example> examples = [
  Example(
    'Car',
    Icons.directions_car,
    'A car waits at a red light. When the light turns green, it starts moving and reaches 20 m/s.',
    'Is the car accelerating?',
    true,
    'Its velocity is changing (getting faster).',
  ),
  Example(
    'Bicycle',
    Icons.pedal_bike,
    'A bicycle accelerates when it changes from a slow speed to a faster speed.',
    'Is the bicycle accelerating?',
    true,
    'The bicycle is accelerating because its velocity is changing (getting faster).',
  ),
  Example(
    'Bus',
    Icons.directions_bus,
    'A bus travels along a straight road at a steady 15 m/s.',
    'Is the bus accelerating?',
    false,
    'Its velocity is not changing, so the acceleration is zero.',
  ),
  Example(
    'Elevator',
    Icons.elevator,
    'An elevator slows down smoothly as it arrives at the top floor.',
    'Is the elevator accelerating?',
    true,
    'Slowing down is a change in velocity, so it has negative acceleration.',
  ),
  Example(
    'Ball',
    Icons.sports_soccer,
    'A ball is thrown straight up and slows down as it rises.',
    'Is the ball accelerating?',
    true,
    'Its velocity keeps changing (getting slower), so it has negative acceleration.',
  ),
  Example(
    'Airplane',
    Icons.flight,
    'An airplane cruises at a constant speed in a straight line.',
    'Is the airplane accelerating?',
    false,
    'A constant velocity means zero acceleration.',
  ),
];

class Quiz {
  final String q;
  final List<String> options;
  final int answer;
  final String why;
  final int lessonId;
  const Quiz(this.q, this.options, this.answer, this.why, this.lessonId);
  String questionFor(bool tagalog) => tagalog ? (_quizQuestionsTl[q] ?? q) : q;
  List<String> optionsFor(bool tagalog) => tagalog
      ? options.map((option) => _quizWordsTl[option] ?? option).toList()
      : options;
  String whyFor(bool tagalog) =>
      tagalog ? (_quizExplanationsTl[why] ?? why) : why;
}

const List<Quiz> quiz = [
  Quiz(
    'A motorcycle changes from 5 m/s to 15 m/s in 5 seconds. What is its acceleration?',
    ['1 m/s²', '2 m/s²', '3 m/s²', '5 m/s²'],
    1,
    'a = (15 − 5) / 5 = 2 m/s²',
    5,
  ),
  Quiz(
    'A car speeds up from 0 m/s to 20 m/s in 4 seconds. What is its acceleration?',
    ['20 m/s²', '80 m/s²', '5 m/s²', '4 m/s²'],
    2,
    'a = (20 − 0) / 4 = 5 m/s²',
    5,
  ),
  Quiz(
    'A train slows from 30 m/s to 10 m/s in 10 seconds. What is its acceleration?',
    ['−2 m/s²', '2 m/s²', '−3 m/s²', '−20 m/s²'],
    0,
    'a = (10 − 30) / 10 = −2 m/s². The negative sign means it is slowing down.',
    3,
  ),
  Quiz(
    'An object moves with constant velocity. Its acceleration is…',
    ['Zero', 'Positive', 'Negative', 'Infinite'],
    0,
    'Constant velocity means no change in velocity, so acceleration is zero.',
    4,
  ),
  Quiz(
    'Which situation describes negative acceleration?',
    [
      'An object speeding up',
      'An object slowing down',
      'An object at constant speed',
      'An object at rest'
    ],
    1,
    'Slowing down means velocity decreases, which is negative acceleration.',
    3,
  ),
  Quiz(
    'Which is the unit of acceleration?',
    ['m', 'm/s', 's²', 'm/s²'],
    3,
    'Acceleration is change in velocity (m/s) per second, so m/s².',
    5,
  ),
  Quiz(
    'A cyclist speeds up from 2 m/s to 8 m/s in 3 seconds. What is the acceleration?',
    ['1 m/s²', '3 m/s²', '2 m/s²', '6 m/s²'],
    2,
    'a = (8 − 2) / 3 = 2 m/s²',
    2,
  ),
  Quiz(
    'A runner speeds up from 0 to 6 m/s in 2 seconds. What is the acceleration?',
    ['3 m/s²', '12 m/s²', '6 m/s²', '0.33 m/s²'],
    0,
    'a = (6 − 0) / 2 = 3 m/s²',
    2,
  ),
  Quiz(
    'Starting from rest, an object accelerates at 3 m/s² for 4 seconds. What is its final velocity?',
    ['7 m/s', '12 m/s', '1.3 m/s', '24 m/s'],
    1,
    'vf = vi + a × t = 0 + 3 × 4 = 12 m/s',
    5,
  ),
  Quiz(
    'Acceleration tells us how quickly ___ changes.',
    ['Position', 'Velocity', 'Mass', 'Distance'],
    1,
    'Acceleration is the rate of change of velocity.',
    1,
  ),
];

const Map<String, String> _quizQuestionsTl = {
  'A motorcycle changes from 5 m/s to 15 m/s in 5 seconds. What is its acceleration?':
      'Nagbago ang bilis ng motorsiklo mula 5 m/s hanggang 15 m/s sa loob ng 5 segundo. Ano ang akselerasyon nito?',
  'A car speeds up from 0 m/s to 20 m/s in 4 seconds. What is its acceleration?':
      'Bumilis ang kotse mula 0 m/s hanggang 20 m/s sa loob ng 4 na segundo. Ano ang akselerasyon nito?',
  'A train slows from 30 m/s to 10 m/s in 10 seconds. What is its acceleration?':
      'Bumagal ang tren mula 30 m/s hanggang 10 m/s sa loob ng 10 segundo. Ano ang akselerasyon nito?',
  'An object moves with constant velocity. Its acceleration is…':
      'Gumagalaw ang bagay sa hindi nagbabagong bilis. Ano ang akselerasyon nito?',
  'Which situation describes negative acceleration?':
      'Aling sitwasyon ang naglalarawan ng negatibong akselerasyon?',
  'Which is the unit of acceleration?': 'Alin ang yunit ng akselerasyon?',
  'A cyclist speeds up from 2 m/s to 8 m/s in 3 seconds. What is the acceleration?':
      'Bumilis ang siklista mula 2 m/s hanggang 8 m/s sa loob ng 3 segundo. Ano ang akselerasyon nito?',
  'A runner speeds up from 0 to 6 m/s in 2 seconds. What is the acceleration?':
      'Bumilis ang mananakbo mula 0 hanggang 6 m/s sa loob ng 2 segundo. Ano ang akselerasyon nito?',
  'Starting from rest, an object accelerates at 3 m/s² for 4 seconds. What is its final velocity?':
      'Mula sa pahinga, bumilis ang bagay nang 3 m/s² sa loob ng 4 na segundo. Ano ang huling bilis nito?',
  'Acceleration tells us how quickly ___ changes.':
      'Ipinapakita ng akselerasyon kung gaano kabilis nagbabago ang ___.',
};
const Map<String, String> _quizWordsTl = {
  'Zero': 'Sero',
  'Positive': 'Positibo',
  'Negative': 'Negatibo',
  'Infinite': 'Walang hanggan',
  'An object speeding up': 'Bagay na bumibilis',
  'An object slowing down': 'Bagay na bumabagal',
  'An object at constant speed': 'Bagay na hindi nagbabago ang bilis',
  'An object at rest': 'Bagay na nakahinto',
  'Position': 'Posisyon',
  'Velocity': 'Bilis',
  'Mass': 'Masa',
  'Distance': 'Distansiya',
};
const Map<String, String> _quizExplanationsTl = {
  'a = (15 − 5) / 5 = 2 m/s²': 'a = (15 − 5) / 5 = 2 m/s²',
  'a = (20 − 0) / 4 = 5 m/s²': 'a = (20 − 0) / 4 = 5 m/s²',
  'a = (10 − 30) / 10 = −2 m/s². The negative sign means it is slowing down.':
      'a = (10 − 30) / 10 = −2 m/s². Ipinapakita ng negatibong tanda na bumabagal ito.',
  'Constant velocity means no change in velocity, so acceleration is zero.':
      'Walang pagbabago sa bilis kapag pare-pareho ito, kaya sero ang akselerasyon.',
  'Slowing down means velocity decreases, which is negative acceleration.':
      'Bumababa ang bilis kapag bumabagal, kaya negatibo ang akselerasyon.',
  'Acceleration is change in velocity (m/s) per second, so m/s².':
      'Pagbabago ng bilis (m/s) bawat segundo ang akselerasyon, kaya m/s² ang yunit nito.',
  'a = (8 − 2) / 3 = 2 m/s²': 'a = (8 − 2) / 3 = 2 m/s²',
  'a = (6 − 0) / 2 = 3 m/s²': 'a = (6 − 0) / 2 = 3 m/s²',
  'vf = vi + a × t = 0 + 3 × 4 = 12 m/s':
      'vf = vi + a × t = 0 + 3 × 4 = 12 m/s',
  'Acceleration is the rate of change of velocity.':
      'Ang akselerasyon ay bilis ng pagbabago ng velocity.',
};

class Level {
  final String name;
  final String desc;
  final Color color;
  final String nameTl;
  final String descTl;
  const Level(this.name, this.desc, this.color, this.nameTl, this.descTl);
  String nameFor(bool tagalog) => tagalog ? nameTl : name;
  String descFor(bool tagalog) => tagalog ? descTl : desc;
}

const List<Level> levels = [
  Level(
      'Beginner',
      'Core ideas: changing velocity, speeding up, slowing down, and steady motion',
      C.green,
      'Baguhan',
      'Mga pangunahing ideya: pagbabago ng bilis, pagbilis, pagbagal, at tuloy-tuloy na galaw'),
  Level(
      'Intermediate',
      'Use acceleration formulas, direction, and velocity–time graphs',
      C.blue,
      'Katamtaman',
      'Gumamit ng mga pormula, direksiyon, at grap ng bilis at oras'),
  Level(
      'Advanced',
      'Combine equations and interpret motion over intervals',
      C.yellow,
      'Mas Mahirap',
      'Pagsamahin ang mga ekuwasyon at unawain ang galaw sa iba’t ibang pagitan ng oras'),
  Level(
      'Expert',
      'Solve multi-stage and real-world acceleration problems',
      C.orange,
      'Dalubhasa',
      'Lutasin ang mga problemang may maraming yugto at totoong sitwasyon'),
];
