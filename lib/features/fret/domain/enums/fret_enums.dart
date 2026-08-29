// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

enum StatutDemande {
  brouillon('brouillon'),
  publiee('publiee'),
  matchee('matchee'),
  annulee('annulee'),
  terminee('terminee');

  const StatutDemande(this.value);

  final String value;

  bool get estNonModifiable =>
      this == StatutDemande.publiee ||
      this == StatutDemande.matchee ||
      this == StatutDemande.terminee;
}

enum TypeVehicule {
  fourgon('fourgon'),
  camionPlateau('camion_plateau'),
  camionFrigo('camion_frigo'),
  camionBenne('camion_benne'),
  indifferent('indifferent');

  const TypeVehicule(this.value);

  final String value;
}

enum CategorieArticle {
  mobilier('mobilier'),
  sonoreEtEclairage('sonorisation_eclairage'),
  decoration('decoration'),
  materielTraiteur('materiel_traiteur'),
  structureTente('structure_tente'),
  autre('autre');

  const CategorieArticle(this.value);

  final String value;
}

enum FretErrorCode {
  SUPABASE_ERROR('SUPABASE_ERROR'),
  DEMANDE_NON_MODIFIABLE('DEMANDE_NON_MODIFIABLE'),
  KYC_INVALIDE('KYC_INVALIDE'),
  ARTICLE_MANQUANT('ARTICLE_MANQUANT'),
  FRIGO_VEHICULE_REQUIS('FRIGO_VEHICULE_REQUIS');

  const FretErrorCode(this.value);

  final String value;
}

class StatutDemandeConverter implements JsonConverter<StatutDemande, String> {
  const StatutDemandeConverter();

  @override
  StatutDemande fromJson(String json) => StatutDemande.values.firstWhere(
        (value) => value.value == json,
        orElse: () => throw FormatException('Unknown StatutDemande: $json'),
      );

  @override
  String toJson(StatutDemande object) => object.value;
}

class TypeVehiculeConverter implements JsonConverter<TypeVehicule, String> {
  const TypeVehiculeConverter();

  @override
  TypeVehicule fromJson(String json) => TypeVehicule.values.firstWhere(
        (value) => value.value == json,
        orElse: () => throw FormatException('Unknown TypeVehicule: $json'),
      );

  @override
  String toJson(TypeVehicule object) => object.value;
}

class CategorieArticleConverter implements JsonConverter<CategorieArticle, String> {
  const CategorieArticleConverter();

  @override
  CategorieArticle fromJson(String json) => CategorieArticle.values.firstWhere(
        (value) => value.value == json,
        orElse: () => throw FormatException('Unknown CategorieArticle: $json'),
      );

  @override
  String toJson(CategorieArticle object) => object.value;
}

class FretErrorCodeConverter implements JsonConverter<FretErrorCode, String> {
  const FretErrorCodeConverter();

  @override
  FretErrorCode fromJson(String json) => FretErrorCode.values.firstWhere(
        (value) => value.value == json,
        orElse: () => throw FormatException('Unknown FretErrorCode: $json'),
      );

  @override
  String toJson(FretErrorCode object) => object.value;
}
