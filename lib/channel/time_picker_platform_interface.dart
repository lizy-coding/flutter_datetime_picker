import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'time_picker_method_channel.dart';

abstract class TimePickerPlatform extends PlatformInterface {
  /// Constructs a TimePickerPlatform.
  TimePickerPlatform() : super(token: _token);

  static final Object _token = Object();

  static TimePickerPlatform _instance = MethodChannelTimePicker();

  /// The default instance of [TimePickerPlatform] to use.
  ///
  /// Defaults to [MethodChannelTimePicker].
  static TimePickerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TimePickerPlatform] when
  /// they register themselves.
  static set instance(TimePickerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
