// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/fret_enums.dart';

part 'fret_inputs.freezed.dart';
part 'fret_inputs.g.dart';

@freezed
class DemandeFretInput with _$DemandeFretInput {
  const factory DemandeFretInput({
    @JsonKey(name: 'adresse_depart') required String adresseDepart,
    @JsonKey(name: 'adresse_arrivee') required String adresseArrivee,
    @JsonKey(name: 'date_heure_souhaitee_depart') required DateTime dateHeureSouhaiteeDepart,
    @JsonKey(name: 'date_heure_retour_prevue') DateTime? dateHeureRetourPrevue,
    @JsonKey(name: 'type_vehicule_requis') @TypeVehiculeConverter() required TypeVehicule typeVehiculeRequis,
    @JsonKey(name: 'fragile') required bool fragile,
    @JsonKey(name: 'necessite_frigo') required bool necessiteFrigo,
    @JsonKey(name: 'necessite_manutention') required bool necessiteManutention,
    @JsonKey(name: 'nb_manutentionnaires_requis') required int nbManutentionnairesRequis,
    @JsonKey(name: 'description_complementaire') String? descriptionComplementaire,
  }) = _DemandeFretInput;

  factory DemandeFretInput.fromJson(Map<String, Object?> json) => _$DemandeFretInputFromJson(json);
}

@freezed
class ArticleFretInput with _$ArticleFretInput {
  const factory ArticleFretInput({
    @JsonKey(name: 'designation') required String designation,
    @JsonKey(name: 'quantite') required int quantite,
    @JsonKey(name: 'poids_unitaire_kg') required double poidsUnitaireKg,
    @JsonKey(name: 'volume_unitaire_m3') required double volumeUnitaireM3,
    @JsonKey(name: 'categorie') @CategorieArticleConverter() required CategorieArticle categorie,
    @JsonKey(name: 'manutention_speciale') String? manutentionSpeciale,
  }) = _ArticleFretInput;

  factory ArticleFretInput.fromJson(Map<String, Object?> json) => _$ArticleFretInputFromJson(json);
}
