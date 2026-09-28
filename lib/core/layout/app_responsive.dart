import 'package:flutter/widgets.dart';

enum DeviceType { mobile, tablet, desktopSmall, desktopLarge }

class Breakpoints {
  Breakpoints._();
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktopSmall = 1280;
}

DeviceType deviceTypeOf(double width) {
  if (width < Breakpoints.mobile) return DeviceType.mobile;
  if (width < Breakpoints.tablet) return DeviceType.tablet;
  // if (width < Breakpoints.desktopSmall) return DeviceType.desktopSmall;
  return DeviceType.desktopLarge;
}

class Responsive extends StatelessWidget {
  const Responsive({super.key, required this.builder});

  final Widget Function(BuildContext context, DeviceType type, BoxConstraints c)
  builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) =>
          builder(ctx, deviceTypeOf(constraints.maxWidth), constraints),
    );
  }
}

extension ResponsiveX on BuildContext {
  DeviceType get deviceType => deviceTypeOf(MediaQuery.sizeOf(this).width);
  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop =>
      deviceType == DeviceType.desktopSmall ||
      deviceType == DeviceType.desktopLarge;
  Size get screenSize => MediaQuery.sizeOf(this);
}
