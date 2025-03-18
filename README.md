# Flutter 日期时间选择器

一个功能强大的 Flutter 日期时间选择器插件，支持日期、时间和日期时间的选择。

## 功能特点

- 支持三种选择模式：
  - 仅日期选择
  - 仅时间选择
  - 日期时间同时选择
- 美观的时钟界面
- 支持滚轮选择
- 支持键盘导航
- 支持屏幕阅读器
- 完全可自定义的样式


## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_datetime_picker: ^1.0.0
```

## 使用方法

### 基本用法

```dart
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

// 显示日期时间选择器
showDateTimePicker(
  context: context,
  initialDate: DateTime.now(),
  initialTime: TimeOfDay.now(),
  type: DateTimePickerType.datetime,
  onDateTimeSelected: (DateTime dateTime) {
    print('选择的日期时间: $dateTime');
  },
);
```

### 仅选择日期

```dart
showDateTimePicker(
  context: context,
  initialDate: DateTime.now(),
  initialTime: TimeOfDay.now(),
  type: DateTimePickerType.date,
  onDateTimeSelected: (DateTime dateTime) {
    print('选择的日期: $dateTime');
  },
);
```

### 仅选择时间

```dart
showDateTimePicker(
  context: context,
  initialDate: DateTime.now(),
  initialTime: TimeOfDay.now(),
  type: DateTimePickerType.time,
  onDateTimeSelected: (DateTime dateTime) {
    print('选择的时间: $dateTime');
  },
);
```

## 自定义样式

您可以通过修改主题来自定义选择器的外观：

```dart
showDateTimePicker(
  context: context,
  initialDate: DateTime.now(),
  initialTime: TimeOfDay.now(),
  type: DateTimePickerType.datetime,
  theme: ThemeData(
    primaryColor: Colors.blue,
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
    ),
  ),
  onDateTimeSelected: (DateTime dateTime) {
    print('选择的日期时间: $dateTime');
  },
);
```

## 版本历史

### 1.0.0
- 初始版本发布
- 支持日期、时间和日期时间选择
- 添加时钟界面
- 支持滚轮选择
- 支持键盘导航和屏幕阅读器
- 完全可自定义的样式

## 许可证

MIT License