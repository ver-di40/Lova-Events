import 'package:flutter/material.dart';

import '../../domain/enums/fret_enums.dart';
import '../../domain/models/article_fret.dart';

class ArticleListItem extends StatelessWidget {
  const ArticleListItem({
    super.key,
    required this.article,
    required this.canDelete,
    this.onDelete,
  });

  final ArticleFret article;
  final bool canDelete;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.designation,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Qté: ${article.quantite} • ${_categoryLabel(article.categorie)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 6),
                Text(
                  'Poids: ${article.poidsUnitaireKg} kg • Volume: ${article.volumeUnitaireM3} m³',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (canDelete)
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
    );

    if (!canDelete) {
      return child;
    }

    return Dismissible(
      key: ValueKey(article.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        if (!canDelete) {
          return false;
        }
        onDelete?.call();
        return true;
      },
      child: child,
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
