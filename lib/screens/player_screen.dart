import 'package:flutter/material.dart';
import '../models/camera.dart';
import '../services/api_service.dart';

class PlayerScreen extends StatelessWidget{
  final CameraItem camera; const PlayerScreen({super.key, required this.camera});
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:Text('${camera.local} - ${camera.name}')), body:ListView(padding:const EdgeInsets.all(16),children:[
    AspectRatio(aspectRatio:16/9, child:Container(color:Colors.black, child: camera.photoUrl==null?const Center(child:Text('Sem imagem')):Image.network(ApiService.media(camera.photoUrl), fit:BoxFit.contain))),
    const SizedBox(height:16),
    Wrap(spacing:10, runSpacing:10, children:[
      FilledButton.icon(onPressed:(){}, icon:const Icon(Icons.camera_alt), label:const Text('Snapshot')),
      FilledButton.icon(onPressed:(){}, icon:const Icon(Icons.fiber_manual_record), label:const Text('Gravar')),
      FilledButton.icon(onPressed:(){}, icon:const Icon(Icons.fullscreen), label:const Text('Tela cheia')),
    ]),
    const SizedBox(height:18),
    Card(child:Padding(padding:const EdgeInsets.all(16), child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
      Text(camera.local, style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold)), Text(camera.name), const SizedBox(height:8), Text('Status: ${camera.status}'), Text('Última foto: ${camera.photoTime ?? '-'}'), Text('Alerta: ${camera.alertEnabled ? 'Ativo' : 'Desativado'}')
    ])))
  ]));
}
