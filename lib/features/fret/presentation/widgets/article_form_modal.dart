import 'package:flutter/material.dart';

import '../../domain/enums/fret_enums.dart';
import '../../domain/models/article_fret.dart';
import '../../domain/models/fret_inputs.dart';

class ArticleFormModal extends StatefulWidget {
  const ArticleFormModal({
    super.key,
    this.article,
    this.onSubmit,
  });

  final ArticleFret? article;
  final Future<void> Function(ArticleFretInput)? onSubmit;

  @override
  State<ArticleFormModal> createState() => _ArticleFormModalState();
}

class _ArticleFormModalState extends State<ArticleFormModal> {
  final _formKey = GlobalKey<FormState>();
  final _designationController = TextEditingController();
  final _quantiteController = TextEditingController(text: '1');
  final _poidsController = TextEditingController(text: '0');
  final _volumeController = TextEditingController(text: '0');
  final _manutentionController = TextEditingController();
  CategorieArticle _categorie = CategorieArticle.mobilier;

  @override
  void initState() {
    super.initState();
    if (widget.article != null) {
      final article = widget.article!;
      _designationController.text = article.designation;
      _quantiteController.text = article.quantite.toString();
      _poidsController.text = article.poidsUnitaireKg.toString();
      _volumeController.text = article.volumeUnitaireM3.toString();
      _manutentionController.text = article.manutentionSpeciale ?? '';
      _categorie = article.categorie;
    }
  }

  @override
  void dispose() {
    _designationController.dispose();
    _quantiteController.dispose();
    _poidsController.dispose();
    _volumeController.dispose();
    _manutentionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.article == null ? 'Ajouter un article' : 'Modifier l\'article'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _designationController,
                decoration: const InputDecoration(labelText: 'Désignation'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La désignation est obligatoire.';
                  }
                  if (value.trim().length > 200) {
                    return 'Maximum 200 caractères.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _quantiteController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantité'),
                validator: (value) {
                  final parsed = int.tryParse(value ?? '');
                  if (parsed == null || parsed <= 0) {
                    return 'La quantité doit être supérieure à 0.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _poidsController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Poids unitaire (kg)'),
                validator: (value) {
                  final parsed = double.tryParse(value ?? '');
                  if (parsed == null || parsed < 0 || parsed > 10000) {
                    return 'Le poids doit être compris entre 0 et 10000.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _volumeController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Volume unitaire (m³)'),
                validator: (value) {
                  final parsed = double.tryParse(value ?? '');
                  if (parsed == null || parsed < 0 || parsed > 1000) {
                    return 'Le volume doit être compris entre 0 et 1000.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<CategorieArticle>(
                initialValue: _categorie,
                items: CategorieArticle.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(_categoryLabel(category)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _categorie = value);
                  }
                },
                decoration: const InputDecoration(labelText: 'Catégorie'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _manutentionController,
                decoration: const InputDecoration(labelText: 'Manutention spéciale (optionnel)'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? false) {
              final payload = ArticleFretInput(
                designation: _designationController.text.trim(),
                quantite: int.parse(_quantiteController.text),
                poidsUnitaireKg: double.parse(_poidsController.text),
                volumeUnitaireM3: double.parse(_volumeController.text),
                categorie: _categorie,
                manutentionSpeciale: _manutentionController.text.trim().isEmpty
                    ? null
                    : _manutentionController.text.trim(),
              );

              if (widget.onSubmit != null) {
                await widget.onSubmit!(payload);
              }

              if (context.mounted) {
                Navigator.of(context).pop();
              }
            }
          },
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  String _categoryLabel(CategorieArticle category) {
    switch (category) {
      case CategorieArticle.mobilier:
        return 'Mobilier';
      case CategorieArticle.sonoreEtEclairage:
        return 'Sonorisation & éclairage';
      case CategorieArticle.decoration:
        return 'Décoration';
      case CategorieArticle.materielTraiteur:
        return 'Matériel traiteur';
      case CategorieArticle.structureTente:
        return 'Structure tente';
      case CategorieArticle.autre:
        return 'Autre';
    }
  }
}
