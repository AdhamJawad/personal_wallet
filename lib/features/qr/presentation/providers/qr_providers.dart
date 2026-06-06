import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/mock_qr_repository.dart';
import '../../domain/repositories/qr_repository.dart';

final qrRepositoryProvider = Provider<QrRepository>((Ref ref) {
  return const MockQrRepository();
});
