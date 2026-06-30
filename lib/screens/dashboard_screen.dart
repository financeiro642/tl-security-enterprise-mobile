import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/camera.dart';

class DashboardScreen extends StatefulWidget { const DashboardScreen({super.key}); @override State<DashboardScreen> createState()=>_DashboardScreenState(); }
class _DashboardScreenState extends State<DashboardScreen> {
  final api = ApiService();
  late Future<List<CameraItem>> future;
  @override void initState(){super.initState(); future=api.cameras();}
  @override Widget build(BuildContext context) => SafeArea(child: RefreshIndicator(
    onRefresh: () async => setState(()=>future=api.cameras()),
    child: ListView(padding: const EdgeInsets.all(16), children: [
      Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), gradient: const LinearGradient(colors:[Color(0xFF123B75), Color(0xFF101B2B)])), child: const Row(children:[Icon(Icons.shield, size:42, color:Color(0xFF2F80FF)), SizedBox(width:12), Expanded(child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[Text('TL Security Enterprise', style:TextStyle(fontSize:26,fontWeight:FontWeight.bold)), Text('Central Inteligente de Monitoramento', style:TextStyle(color:Colors.white70))]))])),
      const SizedBox(height: 18),
      FutureBuilder<List<CameraItem>>(future: future, builder:(context,snap){
        final cams = snap.data ?? [];
        return Column(children:[
          Row(children:[_kpi('Câmeras', cams.length.toString(), Icons.videocam), _kpi('Online', cams.where((c)=>c.status=='online').length.toString(), Icons.circle, green:true)]),
          Row(children:[_kpi('Alertas', cams.where((c)=>c.alertEnabled).length.toString(), Icons.notifications_active), _kpi('Sem foto', cams.where((c)=>c.photoUrl==null).length.toString(), Icons.image_not_supported)]),
          const SizedBox(height:16),
          const Align(alignment:Alignment.centerLeft, child:Text('Câmeras online', style:TextStyle(fontSize:20,fontWeight:FontWeight.bold))),
          const SizedBox(height:10),
          GridView.builder(shrinkWrap:true, physics:const NeverScrollableScrollPhysics(), itemCount:cams.take(6).length, gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2, childAspectRatio:.83, crossAxisSpacing:12, mainAxisSpacing:12), itemBuilder:(_,i){final c=cams[i]; return _camCard(c);})
        ]);
      })
    ]),
  ));
  Widget _kpi(String t,String v,IconData icon,{bool green=false})=>Expanded(child:Card(child:Padding(padding:const EdgeInsets.all(16),child:Row(children:[Icon(icon,color:green?Colors.greenAccent:Colors.blueAccent),const SizedBox(width:10),Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(v,style:const TextStyle(fontSize:24,fontWeight:FontWeight.bold)),Text(t,style:const TextStyle(color:Colors.white70))])]))));
  Widget _camCard(CameraItem c)=>Card(clipBehavior:Clip.antiAlias,child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Expanded(child:c.photoUrl==null?const Center(child:Text('Sem foto')):Image.network(ApiService.media(c.photoUrl),fit:BoxFit.cover,width:double.infinity,errorBuilder:(_,__,___)=>const Center(child:Text('Erro imagem')))),Padding(padding:const EdgeInsets.all(10),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(c.local, maxLines:1, overflow:TextOverflow.ellipsis, style:const TextStyle(fontWeight:FontWeight.bold)),Text(c.name, style:const TextStyle(color:Colors.white70)),Text('● ${c.status}', style:TextStyle(color:c.status=='online'?Colors.greenAccent:Colors.orangeAccent))]))]));
}
