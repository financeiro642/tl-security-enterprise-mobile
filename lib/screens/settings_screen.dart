import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget{const SettingsScreen({super.key});
 @override Widget build(BuildContext context)=>SafeArea(child:Scaffold(appBar:AppBar(title:const Text('Configurações')),body:ListView(padding:const EdgeInsets.all(16),children:[
  const Card(child:ListTile(leading:Icon(Icons.notifications),title:Text('Notificações'),subtitle:Text('Configurar alertas e sons'),trailing:Icon(Icons.chevron_right))),
  const Card(child:ListTile(leading:Icon(Icons.videocam),title:Text('Câmeras'),subtitle:Text('Configurações de câmeras'),trailing:Icon(Icons.chevron_right))),
  const Card(child:ListTile(leading:Icon(Icons.security),title:Text('Segurança'),subtitle:Text('Usuários e autenticação'),trailing:Icon(Icons.chevron_right))),
  const Card(child:ListTile(leading:Icon(Icons.info),title:Text('Sobre'),subtitle:Text('TL Security Enterprise v1.0'))),
  const SizedBox(height:20),
  FilledButton.icon(onPressed:() async {final p=await SharedPreferences.getInstance(); await p.clear(); if(context.mounted){Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const LoginScreen()));}}, icon:const Icon(Icons.logout), label:const Text('Sair'))
 ])));
}
