import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/camera.dart';
import 'player_screen.dart';

class CamerasScreen extends StatefulWidget {
  const CamerasScreen({super.key});

  @override
  State<CamerasScreen> createState() => _CamerasScreenState();
}

class _CamerasScreenState extends State<CamerasScreen> {
  final api = ApiService();
  late Future<List<CameraItem>> future;

  @override
  void initState() {
    super.initState();
    future = api.cameras();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Câmeras'),
          actions: [
            IconButton(
              onPressed: () => setState(() => future = api.cameras()),
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: FutureBuilder<List<CameraItem>>(
          future: future,
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final cams = snap.data!;

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: cams.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 8),

              itemBuilder: (_, i) {
                final c = cams[i];

                return Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 72,
                        height: 52,
                        child: c.photoUrl == null
                            ? const ColoredBox(
                                color: Colors.black,
                                child: Center(
                                  child: Icon(Icons.videocam_off),
                                ),
                              )
                            : Image.network(
                                ApiService.media(c.photoUrl),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),

                    title: Text(c.local),

                    subtitle: Text(
                      '${c.name}\n${c.status} • ${c.photoTime ?? '-'}',
                    ),

                    isThreeLine: true,

                    trailing: const Icon(
                      Icons.play_circle,
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlayerScreen(camera: c),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
