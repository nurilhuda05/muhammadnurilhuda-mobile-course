abstract final class AppRoutes {
  static const login       = '/login';
  static const home        = '/';
  static const pengumuman  = '/pengumuman';

  static String pengumumanDetail(String id) => '$pengumuman/$id';
}
