import 'dart:io';

import 'package:flutter_native_image/flutter_native_image.dart';

class PhotoService {
  Future<String> getCroppedImagePath(String filePath, int originX, int originY) async {
    File croppedFile = await FlutterNativeImage.cropImage(
      filePath,
      // filePath.split('.').first + DateTime.now().toIso8601String() + '.' + filePath.split('.').last,
      originX,
      originY,
      300,
      90,
    );

    return croppedFile.path;
  }
}
