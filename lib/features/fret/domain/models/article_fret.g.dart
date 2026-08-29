// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_fret.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArticleFretImpl _$$ArticleFretImplFromJson(Map<String, dynamic> json) =>
    _$ArticleFretImpl(
      id: json['id'] as String,
      idDemande: json['id_demande'] as String,
      designation: json['designation'] as String,
      quantite: (json['quantite'] as num).toInt(),
      poidsUnitaireKg: (json['poids_unitaire_kg'] as num).toDouble(),
      volumeUnitaireM3: (json['volume_unitaire_m3'] as num).toDouble(),
      categorie: const CategorieArticleConverter().fromJson(
        json['categorie'] as String,
      ),
      manutentionSpeciale: json['manutention_speciale'] as String?,
    );

Map<String, dynamic> _$$ArticleFretImplToJson(_$ArticleFretImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_demande': instance.idDemande,
      'designation': instance.designation,
      'quantite': instance.quantite,
      'poids_unitaire_kg': instance.poidsUnitaireKg,
      'volume_unitaire_m3': instance.volumeUnitaireM3,
      'categorie': const CategorieArticleConverter().toJson(instance.categorie),
      'manutention_speciale': instance.manutentionSpeciale,
    };
