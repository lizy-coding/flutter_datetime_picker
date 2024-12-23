#ifndef FLUTTER_PLUGIN_TIME_PICKER_PLUGIN_H_
#define FLUTTER_PLUGIN_TIME_PICKER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace time_picker {

class TimePickerPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  TimePickerPlugin();

  virtual ~TimePickerPlugin();

  // Disallow copy and assign.
  TimePickerPlugin(const TimePickerPlugin&) = delete;
  TimePickerPlugin& operator=(const TimePickerPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace time_picker

#endif  // FLUTTER_PLUGIN_TIME_PICKER_PLUGIN_H_
