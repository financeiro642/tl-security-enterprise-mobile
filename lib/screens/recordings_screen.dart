import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/event_item.dart';

class RecordingsScreen extends StatefulWidget{const RecordingsScreen({super.key});@override State<RecordingsScreen> createState()=>_RecordingsScreenState();}
class _RecordingsScreenState extends State<RecordingsScreen>{
 final api=ApiService(); late Future<List<EventItem>> future; @override void initState(){super.initState();future=api.events();}
 @override Widget build(BuildContext context)=>SafeArea(child:Scaffold(appBar:AppBar(title:const Text('Gravações')),body:FutureBuilder<List<EventItem>>(future:future,builder:(context,snap){
  if(!snap.hasData)return const Center(child:CircularProgressIndicator()); final recs=snap.data!.where((e)=>e.videoUrl!=null).toList();
  return ListView.separated(padding:const EdgeInsets.all(12),itemCount:recs.length,separatorBuilder:(_,__)=>const SizedBox(height:8),itemBuilder:(_,i){final e=recs[i];return Card(child:ListTile(
   leading:const Icon(Icons.video_file,color:Colors.blueAccent), title:Text('${e.local} - ${e.camera}'), subtitle:Text(e.time), trailing:const Icon(Icons.download),
 ));});})));
}
