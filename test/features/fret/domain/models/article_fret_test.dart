import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:lova_events/features/fret/domain/enums/fret_enums.dart';
import 'package:lova_events/features/fret/domain/models/article_fret.dart';

void main() {
  test('round-trip ArticleFret JSON for randomized values', () {
    const sampleCount = 100;
    final random = Random(20260829);

    for (var i = 0; i < sampleCount; i++) {
      final article = ArticleFret(
        id: 'article-$i',
        idDemande: 'demande-$i',
        designation: 'Article $i ${random.nextInt(9999)}',
        quantite: random.nextInt(50) + 1,
        poidsUnitaireKg: _randomDouble(random, 0, 2500),
        volumeUnitaireM3: _randomDouble(random, 0, 80),
        categorie: CategorieArticle.values[random.nextInt(CategorieArticle.values.length)],
        manutentionSpeciale: random.nextBool()
            ? 'Spécialité ${random.nextInt(1000)}'
            : null,
      );

      final json = article.toJson();
      final roundTrip = ArticleFret.fromJson(json);

      expect(roundTrip, equals(article));
    }
  });
}

double _randomDouble(Random random, double min, double max) {
  return min + random.nextDouble() * (max - min);
}
