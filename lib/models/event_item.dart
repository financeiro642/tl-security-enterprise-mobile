class EventItem {
  final String cameraId;
  final String camera;
  final String local;
  final String title;
  final String time;
  final String? photoUrl;
  final String? videoUrl;

  EventItem({required this.cameraId, required this.camera, required this.local, required this.title, required this.time, this.photoUrl, this.videoUrl});

  factory EventItem.fromJson(Map<String, dynamic> j) => EventItem(
    cameraId: (j['camera_id'] ?? '').toString(),
    camera: (j['camera'] ?? '').toString(),
    local: (j['local'] ?? '').toString(),
    title: (j['title'] ?? 'Movimento detectado').toString(),
    time: (j['time'] ?? '').toString(),
    photoUrl: j['photo_url']?.toString(),
    videoUrl: j['video_url']?.toString(),
  );
}
