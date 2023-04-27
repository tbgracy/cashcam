import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../services/photo_service.dart';

class CameraActionContainerWidget extends StatefulWidget {
  const CameraActionContainerWidget(
    this.cameraController, {
    Key? key,
  }) : super(key: key);

  final CameraController cameraController;

  @override
  State<CameraActionContainerWidget> createState() =>
      _CameraActionContainerWidgetState();
}

class _CameraActionContainerWidgetState
    extends State<CameraActionContainerWidget> {
  String? _provider;

  final service = PhotoService();

  void _takePicture() async {
    try {
      final image = await widget.cameraController.takePicture();

      // final originX = (MediaQuery.of(context).size.width - 300) ~/ 2;
      // final originY = MediaQuery.of(context).size.height - ;
      const originX = 80;
      const originY = 80;

      final x = await service.getCroppedImagePath(image.path, originX.round(), originY);

      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Image.file(
              // File(image.path),
              File(x),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.7,
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: colors[0],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: colors[1],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: DropdownButton<String>(
                  hint: const Text('Choisir opérateur'),
                  value: _provider,
                  isDense: true,
                  items: const [
                    DropdownMenuItem(
                      value: 'airtel',
                      child: Text('Airtel'),
                    ),
                    DropdownMenuItem(
                      value: 'orange',
                      child: Text('Orange'),
                    ),
                    DropdownMenuItem(
                      value: 'telma',
                      child: Text('Telma'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _provider = value;
                    });
                  },
                ),
              ),
            ),
            IconButton(
              tooltip: 'Appuyer pour prendre une photo',
              onPressed: _takePicture,
              icon: Icon(
                color: colors[1],
                Icons.camera,
                size: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
