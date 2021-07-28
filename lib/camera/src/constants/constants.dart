///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/7/15 02:06
///
import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';


import '../delegates/camera_picker_text_delegate.dart';



export 'colors.dart';
export 'screens.dart';

class Constants {
  const Constants._();

  static CameraPickerTextDelegate textDelegate =
      DefaultCameraPickerTextDelegate();
}

/// Log only in debug mode.
/// 只在调试模式打印
void realDebugPrint(dynamic message) {
  if (!kReleaseMode) {
    log('$message', name: 'CameraPicker - LOG');
  }
}

int get currentTimeStamp => DateTime.now().millisecondsSinceEpoch;

const BorderRadius maxBorderRadius = BorderRadius.all(Radius.circular(999999));

extension SafeSetStateExtension on State {
  FutureOr<void> safeSetState(FutureOr<dynamic> Function() fn) async {
    await fn();
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(() {});
    }
  }
}
