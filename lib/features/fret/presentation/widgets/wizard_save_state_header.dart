import 'package:flutter/material.dart';

import '../../application/services/auto_save_service.dart';

class WizardSaveStateHeader extends StatelessWidget {
  const WizardSaveStateHeader({
    super.key,
    required this.state,
  });

  final SaveState state;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case SaveState.saving:
        return const Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 8),
            Text('Sauvegarde…'),
          ],
        );
      case SaveState.saved:
        return const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Brouillon sauvegardé'),
          ],
        );
      case SaveState.error:
        return const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Échec de sauvegarde'),
          ],
        );
    }
  }
}
