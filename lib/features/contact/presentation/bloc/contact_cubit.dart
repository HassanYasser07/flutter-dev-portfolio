import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/contact_repository.dart';
import 'contact_state.dart';

/// Cubit managing contact form state and message submissions.
class ContactCubit extends Cubit<ContactState> {
  ContactCubit({
    ContactRepository repository = const ContactRepository(),
  })  : _repository = repository,
        super(const ContactState());

  final ContactRepository _repository;

  /// Submits a contact form message after validating input fields.
  Future<void> sendMessage({
    required String name,
    required String email,
    required String message,
  }) async {
    if (state.status == ContactStatus.sending) return;

    final trimmedName = name.trim();
    final trimmedEmail = email.trim();
    final trimmedMessage = message.trim();

    if (trimmedName.isEmpty || trimmedEmail.isEmpty || trimmedMessage.isEmpty) {
      emit(state.copyWith(
        status: ContactStatus.error,
        errorMessage: 'Please fill in all required fields.',
      ));
      return;
    }

    emit(state.copyWith(
      status: ContactStatus.sending,
      errorMessage: null,
      successMessage: null,
    ));

    try {
      final success = await _repository.sendContactMessage(
        name: trimmedName,
        email: trimmedEmail,
        message: trimmedMessage,
      );

      if (success) {
        emit(state.copyWith(
          status: ContactStatus.success,
          successMessage: 'Your message has been sent successfully!',
        ));
      } else {
        emit(state.copyWith(
          status: ContactStatus.error,
          errorMessage: 'Failed to send message. Please try again.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ContactStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Resets the contact state back to initial.
  void reset() {
    emit(const ContactState());
  }
}
