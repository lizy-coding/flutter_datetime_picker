import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'time_picker_platform_interface.dart';

/// An implementation of [TimePickerPlatform] that uses method channels.
class MethodChannelTimePicker extends TimePickerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('time_picker');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
