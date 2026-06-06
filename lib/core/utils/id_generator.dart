import 'package:uuid/uuid.dart';

final class IdGenerator {
  IdGenerator._();

  static const Uuid _uuid = Uuid();

  static String next() => _uuid.v4();
}
