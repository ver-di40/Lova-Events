// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'article_fret.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ArticleFret _$ArticleFretFromJson(Map<String, dynamic> json) {
  return _ArticleFret.fromJson(json);
}

/// @nodoc
mixin _$ArticleFret {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'id_demande')
  String get idDemande => throw _privateConstructorUsedError;
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

  /// Serializes this ArticleFret to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ArticleFret
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArticleFretCopyWith<ArticleFret> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArticleFretCopyWith<$Res> {
  factory $ArticleFretCopyWith(
    ArticleFret value,
    $Res Function(ArticleFret) then,
  ) = _$ArticleFretCopyWithImpl<$Res, ArticleFret>;
  @useResult
  $Res call({
    @JsonKey(name: 'id') String id,
    @JsonKey(name: 'id_demande') String idDemande,
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
class _$ArticleFretCopyWithImpl<$Res, $Val extends ArticleFret>
    implements $ArticleFretCopyWith<$Res> {
  _$ArticleFretCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArticleFret
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idDemande = null,
    Object? designation = null,
    Object? quantite = null,
    Object? poidsUnitaireKg = null,
    Object? volumeUnitaireM3 = null,
    Object? categorie = null,
    Object? manutentionSpeciale = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            idDemande: null == idDemande
                ? _value.idDemande
                : idDemande // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$ArticleFretImplCopyWith<$Res>
    implements $ArticleFretCopyWith<$Res> {
  factory _$$ArticleFretImplCopyWith(
    _$ArticleFretImpl value,
    $Res Function(_$ArticleFretImpl) then,
  ) = __$$ArticleFretImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'id') String id,
    @JsonKey(name: 'id_demande') String idDemande,
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
class __$$ArticleFretImplCopyWithImpl<$Res>
    extends _$ArticleFretCopyWithImpl<$Res, _$ArticleFretImpl>
    implements _$$ArticleFretImplCopyWith<$Res> {
  __$$ArticleFretImplCopyWithImpl(
    _$ArticleFretImpl _value,
    $Res Function(_$ArticleFretImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ArticleFret
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idDemande = null,
    Object? designation = null,
    Object? quantite = null,
    Object? poidsUnitaireKg = null,
    Object? volumeUnitaireM3 = null,
    Object? categorie = null,
    Object? manutentionSpeciale = freezed,
  }) {
    return _then(
      _$ArticleFretImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        idDemande: null == idDemande
            ? _value.idDemande
            : idDemande // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$ArticleFretImpl implements _ArticleFret {
  const _$ArticleFretImpl({
    @JsonKey(name: 'id') required this.id,
    @JsonKey(name: 'id_demande') required this.idDemande,
    @JsonKey(name: 'designation') required this.designation,
    @JsonKey(name: 'quantite') required this.quantite,
    @JsonKey(name: 'poids_unitaire_kg') required this.poidsUnitaireKg,
    @JsonKey(name: 'volume_unitaire_m3') required this.volumeUnitaireM3,
    @JsonKey(name: 'categorie')
    @CategorieArticleConverter()
    required this.categorie,
    @JsonKey(name: 'manutention_speciale') this.manutentionSpeciale,
  });

  factory _$ArticleFretImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArticleFretImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'id_demande')
  final String idDemande;
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
    return 'ArticleFret(id: $id, idDemande: $idDemande, designation: $designation, quantite: $quantite, poidsUnitaireKg: $poidsUnitaireKg, volumeUnitaireM3: $volumeUnitaireM3, categorie: $categorie, manutentionSpeciale: $manutentionSpeciale)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArticleFretImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.idDemande, idDemande) ||
                other.idDemande == idDemande) &&
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
    id,
    idDemande,
    designation,
    quantite,
    poidsUnitaireKg,
    volumeUnitaireM3,
    categorie,
    manutentionSpeciale,
  );

  /// Create a copy of ArticleFret
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArticleFretImplCopyWith<_$ArticleFretImpl> get copyWith =>
      __$$ArticleFretImplCopyWithImpl<_$ArticleFretImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArticleFretImplToJson(this);
  }
}

abstract class _ArticleFret implements ArticleFret {
  const factory _ArticleFret({
    @JsonKey(name: 'id') required final String id,
    @JsonKey(name: 'id_demande') required final String idDemande,
    @JsonKey(name: 'designation') required final String designation,
    @JsonKey(name: 'quantite') required final int quantite,
    @JsonKey(name: 'poids_unitaire_kg') required final double poidsUnitaireKg,
    @JsonKey(name: 'volume_unitaire_m3') required final double volumeUnitaireM3,
    @JsonKey(name: 'categorie')
    @CategorieArticleConverter()
    required final CategorieArticle categorie,
    @JsonKey(name: 'manutention_speciale') final String? manutentionSpeciale,
  }) = _$ArticleFretImpl;

  factory _ArticleFret.fromJson(Map<String, dynamic> json) =
      _$ArticleFretImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'id_demande')
  String get idDemande;
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

  /// Create a copy of ArticleFret
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArticleFretImplCopyWith<_$ArticleFretImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
