import 'package:flutter_test/flutter_test.dart';
import 'package:time_picker/time_picker_platform_interface.dart';
import 'package:time_picker/time_picker_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTimePickerPlatform
    with MockPlatformInterfaceMixin
    implements TimePickerPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final TimePickerPlatform initialPlatform = TimePickerPlatform.instance;

  test('$MethodChannelTimePicker is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTimePicker>());
  });

  test('getPlatformVersion', () async {
    MockTimePickerPlatform fakePlatform = MockTimePickerPlatform();
    TimePickerPlatform.instance = fakePlatform;
  });
}
