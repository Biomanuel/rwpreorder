import 'package:flutter/widgets.dart';
import 'package:rwk20/enums/device_screen_type.dart';

const double tabletWidthLimit = 950;
const double mobileWidthLimit = 600;

DeviceScreenType getDeviceType(MediaQueryData mediaQuery) {
  var orientation = mediaQuery.orientation;

  // Fixed Device width (changes with orientation)
  double deviceWidth = 0;

  if (orientation == Orientation.landscape) {
    deviceWidth = mediaQuery.size.height;
  } else {
    deviceWidth = mediaQuery.size.width;
  }

  if (deviceWidth > tabletWidthLimit) {
    return DeviceScreenType.Desktop;
  }

  if (deviceWidth > mobileWidthLimit) {
    return DeviceScreenType.Tablet;
  }

  return DeviceScreenType.Mobile;
}
