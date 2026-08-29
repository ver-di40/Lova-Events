import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/providers/fret_providers.dart';
import '../widgets/kyc_banner_widget.dart';
import '../widgets/mission_card.dart';

class DashboardFretScreen extends ConsumerWidget {
  const DashboardFretScreen({
    super.key,
    this.showKycBanner = true,
  });

  final bool showKycBanner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDemandes = ref.watch(demandesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Missions'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(demandesListProvider);
          await ref.read(demandesListProvider.future);
        },
        child: asyncDemandes.when(
          data: (demandes) {
            final missions = [...demandes]
              ..sort((a, b) => b.dateCreation.compareTo(a.dateCreation));

            if (missions.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                children: [
                  if (showKycBanner) ...[
                    const KycBannerWidget(),
                    const SizedBox(height: 24),
                  ],
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_shipping_outlined, size: 64),
                        const SizedBox(height: 16),
                        Text(
                          'Aucune demande de fret pour le moment',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () => context.go('/fret/new'),
                          child: const Text('Créer ma première demande'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: missions.length + (showKycBanner ? 1 : 0),
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (showKycBanner && index == 0) {
                  return const KycBannerWidget();
                }

                final missionIndex = showKycBanner ? index - 1 : index;
                final mission = missions[missionIndex];
                return MissionCard(demande: mission);
              },
            );
          },
          error: (error, stackTrace) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                if (showKycBanner) ...[
                  const KycBannerWidget(),
                  const SizedBox(height: 24),
                ],
                ErrorStateWidget(
                  onRetry: () => ref.invalidate(demandesListProvider),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/fret/new'),
        icon: const Icon(Icons.add),
        label: const Text('+ Publier une demande de fret'),
      ),
    );
  }
}

class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    super.key,
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(
              'Une erreur est survenue',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Impossible de récupérer les demandes de fret.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
