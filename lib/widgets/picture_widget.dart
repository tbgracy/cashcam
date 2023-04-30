import 'dart:io';

import 'package:cashcam/models/operation_type_enum.dart';
import 'package:cashcam/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sim_data/sim_data.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

import '../services/http_service.dart';

enum SimCardCarrier { airtel, orange, telma }

class PictureWidget extends ConsumerStatefulWidget {
  const PictureWidget(
    this._imagePath,
    this.simcard, {
    Key? key,
  }) : super(key: key);

  final String _imagePath;

  final SimCard simcard;

  @override
  ConsumerState<PictureWidget> createState() => _PictureWidgetState();
}

class _PictureWidgetState extends ConsumerState<PictureWidget> {
  final service = HttpService();

  late final Future<String> result;

  final _codes = {
    OperationType.carte: {
      "airtel": "*888*...#",
      "orange": "#...#",
      "telma": "#...#",
    },
    OperationType.retrait: {
      "airtel": "*888*...#",
      "orange": "#...#",
      "telma": "#...#",
    },
  };

  @override
  void initState() {
    result = service.getPrediction(File(widget._imagePath));
    super.initState();
  }

  void _sendUssdCode() async {
    final operationType = ref.read(operationTypeProvider);

    final code =
        _codes[operationType]?[widget.simcard.carrierName.toLowerCase()];

    result.then(
      (value) async {
        final res = await UssdAdvanced.sendUssd(
          code: code!.replaceFirst("...", value),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 90,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(File(widget._imagePath)),
            ),
          ),
          const SizedBox(height: 20),
          FutureBuilder(
            future: result,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final res = snapshot.data as String;
                return SizedBox(
                  width: 200,
                  height: 49,
                  child: Text(snapshot.data as String),
                );
              } else {
                return const SizedBox(
                  width: 200,
                  height: 5,
                  child: LinearProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: _sendUssdCode,
          child: const Text('OK'),
        ),
      ],
    );
  }
}
