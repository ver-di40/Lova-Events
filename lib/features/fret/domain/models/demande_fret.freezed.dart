// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'demande_fret.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DemandeFret _$DemandeFretFromJson(Map<String, dynamic> json) {
  return _DemandeFret.fromJson(json);
}

/// @nodoc
mixin _$DemandeFret {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'id_prestataire')
  String get idPrestataire => throw _privateConstructorUsedError;
  @JsonKey(name: 'adresse_depart')
  String get adresseDepart => throw _privateConstructorUsedError;
  @JsonKey(name: 'adresse_arrivee')
  String get adresseArrivee => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_heure_souhaitee_depart')
  DateTime get dateHeureSouhaiteeDepart => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_heure_retour_prevue')
  DateTime? get dateHeureRetourPrevue => throw _privateConstructorUsedError;
  @JsonKey(name: 'type_vehicule_requis')
  @TypeVehiculeConverter()
  TypeVehicule get typeVehiculeRequis => throw _privateConstructorUsedError;
  @JsonKey(name: 'poids_total_estime_kg')
  double get poidsTotalEstimeKg => throw _privateConstructorUsedError;
  @JsonKey(name: 'volume_total_estime_m3')
  double get volumeTotalEstimeM3 => throw _privateConstructorUsedError;
  @JsonKey(name: 'fragile')
  bool get fragile => throw _privateConstructorUsedError;
  @JsonKey(name: 'necessite_frigo')
  bool get necessiteFrigo => throw _privateConstructorUsedError;
  @JsonKey(name: 'necessite_manutention')
  bool get necessiteManutention => throw _privateConstructorUsedError;
  @JsonKey(name: 'nb_manutentionnaires_requis')
  int get nbManutentionnairesRequis => throw _privateConstructorUsedError;
  @JsonKey(name: 'description_complementaire')
  String? get descriptionComplementaire => throw _privateConstructorUsedError;
  @JsonKey(name: 'statut')
  @StatutDemandeConverter()
  StatutDemande get statut => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_creation')
  DateTime get dateCreation => throw _privateConstructorUsedError;

  /// Serializes this DemandeFret to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DemandeFret
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DemandeFretCopyWith<DemandeFret> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DemandeFretCopyWith<$Res> {
  factory $DemandeFretCopyWith(
    DemandeFret value,
    $Res Function(DemandeFret) then,
  ) = _$DemandeFretCopyWithImpl<$Res, DemandeFret>;
  @useResult
  $Res call({
    @JsonKey(name: 'id') String id,
    @JsonKey(name: 'id_prestataire') String idPrestataire,
    @JsonKey(name: 'adresse_depart') String adresseDepart,
    @JsonKey(name: 'adresse_arrivee') String adresseArrivee,
    @JsonKey(name: 'date_heure_souhaitee_depart')
    DateTime dateHeureSouhaiteeDepart,
    @JsonKey(name: 'date_heure_retour_prevue') DateTime? dateHeureRetourPrevue,
    @JsonKey(name: 'type_vehicule_requis')
    @TypeVehiculeConverter()
    TypeVehicule typeVehiculeRequis,
    @JsonKey(name: 'poids_total_estime_kg') double poidsTotalEstimeKg,
    @JsonKey(name: 'volume_total_estime_m3') double volumeTotalEstimeM3,
    @JsonKey(name: 'fragile') bool fragile,
    @JsonKey(name: 'necessite_frigo') bool necessiteFrigo,
    @JsonKey(name: 'necessite_manutention') bool necessiteManutention,
    @JsonKey(name: 'nb_manutentionnaires_requis') int nbManutentionnairesRequis,
    @JsonKey(name: 'description_complementaire')
    String? descriptionComplementaire,
    @JsonKey(name: 'statut') @StatutDemandeConverter() StatutDemande statut,
    @JsonKey(name: 'date_creation') DateTime dateCreation,
  });
}

/// @nodoc
class _$DemandeFretCopyWithImpl<$Res, $Val extends DemandeFret>
    implements $DemandeFretCopyWith<$Res> {
  _$DemandeFretCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DemandeFret
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idPrestataire = null,
    Object? adresseDepart = null,
    Object? adresseArrivee = null,
    Object? dateHeureSouhaiteeDepart = null,
    Object? dateHeureRetourPrevue = freezed,
    Object? typeVehiculeRequis = null,
    Object? poidsTotalEstimeKg = null,
    Object? volumeTotalEstimeM3 = null,
    Object? fragile = null,
    Object? necessiteFrigo = null,
    Object? necessiteManutention = null,
    Object? nbManutentionnairesRequis = null,
    Object? descriptionComplementaire = freezed,
    Object? statut = null,
    Object? dateCreation = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            idPrestataire: null == idPrestataire
                ? _value.idPrestataire
                : idPrestataire // ignore: cast_nullable_to_non_nullable
                      as String,
            adresseDepart: null == adresseDepart
                ? _value.adresseDepart
                : adresseDepart // ignore: cast_nullable_to_non_nullable
                      as String,
            adresseArrivee: null == adresseArrivee
                ? _value.adresseArrivee
                : adresseArrivee // ignore: cast_nullable_to_non_nullable
                      as String,
            dateHeureSouhaiteeDepart: null == dateHeureSouhaiteeDepart
                ? _value.dateHeureSouhaiteeDepart
                : dateHeureSouhaiteeDepart // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            dateHeureRetourPrevue: freezed == dateHeureRetourPrevue
                ? _value.dateHeureRetourPrevue
                : dateHeureRetourPrevue // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            typeVehiculeRequis: null == typeVehiculeRequis
                ? _value.typeVehiculeRequis
                : typeVehiculeRequis // ignore: cast_nullable_to_non_nullable
                      as TypeVehicule,
            poidsTotalEstimeKg: null == poidsTotalEstimeKg
                ? _value.poidsTotalEstimeKg
                : poidsTotalEstimeKg // ignore: cast_nullable_to_non_nullable
                      as double,
            volumeTotalEstimeM3: null == volumeTotalEstimeM3
                ? _value.volumeTotalEstimeM3
                : volumeTotalEstimeM3 // ignore: cast_nullable_to_non_nullable
                      as double,
            fragile: null == fragile
                ? _value.fragile
                : fragile // ignore: cast_nullable_to_non_nullable
                      as bool,
            necessiteFrigo: null == necessiteFrigo
                ? _value.necessiteFrigo
                : necessiteFrigo // ignore: cast_nullable_to_non_nullable
                      as bool,
            necessiteManutention: null == necessiteManutention
                ? _value.necessiteManutention
                : necessiteManutention // ignore: cast_nullable_to_non_nullable
                      as bool,
            nbManutentionnairesRequis: null == nbManutentionnairesRequis
                ? _value.nbManutentionnairesRequis
                : nbManutentionnairesRequis // ignore: cast_nullable_to_non_nullable
                      as int,
            descriptionComplementaire: freezed == descriptionComplementaire
                ? _value.descriptionComplementaire
                : descriptionComplementaire // ignore: cast_nullable_to_non_nullable
                      as String?,
            statut: null == statut
                ? _value.statut
                : statut // ignore: cast_nullable_to_non_nullable
                      as StatutDemande,
            dateCreation: null == dateCreation
                ? _value.dateCreation
                : dateCreation // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DemandeFretImplCopyWith<$Res>
    implements $DemandeFretCopyWith<$Res> {
  factory _$$DemandeFretImplCopyWith(
    _$DemandeFretImpl value,
    $Res Function(_$DemandeFretImpl) then,
  ) = __$$DemandeFretImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'id') String id,
    @JsonKey(name: 'id_prestataire') String idPrestataire,
    @JsonKey(name: 'adresse_depart') String adresseDepart,
    @JsonKey(name: 'adresse_arrivee') String adresseArrivee,
    @JsonKey(name: 'date_heure_souhaitee_depart')
    DateTime dateHeureSouhaiteeDepart,
    @JsonKey(name: 'date_heure_retour_prevue') DateTime? dateHeureRetourPrevue,
    @JsonKey(name: 'type_vehicule_requis')
    @TypeVehiculeConverter()
    TypeVehicule typeVehiculeRequis,
    @JsonKey(name: 'poids_total_estime_kg') double poidsTotalEstimeKg,
    @JsonKey(name: 'volume_total_estime_m3') double volumeTotalEstimeM3,
    @JsonKey(name: 'fragile') bool fragile,
    @JsonKey(name: 'necessite_frigo') bool necessiteFrigo,
    @JsonKey(name: 'necessite_manutention') bool necessiteManutention,
    @JsonKey(name: 'nb_manutentionnaires_requis') int nbManutentionnairesRequis,
    @JsonKey(name: 'description_complementaire')
    String? descriptionComplementaire,
    @JsonKey(name: 'statut') @StatutDemandeConverter() StatutDemande statut,
    @JsonKey(name: 'date_creation') DateTime dateCreation,
  });
}

/// @nodoc
class __$$DemandeFretImplCopyWithImpl<$Res>
    extends _$DemandeFretCopyWithImpl<$Res, _$DemandeFretImpl>
    implements _$$DemandeFretImplCopyWith<$Res> {
  __$$DemandeFretImplCopyWithImpl(
    _$DemandeFretImpl _value,
    $Res Function(_$DemandeFretImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DemandeFret
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idPrestataire = null,
    Object? adresseDepart = null,
    Object? adresseArrivee = null,
    Object? dateHeureSouhaiteeDepart = null,
    Object? dateHeureRetourPrevue = freezed,
    Object? typeVehiculeRequis = null,
    Object? poidsTotalEstimeKg = null,
    Object? volumeTotalEstimeM3 = null,
    Object? fragile = null,
    Object? necessiteFrigo = null,
    Object? necessiteManutention = null,
    Object? nbManutentionnairesRequis = null,
    Object? descriptionComplementaire = freezed,
    Object? statut = null,
    Object? dateCreation = null,
  }) {
    return _then(
      _$DemandeFretImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        idPrestataire: null == idPrestataire
            ? _value.idPrestataire
            : idPrestataire // ignore: cast_nullable_to_non_nullable
                  as String,
        adresseDepart: null == adresseDepart
            ? _value.adresseDepart
            : adresseDepart // ignore: cast_nullable_to_non_nullable
                  as String,
        adresseArrivee: null == adresseArrivee
            ? _value.adresseArrivee
            : adresseArrivee // ignore: cast_nullable_to_non_nullable
                  as String,
        dateHeureSouhaiteeDepart: null == dateHeureSouhaiteeDepart
            ? _value.dateHeureSouhaiteeDepart
            : dateHeureSouhaiteeDepart // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        dateHeureRetourPrevue: freezed == dateHeureRetourPrevue
            ? _value.dateHeureRetourPrevue
            : dateHeureRetourPrevue // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        typeVehiculeRequis: null == typeVehiculeRequis
            ? _value.typeVehiculeRequis
            : typeVehiculeRequis // ignore: cast_nullable_to_non_nullable
                  as TypeVehicule,
        poidsTotalEstimeKg: null == poidsTotalEstimeKg
            ? _value.poidsTotalEstimeKg
            : poidsTotalEstimeKg // ignore: cast_nullable_to_non_nullable
                  as double,
        volumeTotalEstimeM3: null == volumeTotalEstimeM3
            ? _value.volumeTotalEstimeM3
            : volumeTotalEstimeM3 // ignore: cast_nullable_to_non_nullable
                  as double,
        fragile: null == fragile
            ? _value.fragile
            : fragile // ignore: cast_nullable_to_non_nullable
                  as bool,
        necessiteFrigo: null == necessiteFrigo
            ? _value.necessiteFrigo
            : necessiteFrigo // ignore: cast_nullable_to_non_nullable
                  as bool,
        necessiteManutention: null == necessiteManutention
            ? _value.necessiteManutention
            : necessiteManutention // ignore: cast_nullable_to_non_nullable
                  as bool,
        nbManutentionnairesRequis: null == nbManutentionnairesRequis
            ? _value.nbManutentionnairesRequis
            : nbManutentionnairesRequis // ignore: cast_nullable_to_non_nullable
                  as int,
        descriptionComplementaire: freezed == descriptionComplementaire
            ? _value.descriptionComplementaire
            : descriptionComplementaire // ignore: cast_nullable_to_non_nullable
                  as String?,
        statut: null == statut
            ? _value.statut
            : statut // ignore: cast_nullable_to_non_nullable
                  as StatutDemande,
        dateCreation: null == dateCreation
            ? _value.dateCreation
            : dateCreation // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DemandeFretImpl implements _DemandeFret {
  const _$DemandeFretImpl({
    @JsonKey(name: 'id') required this.id,
    @JsonKey(name: 'id_prestataire') required this.idPrestataire,
    @JsonKey(name: 'adresse_depart') required this.adresseDepart,
    @JsonKey(name: 'adresse_arrivee') required this.adresseArrivee,
    @JsonKey(name: 'date_heure_souhaitee_depart')
    required this.dateHeureSouhaiteeDepart,
    @JsonKey(name: 'date_heure_retour_prevue') this.dateHeureRetourPrevue,
    @JsonKey(name: 'type_vehicule_requis')
    @TypeVehiculeConverter()
    required this.typeVehiculeRequis,
    @JsonKey(name: 'poids_total_estime_kg') required this.poidsTotalEstimeKg,
    @JsonKey(name: 'volume_total_estime_m3') required this.volumeTotalEstimeM3,
    @JsonKey(name: 'fragile') required this.fragile,
    @JsonKey(name: 'necessite_frigo') required this.necessiteFrigo,
    @JsonKey(name: 'necessite_manutention') required this.necessiteManutention,
    @JsonKey(name: 'nb_manutentionnaires_requis')
    required this.nbManutentionnairesRequis,
    @JsonKey(name: 'description_complementaire') this.descriptionComplementaire,
    @JsonKey(name: 'statut') @StatutDemandeConverter() required this.statut,
    @JsonKey(name: 'date_creation') required this.dateCreation,
  });

  factory _$DemandeFretImpl.fromJson(Map<String, dynamic> json) =>
      _$$DemandeFretImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'id_prestataire')
  final String idPrestataire;
  @override
  @JsonKey(name: 'adresse_depart')
  final String adresseDepart;
  @override
  @JsonKey(name: 'adresse_arrivee')
  final String adresseArrivee;
  @override
  @JsonKey(name: 'date_heure_souhaitee_depart')
  final DateTime dateHeureSouhaiteeDepart;
  @override
  @JsonKey(name: 'date_heure_retour_prevue')
  final DateTime? dateHeureRetourPrevue;
  @override
  @JsonKey(name: 'type_vehicule_requis')
  @TypeVehiculeConverter()
  final TypeVehicule typeVehiculeRequis;
  @override
  @JsonKey(name: 'poids_total_estime_kg')
  final double poidsTotalEstimeKg;
  @override
  @JsonKey(name: 'volume_total_estime_m3')
  final double volumeTotalEstimeM3;
  @override
  @JsonKey(name: 'fragile')
  final bool fragile;
  @override
  @JsonKey(name: 'necessite_frigo')
  final bool necessiteFrigo;
  @override
  @JsonKey(name: 'necessite_manutention')
  final bool necessiteManutention;
  @override
  @JsonKey(name: 'nb_manutentionnaires_requis')
  final int nbManutentionnairesRequis;
  @override
  @JsonKey(name: 'description_complementaire')
  final String? descriptionComplementaire;
  @override
  @JsonKey(name: 'statut')
  @StatutDemandeConverter()
  final StatutDemande statut;
  @override
  @JsonKey(name: 'date_creation')
  final DateTime dateCreation;

  @override
  String toString() {
    return 'DemandeFret(id: $id, idPrestataire: $idPrestataire, adresseDepart: $adresseDepart, adresseArrivee: $adresseArrivee, dateHeureSouhaiteeDepart: $dateHeureSouhaiteeDepart, dateHeureRetourPrevue: $dateHeureRetourPrevue, typeVehiculeRequis: $typeVehiculeRequis, poidsTotalEstimeKg: $poidsTotalEstimeKg, volumeTotalEstimeM3: $volumeTotalEstimeM3, fragile: $fragile, necessiteFrigo: $necessiteFrigo, necessiteManutention: $necessiteManutention, nbManutentionnairesRequis: $nbManutentionnairesRequis, descriptionComplementaire: $descriptionComplementaire, statut: $statut, dateCreation: $dateCreation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DemandeFretImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.idPrestataire, idPrestataire) ||
                other.idPrestataire == idPrestataire) &&
            (identical(other.adresseDepart, adresseDepart) ||
                other.adresseDepart == adresseDepart) &&
            (identical(other.adresseArrivee, adresseArrivee) ||
                other.adresseArrivee == adresseArrivee) &&
            (identical(
                  other.dateHeureSouhaiteeDepart,
                  dateHeureSouhaiteeDepart,
                ) ||
                other.dateHeureSouhaiteeDepart == dateHeureSouhaiteeDepart) &&
            (identical(other.dateHeureRetourPrevue, dateHeureRetourPrevue) ||
                other.dateHeureRetourPrevue == dateHeureRetourPrevue) &&
            (identical(other.typeVehiculeRequis, typeVehiculeRequis) ||
                other.typeVehiculeRequis == typeVehiculeRequis) &&
            (identical(other.poidsTotalEstimeKg, poidsTotalEstimeKg) ||
                other.poidsTotalEstimeKg == poidsTotalEstimeKg) &&
            (identical(other.volumeTotalEstimeM3, volumeTotalEstimeM3) ||
                other.volumeTotalEstimeM3 == volumeTotalEstimeM3) &&
            (identical(other.fragile, fragile) || other.fragile == fragile) &&
            (identical(other.necessiteFrigo, necessiteFrigo) ||
                other.necessiteFrigo == necessiteFrigo) &&
            (identical(other.necessiteManutention, necessiteManutention) ||
                other.necessiteManutention == necessiteManutention) &&
            (identical(
                  other.nbManutentionnairesRequis,
                  nbManutentionnairesRequis,
                ) ||
                other.nbManutentionnairesRequis == nbManutentionnairesRequis) &&
            (identical(
                  other.descriptionComplementaire,
                  descriptionComplementaire,
                ) ||
                other.descriptionComplementaire == descriptionComplementaire) &&
            (identical(other.statut, statut) || other.statut == statut) &&
            (identical(other.dateCreation, dateCreation) ||
                other.dateCreation == dateCreation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    idPrestataire,
    adresseDepart,
    adresseArrivee,
    dateHeureSouhaiteeDepart,
    dateHeureRetourPrevue,
    typeVehiculeRequis,
    poidsTotalEstimeKg,
    volumeTotalEstimeM3,
    fragile,
    necessiteFrigo,
    necessiteManutention,
    nbManutentionnairesRequis,
    descriptionComplementaire,
    statut,
    dateCreation,
  );

  /// Create a copy of DemandeFret
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DemandeFretImplCopyWith<_$DemandeFretImpl> get copyWith =>
      __$$DemandeFretImplCopyWithImpl<_$DemandeFretImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DemandeFretImplToJson(this);
  }
}

abstract class _DemandeFret implements DemandeFret {
  const factory _DemandeFret({
    @JsonKey(name: 'id') required final String id,
    @JsonKey(name: 'id_prestataire') required final String idPrestataire,
    @JsonKey(name: 'adresse_depart') required final String adresseDepart,
    @JsonKey(name: 'adresse_arrivee') required final String adresseArrivee,
    @JsonKey(name: 'date_heure_souhaitee_depart')
    required final DateTime dateHeureSouhaiteeDepart,
    @JsonKey(name: 'date_heure_retour_prevue')
    final DateTime? dateHeureRetourPrevue,
    @JsonKey(name: 'type_vehicule_requis')
    @TypeVehiculeConverter()
    required final TypeVehicule typeVehiculeRequis,
    @JsonKey(name: 'poids_total_estime_kg')
    required final double poidsTotalEstimeKg,
    @JsonKey(name: 'volume_total_estime_m3')
    required final double volumeTotalEstimeM3,
    @JsonKey(name: 'fragile') required final bool fragile,
    @JsonKey(name: 'necessite_frigo') required final bool necessiteFrigo,
    @JsonKey(name: 'necessite_manutention')
    required final bool necessiteManutention,
    @JsonKey(name: 'nb_manutentionnaires_requis')
    required final int nbManutentionnairesRequis,
    @JsonKey(name: 'description_complementaire')
    final String? descriptionComplementaire,
    @JsonKey(name: 'statut')
    @StatutDemandeConverter()
    required final StatutDemande statut,
    @JsonKey(name: 'date_creation') required final DateTime dateCreation,
  }) = _$DemandeFretImpl;

  factory _DemandeFret.fromJson(Map<String, dynamic> json) =
      _$DemandeFretImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'id_prestataire')
  String get idPrestataire;
  @override
  @JsonKey(name: 'adresse_depart')
  String get adresseDepart;
  @override
  @JsonKey(name: 'adresse_arrivee')
  String get adresseArrivee;
  @override
  @JsonKey(name: 'date_heure_souhaitee_depart')
  DateTime get dateHeureSouhaiteeDepart;
  @override
  @JsonKey(name: 'date_heure_retour_prevue')
  DateTime? get dateHeureRetourPrevue;
  @override
  @JsonKey(name: 'type_vehicule_requis')
  @TypeVehiculeConverter()
  TypeVehicule get typeVehiculeRequis;
  @override
  @JsonKey(name: 'poids_total_estime_kg')
  double get poidsTotalEstimeKg;
  @override
  @JsonKey(name: 'volume_total_estime_m3')
  double get volumeTotalEstimeM3;
  @override
  @JsonKey(name: 'fragile')
  bool get fragile;
  @override
  @JsonKey(name: 'necessite_frigo')
  bool get necessiteFrigo;
  @override
  @JsonKey(name: 'necessite_manutention')
  bool get necessiteManutention;
  @override
  @JsonKey(name: 'nb_manutentionnaires_requis')
  int get nbManutentionnairesRequis;
  @override
  @JsonKey(name: 'description_complementaire')
  String? get descriptionComplementaire;
  @override
  @JsonKey(name: 'statut')
  @StatutDemandeConverter()
  StatutDemande get statut;
  @override
  @JsonKey(name: 'date_creation')
  DateTime get dateCreation;

  /// Create a copy of DemandeFret
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DemandeFretImplCopyWith<_$DemandeFretImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
