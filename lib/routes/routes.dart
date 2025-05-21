import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation1/animation1_screen.dart';
import 'package:flutter_me_animations/animation10/animation10_screen.dart';
import 'package:flutter_me_animations/animation12/animation12_screen.dart';
import 'package:flutter_me_animations/animation13/animation13_screen.dart';
import 'package:flutter_me_animations/animation14/animation14_screen.dart';
import 'package:flutter_me_animations/animation15/animation15_screen.dart';
import 'package:flutter_me_animations/animation16/animation16_screen.dart';
import 'package:flutter_me_animations/animation17/animation17_screen.dart';
import 'package:flutter_me_animations/animation18/animation18_screen.dart';
import 'package:flutter_me_animations/animation19/animation19_screen.dart';
import 'package:flutter_me_animations/animation2/animation2_screen.dart';
import 'package:flutter_me_animations/animation20/animation20_screen.dart';
import 'package:flutter_me_animations/animation21/animation21_screen.dart';
import 'package:flutter_me_animations/animation23/animation23_screen.dart';
import 'package:flutter_me_animations/animation24/animation24_screen.dart';
import 'package:flutter_me_animations/animation25/animation25_screen.dart';
import 'package:flutter_me_animations/animation26/animation26_screen.dart';
import 'package:flutter_me_animations/animation27/animation27_screen.dart';
import 'package:flutter_me_animations/animation28/animation28_screen.dart';
import 'package:flutter_me_animations/animation29/animation29_screen.dart';
import 'package:flutter_me_animations/animation3/animation3_screen.dart';
import 'package:flutter_me_animations/animation30/animation30_screen.dart';
import 'package:flutter_me_animations/animation31/animation31_screen.dart';
import 'package:flutter_me_animations/animation32/animation32_screen.dart';
import 'package:flutter_me_animations/animation33/animation33_screen.dart';
import 'package:flutter_me_animations/animation34/animation34_screen.dart';
import 'package:flutter_me_animations/animation35/animation35_screen.dart';
import 'package:flutter_me_animations/animation36/animation36_screen.dart';
import 'package:flutter_me_animations/animation37/animation37_screen.dart';
import 'package:flutter_me_animations/animation38/animation38_screen.dart';
import 'package:flutter_me_animations/animation39/animation39_screen.dart';
import 'package:flutter_me_animations/animation4/animation4_detail_screen.dart';
import 'package:flutter_me_animations/animation4/animation4_screen.dart';
import 'package:flutter_me_animations/animation40/animation40_screen.dart';
import 'package:flutter_me_animations/animation41/animation41_screen.dart';
import 'package:flutter_me_animations/animation42/animation42_screen.dart';
import 'package:flutter_me_animations/animation43/animation43_screen.dart';
import 'package:flutter_me_animations/animation44/animation44_screen.dart';
import 'package:flutter_me_animations/animation45/animation45_screen.dart';
import 'package:flutter_me_animations/animation46/animation46_screen.dart';
import 'package:flutter_me_animations/animation47/animation47_screen.dart';
import 'package:flutter_me_animations/animation48/animation48_screen.dart';
import 'package:flutter_me_animations/animation49/animation49_screen.dart';
import 'package:flutter_me_animations/animation5/animation5_screen.dart';
import 'package:flutter_me_animations/animation50/animation50_screen.dart';
import 'package:flutter_me_animations/animation6/animation6_detail_screen.dart';
import 'package:flutter_me_animations/animation6/animation6_screen.dart';
import 'package:flutter_me_animations/animation7/animation7_screen.dart';
import 'package:flutter_me_animations/animation9/animation9_screen.dart';
import 'package:flutter_me_animations/home_page.dart';

class Routes {
  static PageRouteBuilder transitionRoute(
    Widget child,
    RouteSettings settings,
  ) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 800),
      reverseTransitionDuration: const Duration(milliseconds: 800),
      pageBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) => child,
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        child,
      ) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "home-page":
        return MaterialPageRoute(builder: (_) => const HomePage());
      case "animation1":
        return MaterialPageRoute(builder: (_) => const Animation1Screen());
      case "animation2":
        return MaterialPageRoute(builder: (_) => const Animation2Screen());
      case "animation3":
        return MaterialPageRoute(builder: (_) => const Animation3Screen());
      case "animation4":
        return MaterialPageRoute(builder: (_) => const Animation4Screen());
      case "animation4/detail":
        return transitionRoute(const Animation4DetailScreen(), settings);
      case "animation5":
        return MaterialPageRoute(builder: (_) => const Animation5Screen());
      case "animation6":
        return MaterialPageRoute(builder: (_) => const Animation6Screen());
      case "animation6/detail":
        return transitionRoute(const Animation6DetailScreen(), settings);
      case "animation7":
        return MaterialPageRoute(builder: (_) => const Animation7Screen());
      case "animation9":
        return MaterialPageRoute(builder: (_) => const Animation9Screen());
      case "animation10":
        return MaterialPageRoute(builder: (_) => const Animation10Screen());
      case "animation12":
        return MaterialPageRoute(builder: (_) => const Animation12Screen());
      case "animation13":
        return MaterialPageRoute(builder: (_) => const Animation13Screen());
      case "animation14":
        return MaterialPageRoute(builder: (_) => const Animation14Screen());
      case "animation15":
        return MaterialPageRoute(builder: (_) => const Animation15Screen());
      case "animation16":
        return MaterialPageRoute(builder: (_) => const Animation16Screen());
      case "animation17":
        return MaterialPageRoute(builder: (_) => const Animation17Screen());
      case "animation18":
        return MaterialPageRoute(builder: (_) => const Animation18Screen());
      case "animation19":
        return MaterialPageRoute(builder: (_) => const Animation19Screen());
      case "animation20":
        return MaterialPageRoute(builder: (_) => const Animation20Screen());
      case "animation21":
        return MaterialPageRoute(builder: (_) => const Animation21Screen());
      case "animation23":
        return MaterialPageRoute(builder: (_) => const Animation23Screen());
      case "animation24":
        return MaterialPageRoute(builder: (_) => const Animation24Screen());
      case "animation25":
        return MaterialPageRoute(builder: (_) => const Animation25Screen());
      case "animation26":
        return MaterialPageRoute(builder: (_) => const Animation26Screen());
      case "animation27":
        return MaterialPageRoute(builder: (_) => const Animation27Screen());
      case "animation28":
        return MaterialPageRoute(builder: (_) => const Animation28Screen());
      case "animation29":
        return MaterialPageRoute(builder: (_) => const Animation29Screen());
      case "animation30":
        return MaterialPageRoute(builder: (_) => const Animation30Screen());
      case "animation31":
        return MaterialPageRoute(builder: (_) => const Animation31Screen());
      case "animation32":
        return MaterialPageRoute(builder: (_) => const Animation32Screen());
      case "animation33":
        return MaterialPageRoute(builder: (_) => const Animation33Screen());
      case "animation34":
        return MaterialPageRoute(builder: (_) => const Animation34Screen());
      case "animation35":
        return MaterialPageRoute(builder: (_) => const Animation35Screen());
      case "animation36":
        return MaterialPageRoute(builder: (_) => const Animation36Screen());
      case "animation37":
        return MaterialPageRoute(builder: (_) => const Animation37Screen());
      case "animation38":
        return MaterialPageRoute(builder: (_) => const Animation38Screen());
      case "animation39":
        return MaterialPageRoute(builder: (_) => const Animation39Screen());
      case "animation40":
        return MaterialPageRoute(builder: (_) => const Animation40Screen());
      case "animation41":
        return MaterialPageRoute(builder: (_) => const Animation41Screen());
      case "animation42":
        return MaterialPageRoute(builder: (_) => const Animation42Screen());
      case "animation43":
        return MaterialPageRoute(builder: (_) => const Animation43Screen());
      case "animation44":
        return MaterialPageRoute(builder: (_) => const Animation44Screen());
      case "animation45":
        return MaterialPageRoute(builder: (_) => const Animation45Screen());
      case "animation46":
        return MaterialPageRoute(builder: (_) => const Animation46Screen());
      case "animation47":
        return MaterialPageRoute(builder: (_) => const Animation47Screen());
      case "animation48":
        return MaterialPageRoute(builder: (_) => const Animation48Screen());
      case "animation49":
        return MaterialPageRoute(builder: (_) => const Animation49Screen());
      case "animation50":
        return MaterialPageRoute(builder: (_) => const Animation50Screen());
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
