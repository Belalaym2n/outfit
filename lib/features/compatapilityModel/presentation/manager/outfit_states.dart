import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

 import '../../data/models/outfite_response_model.dart';

enum OutfitStatus {
  initial,
  editing,
  validating,
  loading,
  success,
  error,
}



class OutfitState extends Equatable { 
  final OutfitStatus          status;
  final List<XFile?>          images;       // exactly 5 nullable slots
  final bool                  isValid;
  final bool                  isSubmitting;
  final String?               errorMessage;
  final OutfitResponseModel?  result;

  int get imagesCount => images.where((img) => img != null).length;
  bool get canSubmit => isValid && !isSubmitting;
  const OutfitState({
    this.status       = OutfitStatus.initial,
    required this.images,
    this.isValid      = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.result,
  });

  factory OutfitState.initial() => OutfitState(
    images: List.filled(5, null),
  );

  OutfitState copyWith({
    OutfitStatus?         status,
    List<XFile?>?         images,
    bool?                 isValid,
    bool?                 isSubmitting,
    String?               errorMessage,
    OutfitResponseModel?  result,
    bool                  clearError  = false,
    bool                  clearResult = false,
  }) {
    return OutfitState(
      status:       status       ?? this.status,
      images:       images       ?? this.images,
      isValid:      isValid      ?? this.isValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError   ? null : (errorMessage ?? this.errorMessage),
      result:       clearResult  ? null : (result       ?? this.result),
    );
  }

  @override
  List<Object?> get props => [
    status, images, isValid, isSubmitting, errorMessage, result,
  ];
}