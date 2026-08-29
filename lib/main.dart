import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/fret/presentation/router/fret_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Ignore missing or unreadable .env files so the app can still boot in tests or local dev.
  }

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabasePublishableKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl != null &&
      supabasePublishableKey != null &&
      supabaseUrl.isNotEmpty &&
      supabasePublishableKey.isNotEmpty) {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabasePublishableKey,
    );
  }

  runApp(const LovaEventsApp());
}

class LovaEventsApp extends StatelessWidget {
  const LovaEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Lova Events',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7A1F3D)),
        useMaterial3: true,
      ),
      routerConfig: fretRouter,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 120 : 24,
            vertical: 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Lova Events',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Application événementielle connectée à Supabase en ligne',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Base monorepo Flutter + Supabase prête à être étendue avec auth, événements, prestataires et dashboard.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      _InfoCard(
                        title: 'Frontend',
                        value: 'Flutter Web responsive',
                        color: const Color(0xFF7A1F3D),
                      ),
                      _InfoCard(
                        title: 'Backend',
                        value: 'Supabase Auth + Database',
                        color: const Color(0xFF2E7D32),
                      ),
                      _InfoCard(
                        title: 'Migrations',
                        value: 'SQL versionnées',
                        color: const Color(0xFF1565C0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
