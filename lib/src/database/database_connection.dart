import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const appFolderName = 'offline_desktop_program';
const databaseFileName = 'offline_desktop_program.sqlite';

QueryExecutor openConnection() {
  return LazyDatabase(() async {
    final file = File(await defaultDatabasePath());
    return NativeDatabase.createInBackground(file);
  });
}

Future<Directory> appDataDirectory() async {
  final supportDirectory = await getApplicationSupportDirectory();
  final directory = Directory(p.join(supportDirectory.path, appFolderName));
  await directory.create(recursive: true);
  return directory;
}

Future<String> defaultDatabasePath() async {
  final directory = await appDataDirectory();
  return p.join(directory.path, databaseFileName);
}
