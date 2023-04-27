import 'package:camera/camera.dart';
import 'package:cashcam/constants.dart';
import 'package:flutter/material.dart';

import '../widgets/camera_action_container_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage(this.cameras, {Key? key}) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    final backCamera = widget.cameras.firstWhere(
      (element) => element.lensDirection == CameraLensDirection.back,
    );

    _cameraController = CameraController(
      backCamera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _cameraController.initialize();

    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_cameraController);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Positioned(
            top: 100,
            child: Container(
              width: 300,
              height: 80,
              decoration: BoxDecoration(
                color: colors[1].withAlpha(90),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colors[1],
                  width: 3,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            child: CameraActionContainerWidget(_cameraController),
          ),
        ],
      ),
    );
  }
}
