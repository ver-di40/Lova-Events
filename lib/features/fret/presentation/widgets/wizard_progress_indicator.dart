import 'package:flutter/material.dart';

class WizardProgressIndicator extends StatelessWidget {
  const WizardProgressIndicator({
    super.key,
    required this.currentStep,
    this.steps = const ['Itinéraire', 'Véhicule', 'Inventaire', 'Récapitulatif'],
  });

  final int currentStep;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(steps.length, (index) {
        final isActive = index == currentStep;
        final isDone = index < currentStep;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: isActive
                        ? Theme.of(context).colorScheme.primary
                        : isDone
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: isActive
                            ? Theme.of(context).colorScheme.onPrimary
                            : isDone
                                ? Theme.of(context).colorScheme.onPrimaryContainer
                                : Colors.grey.shade700,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  steps[index],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isActive ? Theme.of(context).colorScheme.primary : null,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
