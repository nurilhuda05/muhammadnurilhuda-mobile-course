import 'package:sqflite/sqflite.dart';
import '../../../../core/failures.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../models/announcement_model.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  AnnouncementRepositoryImpl({required this._openDb});

  final Future<Database> Function() _openDb;

  @override
  Future<({List<Announcement> announcements, Failure? failure})>
      fetchAnnouncements() async {
    try {
      final db = await _openDb();
      final rows =
          await db.query('announcements', orderBy: 'created_at DESC');
      final announcements =
          rows.map((r) => AnnouncementModel.fromMap(r).toEntity()).toList();
      return (announcements: announcements, failure: null);
    } catch (e) {
      return (
        announcements: const <Announcement>[],
        failure: LocalFailure('Gagal membaca pengumuman: $e'),
      );
    }
  }
}
