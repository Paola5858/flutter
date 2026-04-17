// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'veiculo_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$VeiculoEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() fetchVeiculos,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchVeiculos,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchVeiculos,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchVeiculos value) fetchVeiculos,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchVeiculos value)? fetchVeiculos,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchVeiculos value)? fetchVeiculos,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VeiculoEventCopyWith<$Res> {
  factory $VeiculoEventCopyWith(
    VeiculoEvent value,
    $Res Function(VeiculoEvent) then,
  ) = _$VeiculoEventCopyWithImpl<$Res, VeiculoEvent>;
}

/// @nodoc
class _$VeiculoEventCopyWithImpl<$Res, $Val extends VeiculoEvent>
    implements $VeiculoEventCopyWith<$Res> {
  _$VeiculoEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VeiculoEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$FetchVeiculosImplCopyWith<$Res> {
  factory _$$FetchVeiculosImplCopyWith(
    _$FetchVeiculosImpl value,
    $Res Function(_$FetchVeiculosImpl) then,
  ) = __$$FetchVeiculosImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FetchVeiculosImplCopyWithImpl<$Res>
    extends _$VeiculoEventCopyWithImpl<$Res, _$FetchVeiculosImpl>
    implements _$$FetchVeiculosImplCopyWith<$Res> {
  __$$FetchVeiculosImplCopyWithImpl(
    _$FetchVeiculosImpl _value,
    $Res Function(_$FetchVeiculosImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VeiculoEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FetchVeiculosImpl implements FetchVeiculos {
  const _$FetchVeiculosImpl();

  @override
  String toString() {
    return 'VeiculoEvent.fetchVeiculos()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FetchVeiculosImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() fetchVeiculos,
  }) {
    return fetchVeiculos();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchVeiculos,
  }) {
    return fetchVeiculos?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchVeiculos,
    required TResult orElse(),
  }) {
    if (fetchVeiculos != null) {
      return fetchVeiculos();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchVeiculos value) fetchVeiculos,
  }) {
    return fetchVeiculos(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchVeiculos value)? fetchVeiculos,
  }) {
    return fetchVeiculos?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchVeiculos value)? fetchVeiculos,
    required TResult orElse(),
  }) {
    if (fetchVeiculos != null) {
      return fetchVeiculos(this);
    }
    return orElse();
  }
}

abstract class FetchVeiculos implements VeiculoEvent {
  const factory FetchVeiculos() = _$FetchVeiculosImpl;
}
