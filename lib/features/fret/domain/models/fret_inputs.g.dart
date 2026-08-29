// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fret_inputs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DemandeFretInputImpl _$$DemandeFretInputImplFromJson(
  Map<String, dynamic> json,
) => _$DemandeFretInputImpl(
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
  fragile: json['fragile'] as bool,
  necessiteFrigo: json['necessite_frigo'] as bool,
  necessiteManutention: json['necessite_manutention'] as bool,
  nbManutentionnairesRequis: (json['nb_manutentionnaires_requis'] as num)
      .toInt(),
  descriptionComplementaire: json['description_complementaire'] as String?,
);

Map<String, dynamic> _$$DemandeFretInputImplToJson(
  _$DemandeFretInputImpl instance,
) => <String, dynamic>{
  'adresse_depart': instance.adresseDepart,
  'adresse_arrivee': instance.adresseArrivee,
  'date_heure_souhaitee_depart': instance.dateHeureSouhaiteeDepart
      .toIso8601String(),
  'date_heure_retour_prevue': instance.dateHeureRetourPrevue?.toIso8601String(),
  'type_vehicule_requis': const TypeVehiculeConverter().toJson(
    instance.typeVehiculeRequis,
  ),
  'fragile': instance.fragile,
  'necessite_frigo': instance.necessiteFrigo,
  'necessite_manutention': instance.necessiteManutention,
  'nb_manutentionnaires_requis': instance.nbManutentionnairesRequis,
  'description_complementaire': instance.descriptionComplementaire,
};

_$ArticleFretInputImpl _$$ArticleFretInputImplFromJson(
  Map<String, dynamic> json,
) => _$ArticleFretInputImpl(
  designation: json['designation'] as String,
  quantite: (json['quantite'] as num).toInt(),
  poidsUnitaireKg: (json['poids_unitaire_kg'] as num).toDouble(),
  volumeUnitaireM3: (json['volume_unitaire_m3'] as num).toDouble(),
  categorie: const CategorieArticleConverter().fromJson(
    json['categorie'] as String,
  ),
  manutentionSpeciale: json['manutention_speciale'] as String?,
);

Map<String, dynamic> _$$ArticleFretInputImplToJson(
  _$ArticleFretInputImpl instance,
) => <String, dynamic>{
  'designation': instance.designation,
  'quantite': instance.quantite,
  'poids_unitaire_kg': instance.poidsUnitaireKg,
  'volume_unitaire_m3': instance.volumeUnitaireM3,
  'categorie': const CategorieArticleConverter().toJson(instance.categorie),
  'manutention_speciale': instance.manutentionSpeciale,
};
