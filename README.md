# DateTimePicker Plugin

## English

### Overview

The `DateTimePicker` plugin provides a customizable widget for selecting both date and time in a single interface. It is designed to be flexible and user-friendly, making it suitable for various applications.

### Features

- Select date and time in one view.
- Customizable initial date and time.
- Visual feedback with a clock interface.
- Easy integration into existing Flutter projects.

### Installation

1. Add the dependency to your `pubspec.yaml` file:

   ```yaml
   dependencies:
     time_picker: ^1.0.0
   ```

2. Install the package:

   ```bash
   flutter pub get
   ```

### Usage

```dart
import 'package:time_picker/date_time_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DateTimePicker(
        initialDate: DateTime.now(),
        initialTime: TimeOfDay.now(),
        onDateTimeChanged: (dateTime) {
          print('Selected DateTime: $dateTime');
        },
      ),
    );
  }
}
```

### License

This project is licensed under the MIT License.

---

## 中文

### 概述

`DateTimePicker` 插件提供了一个可自定义的组件，用于在单个界面中选择日期和时间。它设计灵活且用户友好，适用于各种应用场景。

### 功能

- 在一个视图中选择日期和时间。
- 可自定义的初始日期和时间。
- 带有时钟界面的视觉反馈。
- 易于集成到现有的 Flutter 项目中。

### 安装

1. 在您的 `pubspec.yaml` 文件中添加依赖项：

   ```yaml
   dependencies:
     time_picker: ^1.0.0
   ```

2. 安装包：

   ```bash
   flutter pub get
   ```

### 使用

```dart
import 'package:time_picker/date_time_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DateTimePicker(
        initialDate: DateTime.now(),
        initialTime: TimeOfDay.now(),
        onDateTimeChanged: (dateTime) {
          print('Selected DateTime: $dateTime');
        },
      ),
    );
  }
}
```

### 许可证

此项目根据 MIT 许可证授权。
```

### 说明

- **概述/Overview**：简要介绍插件的功能和用途。
- **功能/Features**：列出插件的主要功能。
- **安装/Installation**：提供安装步骤。
- **使用/Usage**：提供一个简单的使用示例。
- **许可证/License**：说明项目的许可证信息。

您可以根据项目的具体情况和需求对内容进行调整和补充。