import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/models/qr_identity.dart';

class QrIdentityCard extends StatelessWidget {
  const QrIdentityCard({required this.identity, super.key});

  final QrIdentity identity;

  @override
  Widget build(BuildContext context) {
    return PwSectionCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: _PseudoQrGrid(payload: identity.payload),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(identity.displayName, style: context.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(
              identity.publicReferenceIdentifier,
              style: context.bodyLarge.copyWith(color: AppColors.brandDark),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              const JsonEncoder.withIndent(
                '  ',
              ).convert(jsonDecode(identity.payload)),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _PseudoQrGrid extends StatelessWidget {
  const _PseudoQrGrid({required this.payload});

  final String payload;

  @override
  Widget build(BuildContext context) {
    const int gridSize = 21;
    final List<int> codeUnits = payload.codeUnits;
    final List<bool> cells = List<bool>.generate(gridSize * gridSize, (
      int index,
    ) {
      final int seed = codeUnits[index % codeUnits.length];
      return ((seed + index * 13) % 7) < 3;
    });

    return SizedBox(
      width: 220,
      height: 220,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cells.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridSize,
        ),
        itemBuilder: (BuildContext context, int index) {
          final bool isFinder = _isFinderCell(index, gridSize);
          final bool isFilled = isFinder || cells[index];
          return Container(
            margin: const EdgeInsets.all(0.5),
            decoration: BoxDecoration(
              color: isFilled ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(isFinder ? 1.5 : 0),
            ),
          );
        },
      ),
    );
  }

  bool _isFinderCell(int index, int gridSize) {
    final int row = index ~/ gridSize;
    final int column = index % gridSize;

    bool inBox(int top, int left) {
      final bool withinBounds =
          row >= top && row < top + 5 && column >= left && column < left + 5;
      if (!withinBounds) {
        return false;
      }
      final bool border =
          row == top || row == top + 4 || column == left || column == left + 4;
      final bool center =
          row >= top + 1 &&
          row <= top + 3 &&
          column >= left + 1 &&
          column <= left + 3;
      return border || center;
    }

    return inBox(0, 0) || inBox(0, 16) || inBox(16, 0);
  }
}
