import 'package:flutter/material.dart';

enum DashboardBreakpoint { smallPhone, phone, tablet, largeTablet }

const double dashboardTabletBreakpoint = 600;
const double dashboardLargeTabletBreakpoint = 900;
const double dashboardCompactHeightBreakpoint = 560;
const double dashboardPageMaxWidth = 1120;
const double dashboardReadableContentMaxWidth = 760;
const double dashboardWidePanelMaxWidth = 960;

DashboardBreakpoint resolveDashboardBreakpoint(Size size) {
  final double width = size.width;
  final bool compactHeight = size.height < dashboardCompactHeightBreakpoint;

  if (!compactHeight && width >= dashboardLargeTabletBreakpoint) {
    return DashboardBreakpoint.largeTablet;
  }
  if (!compactHeight && width >= dashboardTabletBreakpoint) {
    return DashboardBreakpoint.tablet;
  }
  if (width >= 390) {
    return DashboardBreakpoint.phone;
  }
  return DashboardBreakpoint.smallPhone;
}

double resolveDashboardHorizontalPadding(DashboardBreakpoint breakpoint) {
  return switch (breakpoint) {
    DashboardBreakpoint.smallPhone => 24,
    DashboardBreakpoint.phone => 32,
    DashboardBreakpoint.tablet => 40,
    DashboardBreakpoint.largeTablet => 40,
  };
}

bool usesTabletLayout(DashboardBreakpoint breakpoint) {
  return breakpoint == DashboardBreakpoint.tablet ||
      breakpoint == DashboardBreakpoint.largeTablet;
}
