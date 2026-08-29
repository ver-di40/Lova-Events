// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fret_inputs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DemandeFretInput _$DemandeFretInputFromJson(Map<String, dynamic> json) {
  return _DemandeFretInput.fromJson(json);
}

/// @nodoc
mixin _$DemandeFretInput {
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

  /// Serializes this DemandeFretInput to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DemandeFretInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DemandeFretInputCopyWith<DemandeFretInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DemandeFretInputCopyWith<$Res> {
  factory $DemandeFretInputCopyWith(
    DemandeFretInput value,
    $Res Function(DemandeFretInput) then,
  ) = _$DemandeFretInputCopyWithImpl<$Res, DemandeFretInput>;
  @useResult
  $Res call({
    @JsonKey(name: 'adresse_depart') String adresseDepart,
    @JsonKey(name: 'adresse_arrivee') String adresseArrivee,
    @JsonKey(name: 'date_heure_souhaitee_depart')
    DateTime dateHeureSouhaiteeDepart,
    @JsonKey(name: 'date_heure_retour_prevue') DateTime? dateHeureRetourPrevue,
    @JsonKey(name: 'type_vehicule_requis')
    @TypeVehiculeConverter()
    TypeVehicule typeVehiculeRequis,
    @JsonKey(name: 'fragile') bool fragile,
    @JsonKey(name: 'necessite_frigo') bool necessiteFrigo,
    @JsonKey(name: 'necessite_manutention') bool necessiteManutention,
    @JsonKey(name: 'nb_manutentionnaires_requis') int nbManutentionnairesRequis,
    @JsonKey(name: 'description_complementaire')
    String? descriptionComplementaire,
  });
}

/// @nodoc
class _$DemandeFretInputCopyWithImpl<$Res, $Val extends DemandeFretInput>
    implements $DemandeFretInputCopyWith<$Res> {
  _$DemandeFretInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DemandeFretInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? adresseDepart = null,
    Object? adresseArrivee = null,
    Object? dateHeureSouhaiteeDepart = null,
    Object? dateHeureRetourPrevue = freezed,
    Object? typeVehiculeRequis = null,
    Object? fragile = null,
    Object? necessiteFrigo = null,
    Object? necessiteManutention = null,
    Object? nbManutentionnairesRequis = null,
    Object? descriptionComplementaire = freezed,
  }) {
    return _then(
      _value.copyWith(
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DemandeFretInputImplCopyWith<$Res>
    implements $DemandeFretInputCopyWith<$Res> {
  factory _$$DemandeFretInputImplCopyWith(
    _$DemandeFretInputImpl value,
    $Res Function(_$DemandeFretInputImpl) then,
  ) = __$$DemandeFretInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'adresse_depart') String adresseDepart,
    @JsonKey(name: 'adresse_arrivee') String adresseArrivee,
    @JsonKey(name: 'date_heure_souhaitee_depart')
    DateTime dateHeureSouhaiteeDepart,
    @JsonKey(name: 'date_heure_retour_prevue') DateTime? dateHeureRetourPrevue,
    @JsonKey(name: 'type_vehicule_requis')
    @TypeVehiculeConverter()
    TypeVehicule typeVehiculeRequis,
    @JsonKey(name: 'fragile') bool fragile,
    @JsonKey(name: 'necessite_frigo') bool necessiteFrigo,
    @JsonKey(name: 'necessite_manutention') bool necessiteManutention,
    @JsonKey(name: 'nb_manutentionnaires_requis') int nbManutentionnairesRequis,
    @JsonKey(name: 'description_complementaire')
    String? descriptionComplementaire,
  });
}

/// @nodoc
class __$$DemandeFretInputImplCopyWithImpl<$Res>
    extends _$DemandeFretInputCopyWithImpl<$Res, _$DemandeFretInputImpl>
    implements _$$DemandeFretInputImplCopyWith<$Res> {
  __$$DemandeFretInputImplCopyWithImpl(
    _$DemandeFretInputImpl _value,
    $Res Function(_$DemandeFretInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DemandeFretInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? adresseDepart = null,
    Object? adresseArrivee = null,
    Object? dateHeureSouhaiteeDepart = null,
    Object? dateHeureRetourPrevue = freezed,
    Object? typeVehiculeRequis = null,
    Object? fragile = null,
    Object? necessiteFrigo = null,
    Object? necessiteManutention = null,
    Object? nbManutentionnairesRequis = null,
    Object? descriptionComplementaire = freezed,
  }) {
    return _then(
      _$DemandeFretInputImpl(
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DemandeFretInputImpl implements _DemandeFretInput {
  const _$DemandeFretInputImpl({
    @JsonKey(name: 'adresse_depart') required this.adresseDepart,
    @JsonKey(name: 'adresse_arrivee') required this.adresseArrivee,
    @JsonKey(name: 'date_heure_souhaitee_depart')
    required this.dateHeureSouhaiteeDepart,
    @JsonKey(name: 'date_heure_retour_prevue') this.dateHeureRetourPrevue,
    @JsonKey(name: 'type_vehicule_requis')
    @TypeVehiculeConverter()
    required this.typeVehiculeRequis,
    @JsonKey(name: 'fragile') required this.fragile,
    @JsonKey(name: 'necessite_frigo') required this.necessiteFrigo,
    @JsonKey(name: 'necessite_manutention') required this.necessiteManutention,
    @JsonKey(name: 'nb_manutentionnaires_requis')
    required this.nbManutentionnairesRequis,
    @JsonKey(name: 'description_complementaire') this.descriptionComplementaire,
  });

  factory _$DemandeFretInputImpl.fromJson(Map<String, dynamic> json) =>
      _$$DemandeFretInputImplFromJson(json);

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
  String toString() {
    return 'DemandeFretInput(adresseDepart: $adresseDepart, adresseArrivee: $adresseArrivee, dateHeureSouhaiteeDepart: $dateHeureSouhaiteeDepart, dateHeureRetourPrevue: $dateHeureRetourPrevue, typeVehiculeRequis: $typeVehiculeRequis, fragile: $fragile, necessiteFrigo: $necessiteFrigo, necessiteManutention: $necessiteManutention, nbManutentionnairesRequis: $nbManutentionnairesRequis, descriptionComplementaire: $descriptionComplementaire)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DemandeFretInputImpl &&
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
                other.descriptionComplementaire == descriptionComplementaire));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    adresseDepart,
    adresseArrivee,
    dateHeureSouhaiteeDepart,
    dateHeureRetourPrevue,
    typeVehiculeRequis,
    fragile,
    necessiteFrigo,
    necessiteManutention,
    nbManutentionnairesRequis,
    descriptionComplementaire,
  );

  /// Create a copy of DemandeFretInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DemandeFretInputImplCopyWith<_$DemandeFretInputImpl> get copyWith =>
      __$$DemandeFretInputImplCopyWithImpl<_$DemandeFretInputImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DemandeFretInputImplToJson(this);
  }
}

abstract class _DemandeFretInput implements DemandeFretInput {
  const factory _DemandeFretInput({
    @JsonKey(name: 'adresse_depart') required final String adresseDepart,
    @JsonKey(name: 'adresse_arrivee') required final String adresseArrivee,
    @JsonKey(name: 'date_heure_souhaitee_depart')
    required final DateTime dateHeureSouhaiteeDepart,
    @JsonKey(name: 'date_heure_retour_prevue')
    final DateTime? dateHeureRetourPrevue,
    @JsonKey(name: 'type_vehicule_requis')
    @TypeVehiculeConverter()
    required final TypeVehicule typeVehiculeRequis,
    @JsonKey(name: 'fragile') required final bool fragile,
    @JsonKey(name: 'necessite_frigo') required final bool necessiteFrigo,
    @JsonKey(name: 'necessite_manutention')
    required final bool necessiteManutention,
    @JsonKey(name: 'nb_manutentionnaires_requis')
    required final int nbManutentionnairesRequis,
    @JsonKey(name: 'description_complementaire')
    final String? descriptionComplementaire,
  }) = _$DemandeFretInputImpl;

  factory _DemandeFretInput.fromJson(Map<String, dynamic> json) =
      _$DemandeFretInputImpl.fromJson;

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

  /// Create a copy of DemandeFretInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DemandeFretInputImplCopyWith<_$DemandeFretInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ArticleFretInput _$ArticleFretInputFromJson(Map<String, dynamic> json) {
  return _ArticleFretInput.fromJson(json);
}

/// @nodoc
mixin _$ArticleFretInput {
  @JsonKey(name: 'designation')
  String get designation => throw _privateConstructorUsedError;
  @JsonKey(name: 'quantite')
  int get quantite => throw _privateConstructorUsedError;
  @JsonKey(name: 'poids_unitaire_kg')
  double get poidsUnitaireKg => throw _privateConstructorUsedError;
  @JsonKey(name: 'volume_unitaire_m3')
  double get volumeUnitaireM3 => throw _privateConstructorUsedError;
  @JsonKey(name: 'categorie')
  @CategorieArticleConverter()
  CategorieArticle get categorie => throw _privateConstructorUsedError;
  @JsonKey(name: 'manutention_speciale')
  String? get manutentionSpeciale => throw _privateConstructorUsedError;

  /// Serializes this ArticleFretInput to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ArticleFretInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArticleFretInputCopyWith<ArticleFretInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArticleFretInputCopyWith<$Res> {
  factory $ArticleFretInputCopyWith(
    ArticleFretInput value,
    $Res Function(ArticleFretInput) then,
  ) = _$ArticleFretInputCopyWithImpl<$Res, ArticleFretInput>;
  @useResult
  $Res call({
    @JsonKey(name: 'designation') String designation,
    @JsonKey(name: 'quantite') int quantite,
    @JsonKey(name: 'poids_unitaire_kg') double poidsUnitaireKg,
    @JsonKey(name: 'volume_unitaire_m3') double volumeUnitaireM3,
    @JsonKey(name: 'categorie')
    @CategorieArticleConverter()
    CategorieArticle categorie,
    @JsonKey(name: 'manutention_speciale') String? manutentionSpeciale,
  });
}

/// @nodoc
class _$ArticleFretInputCopyWithImpl<$Res, $Val extends ArticleFretInput>
    implements $ArticleFretInputCopyWith<$Res> {
  _$ArticleFretInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArticleFretInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? designation = null,
    Object? quantite = null,
    Object? poidsUnitaireKg = null,
    Object? volumeUnitaireM3 = null,
    Object? categorie = null,
    Object? manutentionSpeciale = freezed,
  }) {
    return _then(
      _value.copyWith(
            designation: null == designation
                ? _value.designation
                : designation // ignore: cast_nullable_to_non_nullable
                      as String,
            quantite: null == quantite
                ? _value.quantite
                : quantite // ignore: cast_nullable_to_non_nullable
                      as int,
            poidsUnitaireKg: null == poidsUnitaireKg
                ? _value.poidsUnitaireKg
                : poidsUnitaireKg // ignore: cast_nullable_to_non_nullable
                      as double,
            volumeUnitaireM3: null == volumeUnitaireM3
                ? _value.volumeUnitaireM3
                : volumeUnitaireM3 // ignore: cast_nullable_to_non_nullable
                      as double,
            categorie: null == categorie
                ? _value.categorie
                : categorie // ignore: cast_nullable_to_non_nullable
                      as CategorieArticle,
            manutentionSpeciale: freezed == manutentionSpeciale
                ? _value.manutentionSpeciale
                : manutentionSpeciale // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ArticleFretInputImplCopyWith<$Res>
    implements $ArticleFretInputCopyWith<$Res> {
  factory _$$ArticleFretInputImplCopyWith(
    _$ArticleFretInputImpl value,
    $Res Function(_$ArticleFretInputImpl) then,
  ) = __$$ArticleFretInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'designation') String designation,
    @JsonKey(name: 'quantite') int quantite,
    @JsonKey(name: 'poids_unitaire_kg') double poidsUnitaireKg,
    @JsonKey(name: 'volume_unitaire_m3') double volumeUnitaireM3,
    @JsonKey(name: 'categorie')
    @CategorieArticleConverter()
    CategorieArticle categorie,
    @JsonKey(name: 'manutention_speciale') String? manutentionSpeciale,
  });
}

/// @nodoc
class __$$ArticleFretInputImplCopyWithImpl<$Res>
    extends _$ArticleFretInputCopyWithImpl<$Res, _$ArticleFretInputImpl>
    implements _$$ArticleFretInputImplCopyWith<$Res> {
  __$$ArticleFretInputImplCopyWithImpl(
    _$ArticleFretInputImpl _value,
    $Res Function(_$ArticleFretInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ArticleFretInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? designation = null,
    Object? quantite = null,
    Object? poidsUnitaireKg = null,
    Object? volumeUnitaireM3 = null,
    Object? categorie = null,
    Object? manutentionSpeciale = freezed,
  }) {
    return _then(
      _$ArticleFretInputImpl(
        designation: null == designation
            ? _value.designation
            : designation // ignore: cast_nullable_to_non_nullable
                  as String,
        quantite: null == quantite
            ? _value.quantite
            : quantite // ignore: cast_nullable_to_non_nullable
                  as int,
        poidsUnitaireKg: null == poidsUnitaireKg
            ? _value.poidsUnitaireKg
            : poidsUnitaireKg // ignore: cast_nullable_to_non_nullable
                  as double,
        volumeUnitaireM3: null == volumeUnitaireM3
            ? _value.volumeUnitaireM3
            : volumeUnitaireM3 // ignore: cast_nullable_to_non_nullable
                  as double,
        categorie: null == categorie
            ? _value.categorie
            : categorie // ignore: cast_nullable_to_non_nullable
                  as CategorieArticle,
        manutentionSpeciale: freezed == manutentionSpeciale
            ? _value.manutentionSpeciale
            : manutentionSpeciale // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ArticleFretInputImpl implements _ArticleFretInput {
  const _$ArticleFretInputImpl({
    @JsonKey(name: 'designation') required this.designation,
    @JsonKey(name: 'quantite') required this.quantite,
    @JsonKey(name: 'poids_unitaire_kg') required this.poidsUnitaireKg,
    @JsonKey(name: 'volume_unitaire_m3') required this.volumeUnitaireM3,
    @JsonKey(name: 'categorie')
    @CategorieArticleConverter()
    required this.categorie,
    @JsonKey(name: 'manutention_speciale') this.manutentionSpeciale,
  });

  factory _$ArticleFretInputImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArticleFretInputImplFromJson(json);

  @override
  @JsonKey(name: 'designation')
  final String designation;
  @override
  @JsonKey(name: 'quantite')
  final int quantite;
  @override
  @JsonKey(name: 'poids_unitaire_kg')
  final double poidsUnitaireKg;
  @override
  @JsonKey(name: 'volume_unitaire_m3')
  final double volumeUnitaireM3;
  @override
  @JsonKey(name: 'categorie')
  @CategorieArticleConverter()
  final CategorieArticle categorie;
  @override
  @JsonKey(name: 'manutention_speciale')
  final String? manutentionSpeciale;

  @override
  String toString() {
    return 'ArticleFretInput(designation: $designation, quantite: $quantite, poidsUnitaireKg: $poidsUnitaireKg, volumeUnitaireM3: $volumeUnitaireM3, categorie: $categorie, manutentionSpeciale: $manutentionSpeciale)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArticleFretInputImpl &&
            (identical(other.designation, designation) ||
                other.designation == designation) &&
            (identical(other.quantite, quantite) ||
                other.quantite == quantite) &&
            (identical(other.poidsUnitaireKg, poidsUnitaireKg) ||
                other.poidsUnitaireKg == poidsUnitaireKg) &&
            (identical(other.volumeUnitaireM3, volumeUnitaireM3) ||
                other.volumeUnitaireM3 == volumeUnitaireM3) &&
            (identical(other.categorie, categorie) ||
                other.categorie == categorie) &&
            (identical(other.manutentionSpeciale, manutentionSpeciale) ||
                other.manutentionSpeciale == manutentionSpeciale));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    designation,
    quantite,
    poidsUnitaireKg,
    volumeUnitaireM3,
    categorie,
    manutentionSpeciale,
  );

  /// Create a copy of ArticleFretInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArticleFretInputImplCopyWith<_$ArticleFretInputImpl> get copyWith =>
      __$$ArticleFretInputImplCopyWithImpl<_$ArticleFretInputImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ArticleFretInputImplToJson(this);
  }
}

abstract class _ArticleFretInput implements ArticleFretInput {
  const factory _ArticleFretInput({
    @JsonKey(name: 'designation') required final String designation,
    @JsonKey(name: 'quantite') required final int quantite,
    @JsonKey(name: 'poids_unitaire_kg') required final double poidsUnitaireKg,
    @JsonKey(name: 'volume_unitaire_m3') required final double volumeUnitaireM3,
    @JsonKey(name: 'categorie')
    @CategorieArticleConverter()
    required final CategorieArticle categorie,
    @JsonKey(name: 'manutention_speciale') final String? manutentionSpeciale,
  }) = _$ArticleFretInputImpl;

  factory _ArticleFretInput.fromJson(Map<String, dynamic> json) =
      _$ArticleFretInputImpl.fromJson;

  @override
  @JsonKey(name: 'designation')
  String get designation;
  @override
  @JsonKey(name: 'quantite')
  int get quantite;
  @override
  @JsonKey(name: 'poids_unitaire_kg')
  double get poidsUnitaireKg;
  @override
  @JsonKey(name: 'volume_unitaire_m3')
  double get volumeUnitaireM3;
  @override
  @JsonKey(name: 'categorie')
  @CategorieArticleConverter()
  CategorieArticle get categorie;
  @override
  @JsonKey(name: 'manutention_speciale')
  String? get manutentionSpeciale;

  /// Create a copy of ArticleFretInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArticleFretInputImplCopyWith<_$ArticleFretInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
