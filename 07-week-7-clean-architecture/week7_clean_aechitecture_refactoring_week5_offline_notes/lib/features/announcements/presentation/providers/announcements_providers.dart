import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_helper.dart';
import '../../data/repositories/announcement_repository_impl.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../../domain/usecases/get_announcements.dart';

// ── Layer 1: Data — repository disuntikkan via provider ──
final announcementRepositoryProvider =
    Provider<AnnouncementRepository>((ref) {
  return AnnouncementRepositoryImpl(openDb: openNotesDb);
});

// ── Layer 2: Domain — use case menerima abstraksi ────────
final getAnnouncementsUseCaseProvider =
    Provider<GetAnnouncements>((ref) {
  return GetAnnouncements(ref.watch(announcementRepositoryProvider));
});

// ── Layer 3: Presentation — state untuk UI ───────────────
final announcementsProvider =
    FutureProvider<List<Announcement>>((ref) async {
  final result = await ref.watch(getAnnouncementsUseCaseProvider).call();
  if (result.failure != null) throw result.failure!;
  return result.announcements;
});
