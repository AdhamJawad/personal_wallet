import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/conflict_resolution_strategy.dart';
import 'conflict_record.dart';
import 'sync_operation.dart';

part 'conflict_summary.freezed.dart';
part 'conflict_summary.g.dart';

@freezed
abstract class ConflictSummary with _$ConflictSummary {
  const factory ConflictSummary({
    required SyncOperation operation,
    required ConflictRecord record,
    required ConflictResolutionStrategy recommendedStrategy,
  }) = _ConflictSummary;

  factory ConflictSummary.fromJson(Map<String, dynamic> json) =>
      _$ConflictSummaryFromJson(json);
}
