import 'dart:io';

import 'package:flutter_native_image/flutter_native_image.dart';

class PhotoService {
  Future<String> getCroppedImagePath(String filePath, int originX, int originY) async {
    File croppedFile = await FlutterNativeImage.cropImage(
      filePath,
      originX,
      originY,
      300,
      80,
    );

    return croppedFile.path;
  }
}