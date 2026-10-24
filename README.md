# AccelLab (offline Flutter app) - redesigned

Matches the AccelLab design board: animated splash, home, learn, simulator,
"what happens if", velocity-time graph, real-life examples, calculation
practice, 10-question challenge, quiz result, badges, progress, review, settings.
Everything (content + progress) is stored on the device, so it works offline.

## App icon
The AccelLab logo (`assets/icon/icon.png`) is wired up as the Android
launcher icon via the `flutter_launcher_icons` package. After `flutter pub
get`, generate the Android icons with:

    flutter pub run flutter_launcher_icons

This writes the launcher icon files into `android/` — run it again whenever
you replace the logo image. The icon generation step runs locally once the
package is available.

## Install over your existing project
1. In your existing `accellab` project folder, DELETE the old `lib` folder.
2. Copy the new `lib` folder and `pubspec.yaml` from this zip into the project
   (keep your generated `android/`, `ios/`, `web/` folders as they are).
3. Run:
       flutter pub get
       flutter run
   (or hot-restart with `R` if the app is already running)

## Structure
- lib/main.dart            app entry, theme, text size
- lib/theme.dart           colors + light/dark theme
- lib/state/app_state.dart progress, badges, settings (saved locally)
- lib/data/content.dart    lessons, examples, quiz questions, levels
- lib/widgets/common.dart  cards, animations, car drawing, steppers
- lib/screens/             one file per screen
