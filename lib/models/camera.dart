class CameraItem {
  final String id;
  final String name;
  final String local;
  final String status;
  final String? photoUrl;
  final String? videoUrl;
  final String? photoTime;
  final bool alertEnabled;

  CameraItem({required this.id, required this.name, required this.local, required this.status, this.photoUrl, this.videoUrl, this.photoTime, required this.alertEnabled});

  factory CameraItem.fromJson(Map<String, dynamic> j) => CameraItem(
    id: (j['id'] ?? '').toString(),
    name: (j['name'] ?? '').toString(),
    local: (j['local'] ?? '').toString(),
    status: (j['status'] ?? 'online').toString(),
    photoUrl: j['photo_url']?.toString(),
    videoUrl: j['video_url']?.toString(),
    photoTime: j['photo_time']?.toString(),
    alertEnabled: j['alert_enabled'] != false,
  );
}
