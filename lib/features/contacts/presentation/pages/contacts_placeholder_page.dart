import 'package:flutter/widgets.dart';

import '../../../../core/design_system/widgets/pw_placeholder_view.dart';

class ContactsPlaceholderPage extends StatelessWidget {
  const ContactsPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PwPlaceholderView(
      title: 'Contacts Module',
      description:
          'Registered users and external contacts will be managed here, including future dual-approval identity linking when an external contact later creates an account.',
    );
  }
}
