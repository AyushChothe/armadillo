import 'package:armadillo/models/ssh_client_record.dart';
import 'package:armadillo/pages/home_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SSHClientRecordAdapter());
  await Hive.openBox<List>('clientsBox');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Armadillo: Simple SSH Client',
      theme: FlexThemeData.dark(
        scheme: FlexScheme.outerSpace,
        fontFamily: GoogleFonts.firaCode().fontFamily,
      ),
      home: const HomePage(),
    );
  }
}
