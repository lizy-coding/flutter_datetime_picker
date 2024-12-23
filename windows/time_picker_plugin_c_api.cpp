#include "include/time_picker/time_picker_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "time_picker_plugin.h"

void TimePickerPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  time_picker::TimePickerPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
