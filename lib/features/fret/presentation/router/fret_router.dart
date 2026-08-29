import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/fret_repository_impl.dart';
import '../screens/dashboard_fret_screen.dart';
import '../screens/fret_detail_screen.dart';
import '../screens/wizard_fret_screen.dart';

final fretRouter = GoRouter(
  initialLocation: '/fret',
  redirect: (context, state) {
    final isAuthRoute = state.matchedLocation.startsWith('/auth/');

    bool isAuthenticated() {
      try {
        return Supabase.instance.client.auth.currentSession != null;
      } catch (_) {
        return false;
      }
    }

    if (!isAuthenticated() && !isAuthRoute) {
      final redirectTarget = state.matchedLocation == '/' ? '/fret' : state.matchedLocation;
      return '/auth/login?redirect=${Uri.encodeComponent(redirectTarget)}';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const _HomeShellPage(currentIndex: 0),
    ),
    GoRoute(
      path: '/auth/login',
      builder: (context, state) {
        final redirectTarget = state.uri.queryParameters['redirect'] ?? '/fret';
        return Scaffold(
          appBar: AppBar(title: const Text('Connexion')),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Vous devez être connecté pour accéder à cette page.'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.go(redirectTarget),
                    child: const Text('Continuer'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: '/fret',
      builder: (context, state) => const DashboardFretScreen(),
    ),
    GoRoute(
      path: '/fret/new',
      builder: (context, state) => const WizardFretScreen(),
    ),
    GoRoute(
      path: '/fret/:id',
      builder: (context, state) => FretDetailScreen(
        id: state.pathParameters['id'] ?? 'inconnu',
      ),
    ),
    GoRoute(
      path: '/fret/:id/edit',
      builder: (context, state) => _FretEditPage(
        id: state.pathParameters['id'] ?? 'inconnu',
      ),
    ),
  ],
);

class _FretBottomNavigationBar extends StatelessWidget {
  const _FretBottomNavigationBar({required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/fret');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_shipping_outlined),
          activeIcon: Icon(Icons.local_shipping),
          label: 'Missions',
        ),
      ],
    );
  }
}

class _HomeShellPage extends StatelessWidget {
  const _HomeShellPage({required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lova Events')),
      body: const Center(
        child: Text('Accueil'),
      ),
      bottomNavigationBar: _FretBottomNavigationBar(currentIndex: currentIndex),
    );
  }
}

class _FretEditPage extends StatefulWidget {
  const _FretEditPage({required this.id});

  final String id;

  @override
  State<_FretEditPage> createState() => _FretEditPageState();
}

class _FretEditPageState extends State<_FretEditPage> {
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }

      final repository = FretRepositoryImpl(Supabase.instance.client);
      final demande = await repository.getDemande(widget.id);

      if (!mounted) {
        return;
      }

      if (demande == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Demande introuvable')),
        );
        context.go('/fret');
        return;
      }

      setState(() {
        _checked = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Édition de la demande')),
      body: Center(
        child: _checked
            ? const Text('Écran d’édition Fret')
            : const CircularProgressIndicator(),
      ),
    );
  }
}
