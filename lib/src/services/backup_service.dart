import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../database/app_database.dart';
import '../database/database_connection.dart';

class BackupResult {
  const BackupResult({required this.file, required this.bytes});

  final File file;
  final int bytes;
}

class BackupService {
  const BackupService(this._database);

  final AppDatabase _database;

  Future<BackupResult> exportZipBackup() async {
    final root = await appDataDirectory();
    final backupDirectory = Directory(p.join(root.path, 'backups'));
    await backupDirectory.create(recursive: true);

    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final sqliteFile = File(
      p.join(backupDirectory.path, 'offline_desktop_program_$timestamp.sqlite'),
    );
    final zipFile = File(
      p.join(backupDirectory.path, 'offline_desktop_program_$timestamp.zip'),
    );

    await _database.exportSqliteFile(sqliteFile);

    final sqliteBytes = await sqliteFile.readAsBytes();
    final manifestBytes = utf8.encode(
      const JsonEncoder.withIndent('  ').convert({
        'app': 'offline_desktop_program',
        'format': 'sqlite-zip',
        'createdAt': DateTime.now().toIso8601String(),
        'databaseFile': databaseFileName,
      }),
    );

    final archive = Archive()
      ..addFile(ArchiveFile(databaseFileName, sqliteBytes.length, sqliteBytes))
      ..addFile(
        ArchiveFile('manifest.json', manifestBytes.length, manifestBytes),
      );

    final zipBytes = ZipEncoder().encode(archive, level: 6);
    await zipFile.writeAsBytes(zipBytes, flush: true);
    await sqliteFile.delete();

    return BackupResult(file: zipFile, bytes: await zipFile.length());
  }
}
