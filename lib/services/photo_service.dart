import 'dart:io';

import 'package:flutter_native_image/flutter_native_image.dart';

class PhotoService {
  Future<String> getCroppedImagePath(String filePath, int originX, int originY, int sHeight) async {
    final properties = await FlutterNativeImage.getImageProperties(filePath);
    int pWidth = properties.height!;
    int pHeight = 170;

    File croppedFile = await FlutterNativeImage.cropImage(
      filePath,
      originX,
      originY,
      pHeight,
      pWidth,
    );

    return croppedFile.path;
  }
}