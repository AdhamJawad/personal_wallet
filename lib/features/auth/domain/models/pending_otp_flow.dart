import '../enums/otp_flow_type.dart';
import 'pending_otp_verification.dart';

class PendingOtpFlow {
  const PendingOtpFlow({required this.type, required this.challenge});

  final OtpFlowType type;
  final PendingOtpVerification challenge;

  String get phoneNumber => challenge.phoneNumber;
}
