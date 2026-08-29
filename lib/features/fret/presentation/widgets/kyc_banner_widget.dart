import 'package:flutter/material.dart';

class KycBannerWidget extends StatelessWidget {
  const KycBannerWidget({super.key, this.onVerifyPressed});

  final VoidCallback? onVerifyPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.amber.shade800),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Votre identité n\'est pas encore vérifiée',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: onVerifyPressed ?? () {},
            child: const Text('Vérifier mon identité'),
          ),
        ],
      ),
    );
  }
}
