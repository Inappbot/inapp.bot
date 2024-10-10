import 'package:in_app_bot/in_app_bot/data/datasources/local/local_datasource.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/domain/entities/notification_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatasourceImp implements LocalDatasource {
  LocalDatasourceImp._private();
  static final _instance = LocalDatasourceImp._private();

  factory LocalDatasourceImp() {
    return _instance;
  }

  Future<Database>? _database;

  Future<Database> getDatabase() async {
    _database ??= _initDB('notifications.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE notifications (
      id TEXT PRIMARY KEY,
      type TEXT,
      url TEXT,
      title TEXT,
      description TEXT,
      timestamp INTEGER,
      link_to_go TEXT,
      text_button TEXT,
      is_read INTEGER DEFAULT 0,
      context TEXT
    )
  ''');
  }

  @override
  Future<void> deleteNotifications(List<String> notificationIds) async {
    final db = await getDatabase();
    final batch = db.batch();
    for (var id in notificationIds) {
      batch.delete('notifications', where: 'id = ?', whereArgs: [id]);
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    final db = await getDatabase();
    final maps = await db.query('notifications', orderBy: 'timestamp DESC');
    return List.generate(
        maps.length, (i) => NotificationEntity.fromMap(maps[i]));
  }

  @override
  Future<int> getUnreadNotificationsCount() async {
    final db = await getDatabase();
    final count = Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM notifications WHERE is_read = 0'));
    return count ?? 0;
  }

  @override
  Future<void> insertNotification(NotificationEntity notification) async {
    final db = await getDatabase();
    await db.insert('notifications', notification.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> insertNotifications(
      List<NotificationEntity> notifications) async {
    final db = await getDatabase();
    final batch = db.batch();
    for (var notification in notifications) {
      batch.insert('notifications', notification.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<bool> isDatabaseEmpty() async {
    final db = await getDatabase();
    final result = await db.rawQuery('SELECT COUNT(*) FROM notifications');
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count == 0;
  }

  @override
  Future<void> markAsRead(String id) async {
    final db = await getDatabase();
    await db.update(
      'notifications',
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
