/// Repository responsible for contact details, social links, and message submission.
class ContactRepository {
  const ContactRepository();

  String get email => 'hassanyasser1313@gmail.com';
  String get phone => '01127246674';
  String get whatsappUrl => 'https://wa.me/201127246674';
  String get githubUrl => 'https://github.com/HassanYasser07';
  String get linkedinUrl =>
      'https://www.linkedin.com/in/hassan-yasser-227545249/';

  /// Processes contact form message submissions.
  /// Currently structured locally so a real API/email backend can be wired later.
  Future<bool> sendContactMessage({
    required String name,
    required String email,
    required String message,
  }) async {
    if (name.trim().isEmpty || email.trim().isEmpty || message.trim().isEmpty) {
      return false;
    }
    // Local processing placeholder; returns success.
    return true;
  }
}
