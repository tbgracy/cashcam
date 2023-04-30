import 'package:cashcam/models/operation_type_enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final operationTypeProvider = StateProvider<OperationType>((ref) {
  return OperationType.carte;
});
