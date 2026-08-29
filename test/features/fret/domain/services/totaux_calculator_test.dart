import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:lova_events/features/fret/application/services/totaux_calculator.dart';
import 'package:lova_events/features/fret/domain/enums/fret_enums.dart';
import 'package:lova_events/features/fret/domain/models/article_fret.dart';

void main() {
  group('TotauxCalculator', () {
    final calculator = TotauxCalculator();
    final random = Random(20260829);

    test('confluence des totaux pour toutes les permutations', () {
      for (var i = 0; i < 100; i++) {
        final articles = List.generate(random.nextInt(8) + 1, (index) {
          final quantity = random.nextInt(9) + 1;
          return ArticleFret(
            id: 'article-$i-$index',
            idDemande: 'demande-$i',
            designation: 'Article $index',
            quantite: quantity,
            poidsUnitaireKg: random.nextDouble() * 100,
            volumeUnitaireM3: random.nextDouble() * 50,
            categorie: CategorieArticle.values[random.nextInt(CategorieArticle.values.length)],
            manutentionSpeciale: random.nextBool() ? 'Manutention $index' : null,
          );
        });

        final expectedPoids = calculator.calculerPoidsTotal(articles);
        final expectedVolume = calculator.calculerVolumeTotal(articles);

        final shuffledA = [...articles]..shuffle(random);
        final shuffledB = [...articles]..shuffle(random);

        expect(calculator.calculerPoidsTotal(shuffledA), equals(expectedPoids));
        expect(calculator.calculerPoidsTotal(shuffledB), equals(expectedPoids));
        expect(calculator.calculerVolumeTotal(shuffledA), equals(expectedVolume));
        expect(calculator.calculerVolumeTotal(shuffledB), equals(expectedVolume));
      }
    });

    test('neutralité de la liste vide', () {
      expect(calculator.calculerPoidsTotal([]), equals(0.0));
      expect(calculator.calculerVolumeTotal([]), equals(0.0));
    });

    test('arrondi HALF_UP correct pour les valeurs positives', () {
      for (var i = 0; i < 100; i++) {
        final value = random.nextDouble() * 1000;

        final articlePoids = ArticleFret(
          id: 'poids-$i',
          idDemande: 'demande-$i',
          designation: 'Poids $i',
          quantite: 1,
          poidsUnitaireKg: value,
          volumeUnitaireM3: 0,
          categorie: CategorieArticle.autre,
        );

        final articleVolume = ArticleFret(
          id: 'volume-$i',
          idDemande: 'demande-$i',
          designation: 'Volume $i',
          quantite: 1,
          poidsUnitaireKg: 0,
          volumeUnitaireM3: value,
          categorie: CategorieArticle.autre,
        );

        expect(
          calculator.calculerPoidsTotal([articlePoids]),
          equals(TotauxCalculator.roundHalfUp(value, 2)),
        );
        expect(
          calculator.calculerVolumeTotal([articleVolume]),
          equals(TotauxCalculator.roundHalfUp(value, 3)),
        );
      }
    });
  });
}
