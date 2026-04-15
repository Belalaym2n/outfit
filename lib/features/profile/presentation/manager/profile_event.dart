import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Fired on screen init and on pull-to-refresh.
class ProfileFetchRequested extends ProfileEvent {}

/// Fired when the user taps "retry" after an error.
class ProfileRetryRequested extends ProfileEvent {}