import 'dart:io';

import 'package:cashcam/pages/result_page.dart';
import 'package:cashcam/services/http_service.dart';
import 'package:flutter/material.dart';

class PictureWidget extends StatefulWidget {
  const PictureWidget(this._imagePath, {Key? key}) : super(key: key);

  final String _imagePath;

  @override
  State<PictureWidget> createState() => _PictureWidgetState();
}

class _PictureWidgetState extends State<PictureWidget> {
  bool isLoading = false;

  final service = HttpService();

  void _getPrediction() async {
    setState(() {
      isLoading = true;
    });
    final res = await service.getPrediction(File(widget._imagePath));
    setState(() {
      isLoading = false;
    });

    res.fold(
      (l) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l)));
      },
      (r) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ResultPage(r);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isLoading
              ? const SizedBox(
                  width: 200,
                  height: 5,
                  child: LinearProgressIndicator(),
                )
              : Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(File(widget._imagePath)),
                  ),
                ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: _getPrediction,
          child: const Text('OK'),
        ),
      ],
    );
  }
}
