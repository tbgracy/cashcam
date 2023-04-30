import 'package:camera/camera.dart';
import 'package:cashcam/pages/home_page.dart';
import 'package:cashcam/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  runApp(
    ProviderScope(
      child: MyApp(cameras),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp(this.cameras, {Key? key}) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CashCam',
      theme: themeData,
      home: HomePage(cameras),
    );
  }
}
