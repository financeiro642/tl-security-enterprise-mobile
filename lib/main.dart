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
          centerTitle: false,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF020817),
          selectedItemColor: Color(0xFF22C55E),
          unselectedItemColor: Colors.white60,
          type: BottomNavigationBarType.fixed,
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
  static const String baseUrl = 'http://zabbix.tlconsultorias.com.br:8088';

  late final WebViewController controller;

  bool isLoading = true;
  bool hasError = false;
  bool showBottomMenu = false;

  int selectedIndex = 0;

  final List<_MenuItem> menus = const [
    _MenuItem(
      label: 'Dashboard',
      icon: Icons.dashboard_rounded,
      path: '/',
    ),
    _MenuItem(
      label: 'Câmeras',
      icon: Icons.videocam_rounded,
      path: '/cameras',
    ),
    _MenuItem(
      label: 'Eventos',
      icon: Icons.notifications_active_rounded,
      path: '/eventos',
    ),
  ];

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
  _updateMenuByUrl(url);

  setState(() {
    isLoading = false;
  });

  await _injectAppStyle(url);
  await _hideWebSidebar();
},
          onWebResourceError: (error) {
            setState(() {
              isLoading = false;
              hasError = true;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse('$baseUrl/login'));
  }

  void _updateMenuByUrl(String url) {
    final uri = Uri.tryParse(url);
    final path = uri?.path ?? '';

    final isLoginPage = path == '/login' || path.contains('login');

    int index = selectedIndex;

    for (int i = 0; i < menus.length; i++) {
      if (path.startsWith(menus[i].path)) {
        index = i;
        break;
      }
    }

    setState(() {
      showBottomMenu = !isLoginPage;
      selectedIndex = index;
    });
  }

  Future<void> _injectAppStyle(String url) async {
    final uri = Uri.tryParse(url);
    final path = uri?.path ?? '';
    final isLoginPage = path == '/login' || path.contains('login');

    final css = isLoginPage ? _loginCss : _panelCss;

    await controller.runJavaScript('''
      (function() {
        var viewport = document.querySelector('meta[name="viewport"]');

        if (!viewport) {
          viewport = document.createElement('meta');
          viewport.name = 'viewport';
          document.head.appendChild(viewport);
        }

        viewport.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';

        var oldStyle = document.getElementById('tl-security-mobile-style');
        if (oldStyle) {
          oldStyle.remove();
        }

        var style = document.createElement('style');
        style.id = 'tl-security-mobile-style';
        style.innerHTML = `$css`;
        document.head.appendChild(style);
      })();
    ''');
  }

  static const String _loginCss = '''
    html, body {
      width: 100% !important;
      min-height: 100% !important;
      margin: 0 !important;
      padding: 0 !important;
      overflow-x: hidden !important;
      background: linear-gradient(180deg, #020817 0%, #0f172a 100%) !important;
      font-family: Arial, sans-serif !important;
    }

    body {
      display: flex !important;
      align-items: center !important;
      justify-content: center !important;
      padding: 20px !important;
      box-sizing: border-box !important;
    }

    form,
    .login,
    .login-box,
    .login-card,
    .card,
    .container,
    .container-fluid {
      width: 100% !important;
      max-width: 420px !important;
      margin: 0 auto !important;
      border-radius: 22px !important;
      box-sizing: border-box !important;
    }

    form,
    .login-box,
    .login-card,
    .card {
      background: rgba(15, 23, 42, 0.96) !important;
      border: 1px solid rgba(148, 163, 184, 0.25) !important;
      box-shadow: 0 20px 50px rgba(0, 0, 0, 0.45) !important;
      padding: 24px !important;
    }

    input,
    select,
    textarea {
      width: 100% !important;
      min-height: 48px !important;
      border-radius: 14px !important;
      border: 1px solid rgba(148, 163, 184, 0.35) !important;
      background: #020817 !important;
      color: #ffffff !important;
      padding: 12px 14px !important;
      margin-bottom: 14px !important;
      box-sizing: border-box !important;
      font-size: 16px !important;
    }

    input::placeholder {
      color: #94a3b8 !important;
    }

    button,
    input[type="submit"] {
      width: 100% !important;
      min-height: 50px !important;
      border-radius: 14px !important;
      border: none !important;
      background: #22c55e !important;
      color: #020817 !important;
      font-weight: 700 !important;
      font-size: 16px !important;
      margin-top: 6px !important;
      cursor: pointer !important;
    }

    h1, h2, h3, h4, label, p, span, div {
      color: #ffffff;
    }

    a {
      color: #22c55e !important;
    }

    img {
      max-width: 120px !important;
      height: auto !important;
      margin: 0 auto 16px auto !important;
      display: block !important;
    }
  ''';

  static const String _panelCss = '''
    html, body {
      max-width: 100% !important;
      overflow-x: hidden !important;
      background: #020817 !important;
      margin: 0 !important;
      padding: 0 !important;
    }

    body {
      padding-bottom: 78px !important;
    }

    aside,
    nav.sidebar,
    .sidebar,
    .side-bar,
    .sidenav,
    .side-menu,
    .menu-lateral,
    .navbar,
    .topbar {
      display: none !important;
    }

    main,
    .main,
    .content,
    .main-content,
    .page-content,
    .container,
    .container-fluid,
    .wrapper {
      margin-left: 0 !important;
      padding-left: 10px !important;
      padding-right: 10px !important;
      width: 100% !important;
      max-width: 100% !important;
      box-sizing: border-box !important;
    }

    .card,
    .box,
    .panel {
      border-radius: 18px !important;
      margin-bottom: 14px !important;
      overflow: hidden !important;
    }

    img, video, canvas, iframe {
      max-width: 100% !important;
      height: auto !important;
    }

    table {
      width: 100% !important;
      display: block !important;
      overflow-x: auto !important;
      white-space: nowrap !important;
    }

    button, a {
      touch-action: manipulation !important;
    }
  ''';

  Future<bool> _onBackPressed() async {
    if (await controller.canGoBack()) {
      await controller.goBack();
      return false;
    }

    return true;
  }

  void _openMenu(int index) {
    setState(() {
      selectedIndex = index;
      isLoading = true;
    });

    controller.loadRequest(
      Uri.parse('$baseUrl${menus[index].path}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              Icon(Icons.security_rounded, size: 22),
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
              tooltip: 'Atualizar',
              icon: const Icon(Icons.refresh_rounded),
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

                  controller.loadRequest(Uri.parse('$baseUrl/login'));
                },
              ),
            if (isLoading)
              const LinearProgressIndicator(
                minHeight: 3,
                color: Color(0xFF22C55E),
                backgroundColor: Color(0xFF020817),
              ),
          ],
        ),
        bottomNavigationBar: showBottomMenu
            ? Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF020817),
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFF1E293B),
                      width: 1,
                    ),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: BottomNavigationBar(
                    currentIndex: selectedIndex,
                    onTap: _openMenu,
                    items: menus
                        .map(
                          (item) => BottomNavigationBarItem(
                            icon: Icon(item.icon),
                            label: item.label,
                          ),
                        )
                        .toList(),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

class _MenuItem {
  final String label;
  final IconData icon;
  final String path;

  const _MenuItem({
    required this.label,
    required this.icon,
    required this.path,
  });
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
              Icons.wifi_off_rounded,
              size: 54,
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
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
