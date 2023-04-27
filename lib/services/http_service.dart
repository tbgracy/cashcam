import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class HttpService {
  final baseUrl = 'http://192.168.58.103:5000';

  Future<Either<String, String>> getPrediction(File image) async {
    final filename = image.path.split('/').last;

    final formData = FormData.fromMap(
      {
        "file": await MultipartFile.fromFile(
          image.path,
          filename: filename,
          contentType: MediaType(
            'image',
            image.path.split('.').last,
          ),
        ),
      },
    );
    try {
      final response = await Dio().post('$baseUrl/predict', data: formData);
      return Right(response.data['prediction']);
    } on DioError catch (e) {
      if (e.error.runtimeType == SocketException) {
        return const Left('Veuillez vérifier votre connexion internet');
      }
      return Left(e.response?.data.toString() ?? e.toString());
    } catch (e) {
      return Left(e.toString());
    }
  }
}
