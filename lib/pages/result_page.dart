import 'package:cashcam/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

class ResultPage extends StatefulWidget {
  const ResultPage(this.result, {Key? key}) : super(key: key);

  final String result;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final amountController = TextEditingController();

  void _effectuerRetrait() async {
  final res = await UssdAdvanced.sendUssd(code: "#11*1*4*1*${widget.result}*${amountController.text}#");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Retrait',
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Text('Numéro cash point : ${widget.result}'),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              controller: amountController,
              decoration: const InputDecoration(
                hintText: 'Entrer le montant (MGA)',
              ),
            ),
            ElevatedButton(
              onPressed: _effectuerRetrait,
              child: const Text('Effectuer retrait'),
            ),
          ],
        ),
      ),
    );
  }
}
