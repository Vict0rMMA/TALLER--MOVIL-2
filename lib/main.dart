import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'database/app_database.dart';
import 'database/sample_event_local_data_source.dart';
import 'firebase_options.dart';
import 'pages/sample_list_page.dart';
import 'repositories/sample_event_repository.dart';
import 'services/sample_event_remote_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;
  firestore.settings = const Settings(persistenceEnabled: false);

  final database = AppDatabase();
  final repository = SampleEventRepository(
    local: SampleEventLocalDataSource(database),
    remote: SampleEventRemoteService(firestore),
  );

  runApp(SampleTrackApp(repository: repository));
}

class SampleTrackApp extends StatelessWidget {
  const SampleTrackApp({super.key, required this.repository});

  final SampleEventRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SampleTrack',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: SampleListPage(repository: repository),
    );
  }
}
