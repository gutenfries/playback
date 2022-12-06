import 'dart:io' show Platform;

import 'package:playback/model.dart';
import 'package:playback/widgets/playback_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowMinSize(const Size(400, 600));
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DayHandler()),
        ChangeNotifierProvider(create: (context) => CabinManager()),
      ],
      child: const CabinBookingApp(),
    ),
  );
}
