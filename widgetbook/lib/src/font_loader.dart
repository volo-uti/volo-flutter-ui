import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Loads the Pretendard font from the local web/fonts/ folder on the web and
/// registers it with the Flutter CanvasKit/Skwasm renderer.
///
/// Does nothing on native platforms (iOS/Android/desktop).
Future<void> loadPretendardFont() async {
  if (!kIsWeb) return;

  try {
    final fontData = await rootBundle.load('fonts/PretendardVariable.woff2');
    await ui.loadFontFromList(
      fontData.buffer.asUint8List(),
      fontFamily: 'Pretendard Variable',
    );
    debugPrint('Pretendard font loaded successfully');
  } catch (e) {
    debugPrint('Pretendard font load failed: $e');
  }
}
