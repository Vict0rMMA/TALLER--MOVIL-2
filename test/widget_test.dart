import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_track_shell/database/app_database.dart';
import 'package:sample_track_shell/database/sample_event_local_data_source.dart';
import 'package:sample_track_shell/main.dart';
import 'package:sample_track_shell/repositories/sample_event_repository.dart';

import 'fake_remote_service.dart';

void main() {
  testWidgets('SampleTrack muestra el catalogo inicial', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repository = SampleEventRepository(
      local: SampleEventLocalDataSource(db),
      remote: FakeRemoteService(),
    );

    await tester.pumpWidget(SampleTrackApp(repository: repository));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();

    expect(find.text('SampleTrack'), findsOneWidget);
    expect(find.text('M-1001'), findsOneWidget);
    expect(find.text('M-1005'), findsOneWidget);
  });
}
