import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/audit_event.dart';

part 'audit_state.freezed.dart';

@freezed
abstract class AuditState with _$AuditState {
  const factory AuditState({
    @Default(false) bool isLoading,
    @Default(<AuditEvent>[]) List<AuditEvent> events,
    String? errorMessage,
  }) = _AuditState;
}
