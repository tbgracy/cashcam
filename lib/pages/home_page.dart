import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../widgets/camera_action_container_widget.dart';
import '../widgets/custom_form_widget.dart';

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
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 100,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FutureBuilder(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                            child: ClipRRect(
                              child: OverflowBox(
                                alignment: Alignment.topCenter,
                                child: FittedBox(
                                  alignment: Alignment.topCenter,
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    // height: MediaQuery.of(context).size.height / _cameraController.value.aspectRatio,
                                    child: GestureDetector(
                                      onTap: () async {
                                        await _cameraController
                                            .setFocusPoint(null);
                                      },
                                      child: CameraPreview(_cameraController),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              const Positioned(
                top: 300,
                child: CustomFormWidget(),
              ),
              Positioned(
                bottom: 40,
                child: CameraActionContainerWidget(_cameraController),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
