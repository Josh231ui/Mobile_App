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
    title: 'Introduction to Acceleration',
    short: 'Understand how velocity changes over time.',
    body: 'Acceleration describes how quickly velocity changes over time. '
        'An object accelerates when it speeds up, slows down, or changes direction. '
        'Velocity includes both speed and direction, so a turning vehicle can accelerate even when its speed stays the same.',
    remember: 'A change in velocity means acceleration.',
    formula: 'a = (vf − vi) / t',
    example: 'An auto-rickshaw changes from 0 m/s to 12 m/s in 6 s.\n'
        'a = (12 − 0) / 6 = 2 m/s²',
    motion: Motion.intro,
    color: C.sky,
  ),
  Lesson(
    id: 2,
    difficulty: 1,
    title: 'Speed vs. Velocity',
    short: 'Compare speed, velocity, and changes in direction.',
    body:
        'Speed tells how fast an object moves. Velocity tells how fast and in what direction. '
        'A bicycle traveling around a bend changes velocity because its direction changes, even if its speed stays constant. '
        'Acceleration is the change in velocity over time.',
    remember: 'Velocity includes direction; speed does not.',
    motion: Motion.positive,
    color: C.teal,
  ),
  Lesson(
    id: 3,
    difficulty: 2,
    title: 'Net Force Causes Acceleration',
    short: 'Relate net force, mass, and acceleration with Newton’s Second Law.',
    body:
        'A net force changes an object’s velocity. Newton’s Second Law states that acceleration equals net force divided by mass. A larger net force creates more acceleration for the same mass; a larger mass needs more force for the same acceleration. Acceleration points in the direction of the net force.',
    remember: 'Fnet = ma; acceleration points in the direction of net force.',
    formula: 'a = Fnet / m',
    example: 'A 2 kg cart experiences a net force of 6 N.\na = 6 / 2 = 3 m/s²',
    motion: Motion.formula,
    color: C.orange,
  ),
  Lesson(
    id: 4,
    difficulty: 2,
    title: 'Acceleration Formula',
    short: 'Calculate acceleration from initial and final velocity and time.',
    body:
        'Subtract the initial velocity from the final velocity, then divide by elapsed time. Keep velocity signs consistent when direction matters. Acceleration is measured in meters per second squared (m/s²).',
    remember: 'Identify vi, vf, and t before substituting.',
    formula: 'a = (vf − vi) / t',
    example:
        'A car changes from 4 m/s to 16 m/s in 4 s.\na = (16 − 4) / 4 = 3 m/s²',
    motion: Motion.formula,
    color: C.purple,
  ),
  Lesson(
    id: 5,
    difficulty: 3,
    title: 'Positive and Negative Acceleration',
    short: 'Interpret acceleration signs using both velocity and direction.',
    body:
        'The sign of acceleration shows its direction relative to the chosen positive direction. It does not alone tell whether an object speeds up or slows down. Velocity and acceleration in the same direction increase speed; opposite directions decrease speed.',
    remember:
        'Same direction: speed increases. Opposite directions: speed decreases.',
    formula: 'Same signs → speeding up\nOpposite signs → slowing down',
    example:
        'Moving right at +20 m/s with a = −2 m/s² means the object is slowing down. Moving left at −10 m/s with a = −2 m/s² means it is speeding up to the left.',
    motion: Motion.negative,
    color: C.blue,
  ),
  Lesson(
    id: 6,
    difficulty: 3,
    title: 'Acceleration Graphs',
    short: 'Read acceleration from the slope of a velocity–time graph.',
    body:
        'In a velocity–time graph, time is on the horizontal axis and velocity is on the vertical axis. The slope gives acceleration. An upward line has positive acceleration, a flat line has zero acceleration, and a downward line has negative acceleration.',
    remember: 'Slope = change in velocity / change in time.',
    formula: 'a = Δv / Δt',
    example:
        'Velocity rises from 4 m/s at 2 s to 16 m/s at 6 s.\na = (16 − 4) / (6 − 2) = 3 m/s²',
    motion: Motion.formula,
    color: C.teal,
  ),
  Lesson(
    id: 7,
    difficulty: 4,
    title: 'Real-Life Acceleration',
    short: 'Identify velocity changes in familiar vehicles and situations.',
    body:
        'Cars, buses, bicycles, airplanes, and balls accelerate whenever their velocity changes. This includes speeding up, slowing down, and turning. Compare the direction and speed before and after each situation to decide how velocity changed.',
    remember: 'Turning is acceleration even when speed stays constant.',
    example:
        'A bus traveling around a curve at steady speed changes direction, so its velocity changes and it is accelerating.',
    motion: Motion.intro,
    color: C.orange,
  ),
  Lesson(
    id: 8,
    difficulty: 4,
    title: 'Acceleration Mastery',
    short:
        'Combine formulas, signs, units, and graphs to solve motion problems.',
    body:
        'Use the acceleration formula, interpret its sign with direction, and read the slope of velocity–time graphs. For each problem, list known values, choose a relationship, calculate carefully, and check whether the result and unit make sense.',
    remember:
        'a = (vf − vi) / t, measured in m/s²; on a velocity–time graph, a is the slope.',
    formula: 'a = (vf − vi) / t',
    example:
        'A vehicle changes from 5 m/s to 17 m/s in 4 s.\na = (17 − 5) / 4 = 3 m/s²',
    motion: Motion.formula,
    color: C.purple,
  ),
];

const Map<int, String> _lessonTitlesTl = {
  1: 'Panimula sa Akselerasyon',
  2: 'Speed at Velocity',
  3: 'Netong Puwersa ang Sanhi ng Akselerasyon',
  4: 'Pormula ng Akselerasyon',
  5: 'Positibo at Negatibong Akselerasyon',
  6: 'Mga Grap ng Akselerasyon',
  7: 'Akselerasyon sa Tunay na Buhay',
  8: 'Pagkadalubhasa sa Akselerasyon',
};

const Map<int, String> _lessonShortsTl = {
  1: 'Unawain kung paano nagbabago ang velocity sa paglipas ng oras.',
  2: 'Ihambing ang speed, velocity, at pagbabago ng direksiyon.',
  3: 'Pag-ugnayin ang netong puwersa, masa, at akselerasyon.',
  4: 'Kalkulahin ang akselerasyon mula sa velocity at oras.',
  5: 'Unawain ang tanda gamit ang velocity at direksiyon.',
  6: 'Kunin ang akselerasyon mula sa slope ng grap.',
  7: 'Kilalanin ang pagbabago ng velocity sa pang-araw-araw na sitwasyon.',
  8: 'Pagsamahin ang pormula, tanda, yunit, at grap.',
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
  1: 'May akselerasyon kapag nagbabago ang velocity.',
  2: 'May direksiyon ang velocity; wala nito ang speed.',
  3: 'Fnet = ma; nasa direksiyon ng netong puwersa ang akselerasyon.',
  4: 'Tukuyin muna ang vi, vf, at t bago ipalit sa pormula.',
  5: 'Magkaparehong direksiyon: bumibilis. Magkasalungat: bumabagal.',
  6: 'Slope = pagbabago sa velocity / pagbabago sa oras.',
  7: 'Ang pagliko ay akselerasyon kahit pareho ang speed.',
  8: 'a = (vf − vi) / t; sa grap ng velocity–time, slope ang a.',
};

const Map<int, String> _lessonExamplesTl = {
  1: 'Nagbago ang bilis ng auto-rickshaw mula 0 m/s hanggang 12 m/s sa loob ng 6 s.\na = (12 − 0) / 6 = 2 m/s²',
  3: 'Ang 2 kg na kariton ay tinulak ng netong puwersang 6 N.\na = 6 / 2 = 3 m/s²',
  4: 'Nagbago ang bilis ng kotse mula 4 m/s hanggang 16 m/s sa loob ng 4 s.\na = (16 − 4) / 4 = 3 m/s²',
  5: 'Gumagalaw pakanan sa +20 m/s ang bagay at may a = −2 m/s²; bumabagal ito. Kung pakanan naman ang acceleration habang gumagalaw pakaliwa, bumabagal din ito.',
  6: 'Tumaas ang velocity mula 4 m/s sa 2 s hanggang 16 m/s sa 6 s.\na = (16 − 4) / (6 − 2) = 3 m/s²',
  7: 'Umiikot sa kurba ang bus sa parehong speed. Nagbabago ang direksiyon ng velocity kaya may akselerasyon ito.',
  8: 'Nagbago ang velocity ng sasakyan mula 5 m/s hanggang 17 m/s sa loob ng 4 s.\na = (17 − 5) / 4 = 3 m/s²',
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

// Session assessments follow the question focus in the supplied session plans.
const Map<int, List<Quiz>> sessionQuizzes = {
  1: [
    Quiz(
        'What does acceleration describe?',
        [
          'Only the distance traveled',
          'A change in velocity over time',
          'Only the mass of an object',
          'The size of an object'
        ],
        1,
        'Acceleration is the rate of change of velocity.',
        1),
    Quiz('What is the SI unit of acceleration?', ['m/s', 'km/h', 'm/s²', 'kg'],
        2, 'Velocity changes by m/s each second, so the unit is m/s².', 1),
    Quiz(
        'What happens when an object’s velocity changes?',
        [
          'It experiences acceleration',
          'It must stay at rest',
          'Its speed must stay the same',
          'Its mass changes'
        ],
        0,
        'Speeding up, slowing down, and changing direction all change velocity.',
        1),
    Quiz(
        'Which quantity tells how long velocity changes?',
        ['Initial velocity', 'Final velocity', 'Time', 'Distance'],
        2,
        'Time is the duration of the velocity change.',
        1),
    Quiz(
        'An auto rickshaw changes velocity from 0 m/s to 20 m/s in 4 s. What is its acceleration?',
        ['2 m/s²', '4 m/s²', '5 m/s²', '8 m/s²'],
        2,
        'a = (20 − 0) / 4 = 5 m/s².',
        1),
  ],
  2: [
    Quiz(
        'What does speed describe?',
        [
          'How fast an object moves',
          'How fast and in which direction',
          'Change in mass',
          'Time taken'
        ],
        0,
        'Speed describes how fast an object moves.',
        2),
    Quiz(
        'What extra information does velocity include?',
        ['Mass', 'Direction', 'Distance only', 'Acceleration'],
        1,
        'Velocity includes direction as well as speed.',
        2),
    Quiz(
        'Which description includes direction?',
        ['25 m/s', '25 m/s east', '25 meters', '25 seconds'],
        1,
        'East gives the direction, so this is velocity.',
        2),
    Quiz(
        'A Bachelor Tours bus moves at 25 m/s east. Is this speed or velocity?',
        ['Speed', 'Velocity', 'Acceleration', 'Distance'],
        1,
        'The description includes both magnitude and direction.',
        2),
    Quiz(
        'Can an object have constant speed but changing velocity?',
        [
          'Yes, when it changes direction',
          'No, never',
          'Only when it stops',
          'Only when its mass changes'
        ],
        0,
        'A turn changes direction, and direction is part of velocity.',
        2),
  ],
  3: [
    Quiz(
        'A 10 kg cart experiences a net force of 50 N. What is its acceleration?',
        ['0.2 m/s²', '5 m/s²', '40 m/s²', '500 m/s²'],
        1,
        'Newton’s Second Law: a = Fnet / m = 50 / 10 = 5 m/s².',
        3),
    Quiz(
        'What is net force?',
        [
          'The total force after combining forces',
          'The object’s speed',
          'The object’s mass',
          'The time it moves'
        ],
        0,
        'Net force is the vector sum of forces on an object.',
        3),
    Quiz(
        'Two forces of 8 N and 5 N act right. What is the net force?',
        ['3 N right', '13 N right', '13 N left', '0 N'],
        1,
        'Forces in the same direction add: 8 + 5 = 13 N right.',
        3),
    Quiz(
        'In which direction does acceleration point?',
        [
          'Opposite the net force',
          'In the direction of net force',
          'Always upward',
          'It has no direction'
        ],
        1,
        'Acceleration points in the direction of the net force.',
        3),
    Quiz(
        'With the same net force, which object has greater acceleration?',
        [
          'The object with greater mass',
          'The object with smaller mass',
          'Both always equal',
          'Neither accelerates'
        ],
        1,
        'For the same force, a smaller mass has greater acceleration.',
        3),
  ],
  4: [
    Quiz(
        'A car changes velocity from 5 to 25 m/s in 4 s. Find acceleration.',
        ['3 m/s²', '4 m/s²', '5 m/s²', '6 m/s²'],
        2,
        'a = (25 − 5) / 4 = 5 m/s².',
        4),
    Quiz(
        'Which formula calculates acceleration?',
        ['a = (vf − vi) / t', 'a = vi + vf', 'a = t / (vf − vi)', 'a = m / F'],
        0,
        'Acceleration is change in velocity divided by time.',
        4),
    Quiz(
        'A motorcycle slows from 18 to 6 m/s in 3 s. What is a?',
        ['−4 m/s²', '4 m/s²', '−8 m/s²', '8 m/s²'],
        0,
        'a = (6 − 18) / 3 = −4 m/s².',
        4),
    Quiz(
        'What does vi represent?',
        ['Final velocity', 'Initial velocity', 'Time', 'Acceleration'],
        1,
        'vi is the initial velocity at the start of the interval.',
        4),
    Quiz('What is the SI unit of acceleration?', ['m/s²', 'm/s', 'm²/s', 's/m'],
        0, 'The SI unit is meters per second squared.', 4),
  ],
  5: [
    Quiz(
        'A car changes from +8 to +18 m/s while moving positive. What is the acceleration sign?',
        ['Positive', 'Negative', 'Zero', 'No acceleration'],
        0,
        'Velocity increases in the positive direction, so acceleration is positive.',
        5),
    Quiz(
        'A bus moving positive slows from 28 to 12 m/s. What happens?',
        [
          'It speeds up',
          'It slows with negative acceleration',
          'Its speed is constant',
          'It moves backward immediately'
        ],
        1,
        'Its acceleration points opposite its positive velocity.',
        5),
    Quiz(
        'A skateboarder moves left at −4 m/s with a = −3 m/s². What happens to speed?',
        [
          'It increases',
          'It decreases',
          'It becomes zero immediately',
          'It turns right'
        ],
        0,
        'Velocity and acceleration point the same way, so speed increases.',
        5),
    Quiz(
        'An object moves positive while its speed decreases. Can its acceleration be negative?',
        ['True', 'False'],
        0,
        'Acceleration opposite the velocity reduces the object’s speed.',
        5),
    Quiz(
        'Does a negative acceleration always mean an object is slowing down?',
        ['Yes', 'No'],
        1,
        'If velocity is also negative, negative acceleration can increase speed.',
        5),
  ],
  6: [
    Quiz(
        'What is usually on the x-axis of a velocity–time graph?',
        ['Velocity', 'Time', 'Acceleration', 'Distance'],
        1,
        'Time is plotted on the horizontal x-axis.',
        6),
    Quiz(
        'What is usually on the y-axis?',
        ['Time', 'Velocity', 'Mass', 'Distance'],
        1,
        'Velocity is plotted on the vertical y-axis.',
        6),
    Quiz(
        'What does an upward-sloping line show?',
        [
          'Positive acceleration',
          'Zero acceleration',
          'No movement',
          'Negative time'
        ],
        0,
        'Velocity increases with time, giving a positive slope.',
        6),
    Quiz(
        'What does a horizontal line show?',
        [
          'Increasing velocity',
          'Constant velocity',
          'Decreasing velocity',
          'Changing mass'
        ],
        1,
        'A horizontal velocity–time line has zero slope and constant velocity.',
        6),
    Quiz(
        'What does a downward-sloping line usually show?',
        [
          'Positive acceleration',
          'Negative acceleration',
          'Zero time',
          'Constant acceleration only'
        ],
        1,
        'Velocity decreases over time, so the slope is negative.',
        6),
  ],
  7: [
    Quiz(
        'A motorcycle increases its velocity from 12 m/s to 24 m/s while moving east. What happens to its motion?',
        [
          'It is speeding up',
          'It moves at constant velocity',
          'It has zero acceleration',
          'It changes direction only'
        ],
        0,
        'Its eastward velocity increases, so the motorcycle is speeding up and accelerating.',
        7),
    Quiz(
        'A bus travels east at 15 m/s, then slows down to 6 m/s. Which statement best describes its motion?',
        [
          'Its speed and direction both increase',
          'Its velocity changes as its speed decreases',
          'Its velocity stays constant',
          'It immediately moves west'
        ],
        1,
        'The bus slows down while continuing east, so its velocity changes.',
        7),
    Quiz(
        'A cyclist travels around a curved path at a constant speed of 8 m/s. Why is the cyclist accelerating?',
        [
          'The cyclist’s mass increases',
          'The cyclist’s speed increases',
          'The cyclist’s direction changes',
          'The cyclist’s speed keeps changing'
        ],
        2,
        'A turn changes the direction of velocity, even when speed stays constant.',
        7),
    Quiz(
        'A ball bounces off a wall and changes direction at the same speed. Has velocity changed?',
        ['True', 'False'],
        0,
        'Direction is part of velocity, so the bounce changes velocity.',
        7),
    Quiz(
        'An airplane moving straight at constant velocity is accelerating because it is fast.',
        ['True', 'False'],
        1,
        'Constant velocity means zero acceleration, regardless of how fast.',
        7),
  ],
  8: [
    Quiz(
        'Which statement best describes acceleration?',
        [
          'Change in velocity over time',
          'Distance traveled over time',
          'Total distance from the starting point',
          'The amount of matter in an object'
        ],
        0,
        'Acceleration is the rate of change of velocity.',
        8),
    Quiz(
        'A car changes velocity from 8 m/s to 28 m/s in 4 s. What is its acceleration?',
        ['4 m/s²', '5 m/s²', '6 m/s²', '7 m/s²'],
        1,
        'a = (28 − 8) / 4 = 5 m/s².',
        8),
    Quiz(
        'What is the SI unit of acceleration?',
        ['m/s', 'm/s²', 'm²/s', 'kg·m/s²'],
        1,
        'Acceleration is measured in m/s².',
        8),
    Quiz(
        'A motorcycle slows from 24 m/s to 12 m/s in 3 s. What is its acceleration?',
        ['−4 m/s²', '4 m/s²', '−12 m/s²', '12 m/s²'],
        0,
        'a = (12 − 24) / 3 = −4 m/s².',
        8),
    Quiz(
        'On a velocity–time graph, what does a horizontal line indicate?',
        [
          'Velocity increases steadily',
          'Velocity decreases steadily',
          'Acceleration increases steadily',
          'Velocity remains constant'
        ],
        3,
        'A flat line has zero slope, so velocity is constant.',
        8),
    Quiz(
        'Which choice lists situations that involve acceleration?',
        [
          'A car speeds up in a straight line',
          'A bicycle turns at constant speed',
          'A bus slows down while moving straight',
          'All three situations'
        ],
        3,
        'Speeding up, slowing down, and turning all change velocity.',
        8),
    Quiz(
        'A vehicle travels around a turn at constant speed. Has its velocity changed?',
        ['Yes', 'No'],
        0,
        'Turning changes direction, and direction is part of velocity.',
        8),
    Quiz(
        'An object with zero acceleration must be completely at rest.',
        ['True', 'False'],
        1,
        'Zero acceleration also describes an object moving at constant velocity.',
        8),
    Quiz(
        'A train starts at 6 m/s and accelerates at 2 m/s² for 5 s. What is its final velocity?',
        ['12 m/s', '16 m/s', '20 m/s', '30 m/s'],
        1,
        'vf = vi + at = 6 + (2 × 5) = 16 m/s.',
        8),
    Quiz(
        'A velocity–time graph drops from 18 m/s to 6 m/s in 4 s. What is its slope?',
        ['−6 m/s²', '−3 m/s²', '3 m/s²', '6 m/s²'],
        1,
        'The slope is acceleration: (6 − 18) / 4 = −3 m/s².',
        8),
  ],
};

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
      'Learn acceleration basics, speed, velocity, and direction',
      C.green,
      'Baguhan',
      'Mga batayan ng akselerasyon, speed, velocity, at direksiyon'),
  Level(
      'Intermediate',
      'Apply net force, mass, and the acceleration formula',
      C.blue,
      'Katamtaman',
      'Ilapat ang netong puwersa, masa, at pormula ng akselerasyon'),
  Level(
      'Advanced',
      'Interpret acceleration signs and read velocity–time graphs',
      C.yellow,
      'Mas Mahirap',
      'Unawain ang mga tanda ng akselerasyon at basahin ang grap ng velocity–time'),
  Level(
      'Expert',
      'Apply acceleration ideas to real situations and mixed problems',
      C.orange,
      'Dalubhasa',
      'Ilapat ang mga ideya sa akselerasyon sa tunay na sitwasyon at halo-halong problema'),
];
