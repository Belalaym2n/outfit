import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class OutfitEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// User picks (or replaces) an image for a given slot index
class AddImageEvent extends OutfitEvent {
  final int   index;
  final XFile image;
  AddImageEvent({required this.index, required this.image});

  @override
  List<Object?> get props => [index, image.path];
}

/// User removes the image at a given slot index
class RemoveImageEvent extends OutfitEvent {
  final int index;
  RemoveImageEvent(this.index);

  @override
  List<Object?> get props => [index];
}

/// Triggered when user taps an already-filled card to replace
class ReplaceImageEvent extends OutfitEvent {
  final int   index;
  final XFile image;
  ReplaceImageEvent({required this.index, required this.image});

  @override
  List<Object?> get props => [index, image.path];
}

/// Validates current image slots without submitting
class ValidateImagesEvent extends OutfitEvent {}

/// Submits all images to the AI analysis API
class SubmitImagesEvent extends OutfitEvent {}

/// Retries a failed submission
class RetryEvent extends OutfitEvent {}

/// Resets the entire screen back to initial state
class ResetEvent extends OutfitEvent {}