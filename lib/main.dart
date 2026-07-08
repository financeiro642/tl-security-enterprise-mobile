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
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF020817),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF020817),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
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
  bool isLoading = true;
  bool hasError = false;

  final String initialUrl = 'http://zabbix.tlconsultorias.com.br:8088/login';

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF020817))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
              hasError = false;
            });
          },
          onPageFinished: (url) async {
            setState(() {
              isLoading = false;
            });

            await _injectMobileCss();
          },
          onWebResourceError: (error) {
            setState(() {
              isLoading = false;
              hasError = true;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(initialUrl));
  }

  Future<void> _injectMobileCss() async {
    await controller.runJavaScript('''
      (function() {
        var viewport = document.querySelector('meta[name="viewport"]');
        if (!viewport) {
          viewport = document.createElement('meta');
          viewport.name = 'viewport';
          document.head.appendChild(viewport);
        }
        viewport.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';

        var style = document.createElement('style');
        style.innerHTML = `
          html, body {
            max-width: 100% !important;
            overflow-x: hidden !important;
            background: #020817 !important;
          }

          body {
            margin: 0 !important;
          }

          img, video, canvas {
            max-width: 100% !important;
            height: auto !important;
          }

          table {
            max-width: 100% !important;
            overflow-x: auto !important;
          }

          button, a {
            touch-action: manipulation !important;
          }
        `;
        document.head.appendChild(style);
      })();
    ''');
  }

  Future<bool> _onBackPressed() async {
    if (await controller.canGoBack()) {
      await controller.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: const Row(
            children: [
              SizedBox(width: 8),
              Icon(Icons.security, size: 22),
              SizedBox(width: 8),
              Text(
                'TL Security',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Voltar',
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                if (await controller.canGoBack()) {
                  await controller.goBack();
                }
              },
            ),
            IconButton(
              tooltip: 'Atualizar',
              icon: const Icon(Icons.refresh),
              onPressed: () {
                controller.reload();
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            if (!hasError)
              WebViewWidget(controller: controller)
            else
              _ErrorView(
                onRetry: () {
                  setState(() {
                    hasError = false;
                    isLoading = true;
                  });
                  controller.loadRequest(Uri.parse(initialUrl));
                },
              ),

            if (isLoading)
              const LinearProgressIndicator(
                minHeight: 3,
              ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorView({
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off,
              size: 52,
              color: Colors.white70,
            ),
            const SizedBox(height: 16),
            const Text(
              'Não foi possível carregar o painel.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Verifique sua conexão ou tente novamente.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
