import 'dart:math' as math;

import '../../domain/models/article_fret.dart';

class TotauxCalculator {
  const TotauxCalculator();

  double calculerPoidsTotal(List<ArticleFret> articles) {
    if (articles.isEmpty) {
      return 0.0;
    }

    final total = articles.fold<double>(
      0,
      (sum, article) => sum + (article.quantite * article.poidsUnitaireKg),
    );

    return roundHalfUp(total, 2);
  }

  double calculerVolumeTotal(List<ArticleFret> articles) {
    if (articles.isEmpty) {
      return 0.0;
    }

    final total = articles.fold<double>(
      0,
      (sum, article) => sum + (article.quantite * article.volumeUnitaireM3),
    );

    return roundHalfUp(total, 3);
  }

  static double roundHalfUp(double value, int digits) {
    final factor = math.pow(10, digits).toDouble();
    return (value * factor).roundToDouble() / factor;
  }
}
