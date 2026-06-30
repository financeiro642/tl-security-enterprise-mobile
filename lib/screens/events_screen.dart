import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/event_item.dart';

class EventsScreen extends StatefulWidget{const EventsScreen({super.key});@override State<EventsScreen> createState()=>_EventsScreenState();}
class _EventsScreenState extends State<EventsScreen>{
 final api=ApiService(); late Future<List<EventItem>> future; @override void initState(){super.initState();future=api.events();}
 @override Widget build(BuildContext context)=>SafeArea(child:Scaffold(appBar:AppBar(title:const Text('Eventos'),actions:[IconButton(onPressed:()=>setState(()=>future=api.events()),icon:const Icon(Icons.refresh))]),body:FutureBuilder<List<EventItem>>(future:future,builder:(context,snap){
  if(!snap.hasData)return const Center(child:CircularProgressIndicator()); final events=snap.data!;
  return ListView.separated(padding:const EdgeInsets.all(12),itemCount:events.length,separatorBuilder:(_,__)=>const SizedBox(height:8),itemBuilder:(_,i){final e=events[i];return Card(child:ListTile(
   leading:CircleAvatar(backgroundColor:Colors.green.shade700,child:const Icon(Icons.directions_run)),
   title:Text(e.title), subtitle:Text('${e.local} - ${e.camera}\n${e.time}'), isThreeLine:true,
   trailing:e.photoUrl==null?null:ClipRRect(borderRadius:BorderRadius.circular(8),child:Image.network(ApiService.media(e.photoUrl),width:72,height:52,fit:BoxFit.cover)),
 ));});})));
}
