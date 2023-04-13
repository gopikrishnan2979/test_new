import 'package:aura/database/favorite/dbmodel/fav_model.dart';
import 'package:aura/database/playlist/playlistmodel/playlist_model.dart';
import 'package:aura/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive_flutter/adapters.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  final path = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(path.path);
  if (!Hive.isAdapterRegistered(FavModelAdapter().typeId)) {
    Hive.registerAdapter(FavModelAdapter());
  }
  if (!Hive.isAdapterRegistered(PlaylistClassAdapter().typeId)) {
    Hive.registerAdapter(PlaylistClassAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const SplashScreen(),
      title: 'AURA',
    );
  }
}