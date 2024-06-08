import 'package:flutter/material.dart';

enum DeviceType {
  phone,
  tablet,
}

class ScreenUtils {
  Size fixedResolutionPhone = const Size(2532, 1170);
  Size fixedResolutionTablet = const Size(2048, 2732);

  Size currentResolution = const Size(0, 0);
  double _scaleMultiplier = 0;
  late DeviceType deviceType;
  ScreenUtils() {
    calculateMultiplier();
  }

  calculateMultiplier() {
    deviceType =
        _isTablet(currentResolution) ? DeviceType.tablet : DeviceType.phone;
    debugPrint('Device Type: $deviceType');

    var fixedResolution = deviceType == DeviceType.tablet
        ? fixedResolutionTablet
        : fixedResolutionPhone;

    double ratioDiff = 0;
    if (currentResolution.aspectRatio > fixedResolution.aspectRatio) {
      ratioDiff = fixedResolution.aspectRatio / currentResolution.aspectRatio;
    } else if (currentResolution.aspectRatio < fixedResolution.aspectRatio) {
      ratioDiff = currentResolution.aspectRatio / fixedResolution.aspectRatio;
    }

    _scaleMultiplier = currentResolution.width / fixedResolution.width;
    _scaleMultiplier *= ratioDiff;
    if (deviceType == DeviceType.tablet) {
      _scaleMultiplier *= 1.6;
    }
  }

  Size getSize(Size size) {
    return Size(getWidth(size.width), getHeight(size.height));
  }

  double getWidth(double width) {
    return width * _scaleMultiplier;
  }

  double getHeight(double height) {
    return height * _scaleMultiplier;
  }

  updateCurrentResolution(Size res) {
    currentResolution = res;
    calculateMultiplier();
  }

  bool _isTablet(Size size) {
    var aspectRatio = size.width / size.height;
    var shortestSide = size.height < size.width ? size.height : size.width;

    return shortestSide >= 575 && aspectRatio >= 1.33 && aspectRatio <= 1.78;
  }
}
