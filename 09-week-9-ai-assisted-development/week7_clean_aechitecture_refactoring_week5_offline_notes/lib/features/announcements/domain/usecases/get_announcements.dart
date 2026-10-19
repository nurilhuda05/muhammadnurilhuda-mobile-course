import '../../../../core/failures.dart';
import '../entities/announcement.dart';
import '../repositories/announcement_repository.dart';

/// Use case: mengambil daftar pengumuman.
///
/// Saat ini masih pass-through ke repository (1 baris),
/// tetapi dipertahankan agar pola konsisten dengan fitur notes
/// dan siap ditambahkan business logic (misal: filter by tanggal,
/// sorting priority) di kemudian hari.
class GetAnnouncements {
  const GetAnnouncements(this._repository);
  final AnnouncementRepository _repository;

  Future<({List<Announcement> announcements, Failure? failure})> call() {
    return _repository.fetchAnnouncements();
  }
}
