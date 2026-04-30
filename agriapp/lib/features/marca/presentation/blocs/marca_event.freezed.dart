// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'marca_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$MarcaEvent {
  Marca get marca => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Marca marca, String? id) save,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Marca marca, String? id)? save,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Marca marca, String? id)? save,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Save value) save,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Save value)? save,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Save value)? save,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of MarcaEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarcaEventCopyWith<MarcaEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarcaEventCopyWith<$Res> {
  factory $MarcaEventCopyWith(
    MarcaEvent value,
    $Res Function(MarcaEvent) then,
  ) = _$MarcaEventCopyWithImpl<$Res, MarcaEvent>;
  @useResult
  $Res call({Marca marca, String? id});
}

/// @nodoc
class _$MarcaEventCopyWithImpl<$Res, $Val extends MarcaEvent>
    implements $MarcaEventCopyWith<$Res> {
  _$MarcaEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarcaEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? marca = null, Object? id = freezed}) {
    return _then(
      _value.copyWith(
            marca: null == marca
                ? _value.marca
                : marca // ignore: cast_nullable_to_non_nullable
                      as Marca,
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SaveImplCopyWith<$Res> implements $MarcaEventCopyWith<$Res> {
  factory _$$SaveImplCopyWith(
    _$SaveImpl value,
    $Res Function(_$SaveImpl) then,
  ) = __$$SaveImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Marca marca, String? id});
}

/// @nodoc
class __$$SaveImplCopyWithImpl<$Res>
    extends _$MarcaEventCopyWithImpl<$Res, _$SaveImpl>
    implements _$$SaveImplCopyWith<$Res> {
  __$$SaveImplCopyWithImpl(_$SaveImpl _value, $Res Function(_$SaveImpl) _then)
    : super(_value, _then);

  /// Create a copy of MarcaEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? marca = null, Object? id = freezed}) {
    return _then(
      _$SaveImpl(
        marca: null == marca
            ? _value.marca
            : marca // ignore: cast_nullable_to_non_nullable
                  as Marca,
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$SaveImpl implements _Save {
  const _$SaveImpl({required this.marca, this.id});

  @override
  final Marca marca;
  @override
  final String? id;

  @override
  String toString() {
    return 'MarcaEvent.save(marca: $marca, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaveImpl &&
            (identical(other.marca, marca) || other.marca == marca) &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, marca, id);

  /// Create a copy of MarcaEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaveImplCopyWith<_$SaveImpl> get copyWith =>
      __$$SaveImplCopyWithImpl<_$SaveImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Marca marca, String? id) save,
  }) {
    return save(marca, id);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Marca marca, String? id)? save,
  }) {
    return save?.call(marca, id);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Marca marca, String? id)? save,
    required TResult orElse(),
  }) {
    if (save != null) {
      return save(marca, id);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Save value) save,
  }) {
    return save(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Save value)? save,
  }) {
    return save?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Save value)? save,
    required TResult orElse(),
  }) {
    if (save != null) {
      return save(this);
    }
    return orElse();
  }
}

abstract class _Save implements MarcaEvent {
  const factory _Save({required final Marca marca, final String? id}) =
      _$SaveImpl;

  @override
  Marca get marca;
  @override
  String? get id;

  /// Create a copy of MarcaEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaveImplCopyWith<_$SaveImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
