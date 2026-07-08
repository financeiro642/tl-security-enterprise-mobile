import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const TLSecurityApp());
}

class TLSecurityApp extends StatelessWidget {
  const TLSecurityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TL Security Enterprise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const WebPanelPage(),
    );
  }
}

class WebPanelPage extends StatefulWidget {
  const WebPanelPage({super.key});

  @override
  State<WebPanelPage> createState() => _WebPanelPageState();
}

class _WebPanelPageState extends State<WebPanelPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('http://zabbix.tlconsultorias.com.br:8088/login'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
