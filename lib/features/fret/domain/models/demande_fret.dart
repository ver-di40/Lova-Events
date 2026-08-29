// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/fret_enums.dart';

part 'demande_fret.freezed.dart';
part 'demande_fret.g.dart';

@freezed
class DemandeFret with _$DemandeFret {
  const factory DemandeFret({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'id_prestataire') required String idPrestataire,
    @JsonKey(name: 'adresse_depart') required String adresseDepart,
    @JsonKey(name: 'adresse_arrivee') required String adresseArrivee,
    @JsonKey(name: 'date_heure_souhaitee_depart') required DateTime dateHeureSouhaiteeDepart,
    @JsonKey(name: 'date_heure_retour_prevue') DateTime? dateHeureRetourPrevue,
    @JsonKey(name: 'type_vehicule_requis')
    @TypeVehiculeConverter()
    required TypeVehicule typeVehiculeRequis,
    @JsonKey(name: 'poids_total_estime_kg') required double poidsTotalEstimeKg,
    @JsonKey(name: 'volume_total_estime_m3') required double volumeTotalEstimeM3,
    @JsonKey(name: 'fragile') required bool fragile,
    @JsonKey(name: 'necessite_frigo') required bool necessiteFrigo,
    @JsonKey(name: 'necessite_manutention') required bool necessiteManutention,
    @JsonKey(name: 'nb_manutentionnaires_requis') required int nbManutentionnairesRequis,
    @JsonKey(name: 'description_complementaire') String? descriptionComplementaire,
    @JsonKey(name: 'statut') @StatutDemandeConverter() required StatutDemande statut,
    @JsonKey(name: 'date_creation') required DateTime dateCreation,
  }) = _DemandeFret;

  factory DemandeFret.fromJson(Map<String, Object?> json) => _$DemandeFretFromJson(json);
}
