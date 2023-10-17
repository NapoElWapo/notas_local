import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notas_share/home_page.dart';

import 'bloc/master_bloc.dart';

void main() async {
  await Hive.initFlutter();
  runApp(
    BlocProvider(
      create: (context) => MasterBloc()..add(GetStoredNotesEvent()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: HomePage(),
    );
  }
}
