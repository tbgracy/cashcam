import 'package:camera/camera.dart';
import 'package:cashcam/widgets/picture_widget.dart';
import 'package:flutter/material.dart';
import 'package:sim_data/sim_data.dart';

import '../constants.dart';
import '../services/photo_service.dart';
import '../services/sim_service.dart';

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
  SimCard? _selectedCard;

  final service = PhotoService();
  late Future<List<SimCard>> _simcards;

  void _takePicture() async {
    try {
      final image = await widget.cameraController.takePicture();

      const originX = 0;
      const originY = 0;

      final height = MediaQuery.of(context).size.height;

      final x = await service.getCroppedImagePath(
          image.path, originX.round(), originY, height.round());

      showDialog(
        context: context,
        builder: (context) {
          return PictureWidget(x);
        },
      );
    } catch (e) {
      print(e);
    }
  }

  List<DropdownMenuItem<SimCard>> _getDropdownMenus(List<SimCard> simcards) {
    List<DropdownMenuItem<SimCard>> result = [];
    for (final simcard in simcards) {
      result.add(
        DropdownMenuItem(
          value: simcard,
          child: Text(simcard.displayName),
        ),
      );
    }
    return result;
  }

  @override
  void initState() {
    _simcards = SimService.getSimcards();
    super.initState();
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
                child: FutureBuilder(
                    future: _simcards,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return DropdownButton<SimCard>(
                          hint: const Text('Choisir opérateur'),
                          value: _selectedCard,
                          underline: const SizedBox(),
                          isDense: true,
                          items:
                              _getDropdownMenus(snapshot.data as List<SimCard>),
                          onChanged: (value) {
                            setState(() {
                              _selectedCard = value;
                            });
                          },
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
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
