import 'package:cashcam/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/operation_type_enum.dart';

class CustomFormWidget extends ConsumerStatefulWidget {
  const CustomFormWidget({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<CustomFormWidget> createState() => _CustomFormWidgetState();
}

class _CustomFormWidgetState extends ConsumerState<CustomFormWidget> {
  final _amountController = TextEditingController();
  OperationType _operationType = OperationType.carte;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // montantcrédit
        SizedBox(
          width: 300,
          child: DropdownButton(
            isExpanded: true,
            value: _operationType,
            onChanged: (value) {
              setState(() {
                _operationType = value as OperationType;
              });
              ref.read(operationTypeProvider.notifier).state = value as OperationType;

            },
            items: const [
              DropdownMenuItem(
                value: OperationType.retrait,
                child: Text('Retrait'),
              ),
              DropdownMenuItem(
                value: OperationType.carte,
                child: Text('Carte de crédit'),
              ),
            ],
          ),
        ),
        if (_operationType == OperationType.retrait)
          SizedBox(
            width: 300,
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              controller: _amountController,
              decoration: const InputDecoration(
                hintText: 'Entrer le montant',
                suffixText: 'MGA',
              ),
            ),
          ),
      ],
    );
  }
}
