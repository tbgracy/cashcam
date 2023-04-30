import 'package:flutter/services.dart';
import 'package:sim_data/sim_data.dart';

class SimService {
  static Future<List<SimCard>> getSimcards()async {
    List<SimCard> result = [];
    try{
      SimData simData = await SimDataPlugin.getSimData();
      // for (final sim in simData.cards){
      //   result.add(SimCardModel(slotNumber: sim.slotIndex, provider: sim.carrierName, number: number,),);
      // }
      for (final sim in simData.cards){
        result.add(sim);
      }
      return result;
    } on PlatformException catch (e) {
      print('Error : ${e.code}');
      rethrow;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}