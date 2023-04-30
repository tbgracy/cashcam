import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sim_data/sim_data.dart';

import '../constants.dart';
import '../services/http_service.dart';
import '../services/photo_service.dart';
import '../services/sim_service.dart';
import 'picture_widget.dart';

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

  final photoService = PhotoService();
  final httpService = HttpService();
  late Future<List<SimCard>> _simcards;

  void _takePicture() async {
    if (_selectedCard != null) {
      try {
        final image = await widget.cameraController.takePicture();

        const originX = 0;
        const originY = 0;

        final height = MediaQuery.of(context).size.height;

        final filename = await photoService.getCroppedImagePath(
            image.path, originX.round(), originY, height.round());

        showDialog(
          context: context,
          builder: (context) {
            return PictureWidget(filename, _selectedCard!);
          },
        );
      } catch (e) {
        print(e);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez choisir un opérateur'),
        ),
      );
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
                          hint: const Text('Choix d`opérateur'),
                          value: _selectedCard,
                          underline: const SizedBox(),
                          isDense: true,
                          items:
                              _getDropdownMenus(snapshot.data as List<SimCard>),
                          onChanged: (value) {
                            setState(() {
                              _selectedCard = value;
                            });
                            print(_selectedCard?.carrierName);
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
