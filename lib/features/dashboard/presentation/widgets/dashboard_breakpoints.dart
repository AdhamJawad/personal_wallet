enum DashboardBreakpoint { smallPhone, phone, tablet, largeTablet }

DashboardBreakpoint resolveDashboardBreakpoint(double width) {
  if (width >= 900) {
    return DashboardBreakpoint.largeTablet;
  }
  if (width >= 600) {
    return DashboardBreakpoint.tablet;
  }
  if (width >= 390) {
    return DashboardBreakpoint.phone;
  }
  return DashboardBreakpoint.smallPhone;
}
