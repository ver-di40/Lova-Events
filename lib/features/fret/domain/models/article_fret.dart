// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/fret_enums.dart';

part 'article_fret.freezed.dart';
part 'article_fret.g.dart';

@freezed
class ArticleFret with _$ArticleFret {
  const factory ArticleFret({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'id_demande') required String idDemande,
    @JsonKey(name: 'designation') required String designation,
    @JsonKey(name: 'quantite') required int quantite,
    @JsonKey(name: 'poids_unitaire_kg') required double poidsUnitaireKg,
    @JsonKey(name: 'volume_unitaire_m3') required double volumeUnitaireM3,
    @JsonKey(name: 'categorie') @CategorieArticleConverter() required CategorieArticle categorie,
    @JsonKey(name: 'manutention_speciale') String? manutentionSpeciale,
  }) = _ArticleFret;

  factory ArticleFret.fromJson(Map<String, Object?> json) => _$ArticleFretFromJson(json);
}
