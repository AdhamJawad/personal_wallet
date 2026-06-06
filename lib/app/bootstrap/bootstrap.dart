import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/hive/hive_initializer.dart';
import '../app.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveInitializer.initialize();
  runApp(const ProviderScope(child: PersonalWalletApp()));
}
