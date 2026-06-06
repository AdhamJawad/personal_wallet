import 'package:flutter/widgets.dart';

import '../../../../core/design_system/widgets/pw_placeholder_view.dart';

class QrPlaceholderPage extends StatelessWidget {
  const QrPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PwPlaceholderView(
      title: 'QR Module',
      description:
          'User-specific QR identities for contact sharing and wallet transfers will be implemented here, with payload versioning ready for future backend validation.',
    );
  }
}
