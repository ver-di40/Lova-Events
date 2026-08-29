import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/services/totaux_calculator.dart';
import '../../domain/enums/fret_enums.dart';
import '../../domain/models/article_fret.dart';
import '../../domain/models/demande_fret.dart';
import '../../domain/models/fret_inputs.dart';
import '../state/wizard_fret_notifier.dart';
import '../widgets/article_form_modal.dart';
import '../widgets/article_list_item.dart';
import '../widgets/totaux_widget.dart';
import '../widgets/vehicle_selection_grid.dart';
import '../widgets/wizard_progress_indicator.dart';
import '../widgets/wizard_save_state_header.dart';

class WizardFretScreen extends ConsumerStatefulWidget {
  const WizardFretScreen({super.key});

  @override
  ConsumerState<WizardFretScreen> createState() => _WizardFretScreenState();
}

class _WizardFretScreenState extends ConsumerState<WizardFretScreen> {
  late final PageController _pageController;
  final GlobalKey<FormState> _step1FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _step2FormKey = GlobalKey<FormState>();

  final TextEditingController _adresseDepartController = TextEditingController();
  final TextEditingController _adresseArriveeController = TextEditingController();
  final TextEditingController _descriptionComplementaireController = TextEditingController();

  DateTime? _dateDepart;
  DateTime? _dateRetour;
  bool _retourPrevu = false;
  bool _necessiteFrigo = false;
  bool _necessiteManutention = false;
  int _nbManutentionnairesRequis = 1;
  TypeVehicule _selectedVehicle = TypeVehicule.fourgon;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      ref.read(wizardFretNotifierProvider.notifier).initDraft(null);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _adresseDepartController.dispose();
    _adresseArriveeController.dispose();
    _descriptionComplementaireController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wizardState = ref.watch(wizardFretNotifierProvider);

    if (_pageController.hasClients && _pageController.page?.round() != wizardState.currentStep) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_pageController.hasClients) {
          return;
        }
        _pageController.animateToPage(
          wizardState.currentStep,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        );
      });
    }

    final totalPoids = const TotauxCalculator().calculerPoidsTotal(wizardState.articles);
    final totalVolume = const TotauxCalculator().calculerVolumeTotal(wizardState.articles);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Retour au dashboard'),
            content: const Text(
              'Votre brouillon est sauvegardé. Voulez-vous revenir à la liste des missions ?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Annuler'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Oui, revenir'),
              ),
            ],
          ),
        );

        if (confirmed == true && context.mounted) {
          context.go('/fret');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nouvelle demande'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                WizardSaveStateHeader(state: wizardState.saveState),
                const SizedBox(height: 12),
                WizardProgressIndicator(currentStep: wizardState.currentStep),
                const SizedBox(height: 20),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Step1ItineraireView(
                        formKey: _step1FormKey,
                        adresseDepartController: _adresseDepartController,
                        adresseArriveeController: _adresseArriveeController,
                        descriptionComplementaireController: _descriptionComplementaireController,
                        dateDepart: _dateDepart,
                        dateRetour: _dateRetour,
                        retourPrevu: _retourPrevu,
                        onDateDepartChanged: (date) => setState(() => _dateDepart = date),
                        onDateRetourChanged: (date) => setState(() => _dateRetour = date),
                        onRetourChanged: (value) => setState(() {
                          _retourPrevu = value;
                          if (!value) {
                            _dateRetour = null;
                          }
                        }),
                      ),
                      Step2VehiculeBesoinsView(
                        formKey: _step2FormKey,
                        selectedVehicle: _selectedVehicle,
                        necessiteFrigo: _necessiteFrigo,
                        necessiteManutention: _necessiteManutention,
                        nbManutentionnairesRequis: _nbManutentionnairesRequis,
                        onVehicleSelected: (value) => setState(() => _selectedVehicle = value),
                        onFrigoChanged: (value) => setState(() {
                          _necessiteFrigo = value;
                          if (!value) {
                            _selectedVehicle = TypeVehicule.camionFrigo;
                          }
                        }),
                        onManutentionChanged: (value) => setState(() {
                          _necessiteManutention = value;
                          if (!value) {
                            _nbManutentionnairesRequis = 0;
                          }
                        }),
                        onNbManutentionnairesChanged: (value) => setState(() => _nbManutentionnairesRequis = value),
                      ),
                      Step3InventaireView(
                        articles: wizardState.articles,
                        poidsTotalKg: totalPoids,
                        volumeTotalM3: totalVolume,
                        onAddArticle: () async {
                          final article = await showDialog<ArticleFretInput>(
                            context: context,
                            builder: (dialogContext) => ArticleFormModal(
                              onSubmit: (input) async {
                                await ref.read(wizardFretNotifierProvider.notifier).addArticle(input);
                              },
                            ),
                          );
                          if (article != null) {
                            await ref.read(wizardFretNotifierProvider.notifier).addArticle(article);
                          }
                        },
                        onDeleteArticle: (articleId) async {
                          await ref.read(wizardFretNotifierProvider.notifier).deleteArticle(articleId);
                        },
                      ),
                      Step4RecapitulatifView(
                        demande: wizardState.demande,
                        articles: wizardState.articles,
                        poidsTotalKg: totalPoids,
                        volumeTotalM3: totalVolume,
                        onEditStep: (stepIndex) => _goToStep(stepIndex),
                        onPublish: () async {
                          await ref.read(wizardFretNotifierProvider.notifier).publier();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _WizardNavigationBar(
                  currentStep: wizardState.currentStep,
                  onPrevious: () => ref.read(wizardFretNotifierProvider.notifier).previousStep(),
                  onNext: () async {
                    if (wizardState.currentStep == 0 && !_step1FormKey.currentState!.validate()) {
                      return;
                    }
                    if (wizardState.currentStep == 1 && !_step2FormKey.currentState!.validate()) {
                      return;
                    }

                    final notifier = ref.read(wizardFretNotifierProvider.notifier);
                    final input = DemandeFretInput(
                      adresseDepart: _adresseDepartController.text.trim(),
                      adresseArrivee: _adresseArriveeController.text.trim(),
                      dateHeureSouhaiteeDepart: _dateDepart ?? DateTime.now().add(const Duration(hours: 2)),
                      dateHeureRetourPrevue: _retourPrevu ? _dateRetour : null,
                      typeVehiculeRequis: _selectedVehicle,
                      fragile: false,
                      necessiteFrigo: _necessiteFrigo,
                      necessiteManutention: _necessiteManutention,
                      nbManutentionnairesRequis: _necessiteManutention ? _nbManutentionnairesRequis : 0,
                      descriptionComplementaire: _descriptionComplementaireController.text.trim().isEmpty
                          ? null
                          : _descriptionComplementaireController.text.trim(),
                    );

                    await notifier.nextStep(input);
                  },
                  onPublish: () async {
                    await ref.read(wizardFretNotifierProvider.notifier).publier();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goToStep(int stepIndex) {
    ref.read(wizardFretNotifierProvider.notifier).setCurrentStep(stepIndex);
    _pageController.animateToPage(
      stepIndex,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }
}

class Step1ItineraireView extends StatelessWidget {
  const Step1ItineraireView({
    super.key,
    required this.formKey,
    required this.adresseDepartController,
    required this.adresseArriveeController,
    required this.descriptionComplementaireController,
    required this.dateDepart,
    required this.dateRetour,
    required this.retourPrevu,
    required this.onDateDepartChanged,
    required this.onDateRetourChanged,
    required this.onRetourChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController adresseDepartController;
  final TextEditingController adresseArriveeController;
  final TextEditingController descriptionComplementaireController;
  final DateTime? dateDepart;
  final DateTime? dateRetour;
  final bool retourPrevu;
  final ValueChanged<DateTime?> onDateDepartChanged;
  final ValueChanged<DateTime?> onDateRetourChanged;
  final ValueChanged<bool> onRetourChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Text(
                'Itinéraire',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: adresseDepartController,
                decoration: const InputDecoration(labelText: 'Adresse départ'),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return 'L’adresse de départ est obligatoire.';
                  if (text.length > 255) return 'Maximum 255 caractères.';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: adresseArriveeController,
                decoration: const InputDecoration(labelText: 'Adresse arrivée'),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return 'L’adresse d’arrivée est obligatoire.';
                  if (text.length > 255) return 'Maximum 255 caractères.';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _DateField(
                label: 'Date et heure de départ',
                value: dateDepart,
                onChanged: onDateDepartChanged,
                validator: (value) {
                  if (value == null) return 'La date de départ est obligatoire.';
                  final minimum = DateTime.now().add(const Duration(hours: 1));
                  if (value.isBefore(minimum)) return 'La date doit être > maintenant + 1h.';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                value: retourPrevu,
                contentPadding: EdgeInsets.zero,
                title: const Text('Retour prévu'),
                onChanged: onRetourChanged,
              ),
              if (retourPrevu) ...[
                const SizedBox(height: 12),
                _DateField(
                  label: 'Date et heure de retour',
                  value: dateRetour,
                  onChanged: onDateRetourChanged,
                  validator: (value) {
                    if (value == null) return 'La date de retour est obligatoire.';
                    if (dateDepart == null) return 'Renseignez d’abord la date de départ.';
                    if (value.isBefore(dateDepart!.add(const Duration(minutes: 1)))) {
                      return 'Le retour doit être postérieur au départ.';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionComplementaireController,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Description complémentaire (optionnel)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Step2VehiculeBesoinsView extends StatelessWidget {
  const Step2VehiculeBesoinsView({
    super.key,
    required this.formKey,
    required this.selectedVehicle,
    required this.necessiteFrigo,
    required this.necessiteManutention,
    required this.nbManutentionnairesRequis,
    required this.onVehicleSelected,
    required this.onFrigoChanged,
    required this.onManutentionChanged,
    required this.onNbManutentionnairesChanged,
  });

  final GlobalKey<FormState> formKey;
  final TypeVehicule selectedVehicle;
  final bool necessiteFrigo;
  final bool necessiteManutention;
  final int nbManutentionnairesRequis;
  final ValueChanged<TypeVehicule> onVehicleSelected;
  final ValueChanged<bool> onFrigoChanged;
  final ValueChanged<bool> onManutentionChanged;
  final ValueChanged<int> onNbManutentionnairesChanged;

  @override
  Widget build(BuildContext context) {
    final isFrigoBlock = necessiteFrigo && selectedVehicle != TypeVehicule.camionFrigo;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Text(
                'Véhicule & besoins',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              VehicleSelectionGrid(
                selected: selectedVehicle,
                necessiteFrigo: necessiteFrigo,
                onSelected: onVehicleSelected,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                value: necessiteFrigo,
                contentPadding: EdgeInsets.zero,
                title: const Text('Froid requis'),
                onChanged: onFrigoChanged,
              ),
              SwitchListTile(
                value: necessiteManutention,
                contentPadding: EdgeInsets.zero,
                title: const Text('Manutention'),
                onChanged: onManutentionChanged,
              ),
              if (necessiteManutention) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Nombre de manutentionnaires requis',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    IconButton(
                      onPressed: nbManutentionnairesRequis > 1
                          ? () => onNbManutentionnairesChanged(nbManutentionnairesRequis - 1)
                          : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Text('$nbManutentionnairesRequis'),
                    IconButton(
                      onPressed: () => onNbManutentionnairesChanged(nbManutentionnairesRequis + 1),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
              if (isFrigoBlock) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: const Text('RG3 : le froid requis impose un camion frigorifique.'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class Step3InventaireView extends StatelessWidget {
  const Step3InventaireView({
    super.key,
    required this.articles,
    required this.poidsTotalKg,
    required this.volumeTotalM3,
    required this.onAddArticle,
    required this.onDeleteArticle,
  });

  final List<ArticleFret> articles;
  final double poidsTotalKg;
  final double volumeTotalM3;
  final VoidCallback onAddArticle;
  final ValueChanged<String> onDeleteArticle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Inventaire',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                FloatingActionButton.small(
                  onPressed: articles.length >= 50 ? null : onAddArticle,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            if (articles.length >= 50)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Limite de 50 articles atteinte.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
                ),
              ),
            const SizedBox(height: 12),
            if (articles.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'Aucun article pour le moment.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: articles.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return ArticleListItem(
                      article: article,
                      canDelete: true,
                      onDelete: () => onDeleteArticle(article.id),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            TotauxWidget(
              poidsTotalKg: poidsTotalKg,
              volumeTotalM3: volumeTotalM3,
            ),
          ],
        ),
      ),
    );
  }
}

class Step4RecapitulatifView extends StatelessWidget {
  const Step4RecapitulatifView({
    super.key,
    required this.demande,
    required this.articles,
    required this.poidsTotalKg,
    required this.volumeTotalM3,
    required this.onEditStep,
    required this.onPublish,
  });

  final DemandeFret? demande;
  final List<ArticleFret> articles;
  final double poidsTotalKg;
  final double volumeTotalM3;
  final ValueChanged<int> onEditStep;
  final VoidCallback onPublish;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'Récapitulatif',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            _SummaryLine(
              label: 'Itinéraire',
              value: '${demande?.adresseDepart ?? '—'} → ${demande?.adresseArrivee ?? '—'}',
              onEdit: () => onEditStep(0),
            ),
            _SummaryLine(
              label: 'Date départ',
              value: demande?.dateHeureSouhaiteeDepart.toString() ?? '—',
              onEdit: () => onEditStep(0),
            ),
            _SummaryLine(
              label: 'Véhicule',
              value: _vehicleLabel(demande?.typeVehiculeRequis ?? TypeVehicule.fourgon),
              onEdit: () => onEditStep(1),
            ),
            _SummaryLine(
              label: 'Besoins',
              value: _needsLabel(demande),
              onEdit: () => onEditStep(1),
            ),
            _SummaryLine(
              label: 'Articles',
              value: '${articles.length} article(s)',
              onEdit: () => onEditStep(2),
            ),
            _SummaryLine(
              label: 'Poids total',
              value: '${poidsTotalKg.toStringAsFixed(2)} kg',
              onEdit: () => onEditStep(2),
            ),
            _SummaryLine(
              label: 'Volume total',
              value: '${volumeTotalM3.toStringAsFixed(3)} m³',
              onEdit: () => onEditStep(2),
            ),
            if ((demande?.descriptionComplementaire ?? '').isNotEmpty)
              _SummaryLine(
                label: 'Description',
                value: demande!.descriptionComplementaire!,
                onEdit: () => onEditStep(0),
              ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onPublish,
              icon: const Icon(Icons.publish),
              label: const Text('Publier la demande'),
            ),
          ],
        ),
      ),
    );
  }

  String _needsLabel(DemandeFret? demande) {
    if (demande == null) {
      return 'Non renseigné';
    }

    final parts = <String>[];
    if (demande.necessiteFrigo) parts.add('Froid');
    if (demande.necessiteManutention) parts.add('Manutention');
    if (parts.isEmpty) return 'Aucun besoin particulier';
    return parts.join(', ');
  }

  String _vehicleLabel(TypeVehicule vehicle) {
    switch (vehicle) {
      case TypeVehicule.fourgon:
        return 'Fourgon';
      case TypeVehicule.camionPlateau:
        return 'Camion plateau';
      case TypeVehicule.camionFrigo:
        return 'Camion frigo';
      case TypeVehicule.camionBenne:
        return 'Camion benne';
      case TypeVehicule.indifferent:
        return 'Indifférent';
    }
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    required this.onEdit,
  });

  final String label;
  final String value;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                Text(value),
              ],
            ),
          ),
          TextButton(
            onPressed: onEdit,
            child: const Text('Modifier'),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.validator,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final String? Function(DateTime?) validator;

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: value,
      validator: validator,
      builder: (field) {
        final textValue = value == null ? 'Non renseigné' : _formatDateTime(value!);

        return InkWell(
          onTap: () async {
            final fieldContext = context;
            final selected = await showDatePicker(
              context: fieldContext,
              initialDate: value ?? DateTime.now().add(const Duration(hours: 2)),
              firstDate: DateTime.now().subtract(const Duration(days: 1)),
              lastDate: DateTime.now().add(const Duration(days: 3650)),
            );
            if (selected == null || !fieldContext.mounted) {
              return;
            }

            final time = await showTimePicker(
              context: fieldContext,
              initialTime: TimeOfDay.fromDateTime(value ?? DateTime.now().add(const Duration(hours: 2))),
            );
            if (!fieldContext.mounted) {
              return;
            }

            final dt = DateTime(
              selected.year,
              selected.month,
              selected.day,
              time?.hour ?? 9,
              time?.minute ?? 0,
            );
            onChanged(dt);
            field.didChange(dt);
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              errorText: field.errorText,
            ),
            child: Text(textValue),
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime value) {
    final date = '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
    final time = '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
    return '$date $time';
  }
}

class _WizardNavigationBar extends StatelessWidget {
  const _WizardNavigationBar({
    required this.currentStep,
    required this.onPrevious,
    required this.onNext,
    required this.onPublish,
  });

  final int currentStep;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onPublish;

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentStep == 3;

    return Row(
      children: [
        if (currentStep > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: onPrevious,
              child: const Text('Précédent'),
            ),
          )
        else
          const Spacer(),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: isLastStep ? onPublish : onNext,
            child: Text(isLastStep ? 'Publier' : 'Suivant'),
          ),
        ),
      ],
    );
  }
}
