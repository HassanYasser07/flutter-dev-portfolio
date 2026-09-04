import 'package:dio/dio.dart';
import '../../../core/constants/email_js_config.dart';

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
  /// Sends the message securely using EmailJS via Dio.
  Future<bool> sendContactMessage({
    required String name,
    required String email,
    required String message,
  }) async {
    if (name.trim().isEmpty || email.trim().isEmpty || message.trim().isEmpty) {
      return false;
    }

    try {
      final dio = Dio();
      final response = await dio.post(
        EmailJsConfig.endpoint,
        data: {
          'service_id': EmailJsConfig.serviceId,
          'template_id': EmailJsConfig.templateId,
          'user_id': EmailJsConfig.publicKey,
          'template_params': {
            'name': name,
            'email': email,
            'message': message,
          },
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      if (e is DioException) {
        print('EmailJS Error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('Error sending email: $e');
      }
      return false;
    }
  }
}
