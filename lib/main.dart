import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tell_sam/ui/screens/splash_screen.dart';
import 'package:wakelock/wakelock.dart';

import 'ui/screens/home/homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();

  runApp(DevicePreview(builder: (context) => const MyApp(), enabled: false
      //!kReleaseMode,
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 960),
      builder: (BuildContext context, child) => MaterialApp(
        title: 'Tell Sam',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.openSansTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
