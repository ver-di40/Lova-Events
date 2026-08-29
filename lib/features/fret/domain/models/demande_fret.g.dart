// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demande_fret.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DemandeFretImpl _$$DemandeFretImplFromJson(Map<String, dynamic> json) =>
    _$DemandeFretImpl(
      id: json['id'] as String,
      idPrestataire: json['id_prestataire'] as String,
      adresseDepart: json['adresse_depart'] as String,
      adresseArrivee: json['adresse_arrivee'] as String,
      dateHeureSouhaiteeDepart: DateTime.parse(
        json['date_heure_souhaitee_depart'] as String,
      ),
      dateHeureRetourPrevue: json['date_heure_retour_prevue'] == null
          ? null
          : DateTime.parse(json['date_heure_retour_prevue'] as String),
      typeVehiculeRequis: const TypeVehiculeConverter().fromJson(
        json['type_vehicule_requis'] as String,
      ),
      poidsTotalEstimeKg: (json['poids_total_estime_kg'] as num).toDouble(),
      volumeTotalEstimeM3: (json['volume_total_estime_m3'] as num).toDouble(),
      fragile: json['fragile'] as bool,
      necessiteFrigo: json['necessite_frigo'] as bool,
      necessiteManutention: json['necessite_manutention'] as bool,
      nbManutentionnairesRequis: (json['nb_manutentionnaires_requis'] as num)
          .toInt(),
      descriptionComplementaire: json['description_complementaire'] as String?,
      statut: const StatutDemandeConverter().fromJson(json['statut'] as String),
      dateCreation: DateTime.parse(json['date_creation'] as String),
    );

Map<String, dynamic> _$$DemandeFretImplToJson(
  _$DemandeFretImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'id_prestataire': instance.idPrestataire,
  'adresse_depart': instance.adresseDepart,
  'adresse_arrivee': instance.adresseArrivee,
  'date_heure_souhaitee_depart': instance.dateHeureSouhaiteeDepart
      .toIso8601String(),
  'date_heure_retour_prevue': instance.dateHeureRetourPrevue?.toIso8601String(),
  'type_vehicule_requis': const TypeVehiculeConverter().toJson(
    instance.typeVehiculeRequis,
  ),
  'poids_total_estime_kg': instance.poidsTotalEstimeKg,
  'volume_total_estime_m3': instance.volumeTotalEstimeM3,
  'fragile': instance.fragile,
  'necessite_frigo': instance.necessiteFrigo,
  'necessite_manutention': instance.necessiteManutention,
  'nb_manutentionnaires_requis': instance.nbManutentionnairesRequis,
  'description_complementaire': instance.descriptionComplementaire,
  'statut': const StatutDemandeConverter().toJson(instance.statut),
  'date_creation': instance.dateCreation.toIso8601String(),
};
