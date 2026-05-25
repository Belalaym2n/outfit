import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/use_cases/analyze_outfit_use_case.dart';
import 'outfit_events.dart';
import 'outfit_states.dart';

class OutfitBloc extends Bloc<OutfitEvent, OutfitState> {
  final AnalyzeOutfitUseCase analyzeOutfitUseCase;
  final ImagePicker          _picker = ImagePicker();

  OutfitBloc({required this.analyzeOutfitUseCase})
      : super(OutfitState.initial()) {
    on<AddImageEvent>    (_onAddImage);
    on<RemoveImageEvent> (_onRemoveImage);
    on<ReplaceImageEvent>(_onReplaceImage);
    on<ValidateImagesEvent>(_onValidate);
    on<SubmitImagesEvent>(_onSubmit);
    on<RetryEvent>       (_onRetry);
    on<ResetEvent>       (_onReset);
  }

  // ─── Helpers ───────────────────────────────────────────────

  List<XFile?> _updatedImages(List<XFile?> current, int index, XFile? value) {
    final updated = List<XFile?>.from(current);
    updated[index] = value;
    return updated;
  }

  bool _validate(List<XFile?> images) {
       final hasTop = images[0] != null;
      final hasBottom = images[1] != null;

      return hasTop && hasBottom;
    }
  Future<XFile?> _pickImage() async {
    return await _picker.pickImage(
      source:       ImageSource.gallery,
      imageQuality: 85,
      maxWidth:     1080,
      maxHeight:    1080,
    );
  }

  // ─── Handlers ──────────────────────────────────────────────

  Future<void> _onAddImage(
      AddImageEvent event,
      Emitter<OutfitState> emit,
      ) async {
    final hasPermission = await _requestGalleryPermission();

    if (!hasPermission) {
      emit(state.copyWith(
        status: OutfitStatus.error,
        errorMessage: 'Permission denied',
      ));
      return;
    }

    final XFile? picked = await _pickImage();
    if (picked == null) return;

    final updated = _updatedImages(state.images, event.index, picked);

    emit(state.copyWith(
      status: OutfitStatus.editing,
      images: updated,
      isValid: _validate(updated),
      clearError: true,
    ));
  }
  Future<void> _onRemoveImage(
      RemoveImageEvent event,
      Emitter<OutfitState> emit,
      ) async {
    final updated = _updatedImages(state.images, event.index, null);
    emit(state.copyWith(
      status:  OutfitStatus.editing,
      images:  updated,
      isValid: _validate(updated),
    ));
  }

  Future<void> _onReplaceImage(
      ReplaceImageEvent event,
      Emitter<OutfitState> emit,
      ) async {
    final XFile? picked = await _pickImage();
    if (picked == null) return;

    final updated = _updatedImages(state.images, event.index, picked);
    emit(state.copyWith(
      status:     OutfitStatus.editing,
      images:     updated,
      isValid:    _validate(updated),
      clearError: true,
    ));
  }

  void _onValidate(
      ValidateImagesEvent event,
      Emitter<OutfitState> emit,
      ) {
    final valid = _validate(state.images);
    emit(state.copyWith(
      status:       OutfitStatus.validating,
      isValid:      valid,
      errorMessage: valid ? null : 'Please add at least your Top, Bottom, and Shoes.',
    ));
  }

  Future<void> _onSubmit(
      SubmitImagesEvent event,
      Emitter<OutfitState> emit,
      ) async {
    // Guard: prevent double submission
    if (state.isSubmitting) return;

    // Validate first
    if (!_validate(state.images)) {
      emit(state.copyWith(

        status:       OutfitStatus.error,
        errorMessage:'Please add at least Top and Bottom.',
        ));
      return;
    }

    emit(state.copyWith(
      status:       OutfitStatus.loading,
      isSubmitting: true,
      clearError:   true,
    ));

    final result = await analyzeOutfitUseCase(state.images);

    if (result.isSuccess) {
      emit(state.copyWith(
        status:       OutfitStatus.success,
        isSubmitting: false,
        result:       result.data,
      ));
    } else {
      emit(state.copyWith(
        status:       OutfitStatus.error,
        isSubmitting: false,
        errorMessage: result.error?.toString() ?? 'Analysis failed. Please try again.',
      ));
    }
  }

  void _onRetry(RetryEvent event, Emitter<OutfitState> emit) {
    emit(state.copyWith(
      status:       OutfitStatus.editing,
      isSubmitting: false,
      clearError:   true,
      clearResult:  true,
    ));
  }

  void _onReset(ResetEvent event, Emitter<OutfitState> emit) {
    emit(OutfitState.initial());
  }

  Future<bool> _requestGalleryPermission() async {
    final status = await Permission.photos.request();

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    return false;
  }
}