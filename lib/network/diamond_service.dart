import 'package:diamond_app/models/diamond_model.dart';
import 'package:diamond_app/network/api_endpoints.dart';
import 'package:dio/dio.dart';

class DiamondService {
  final Dio dio;

  DiamondService(this.dio);

  Future<List<Diamond>> fetchDiamonds({
    double? caratFrom,
    double? caratTo,
    String? lab,
    String? shape,
    String? color,
    String? clarity,
  }) async {
    try {
      // Fetch all diamonds from API
      final response = await dio.get(ApiEndpoints.diamonds);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Diamond> diamonds = data.map((json) => Diamond.fromJson(json)).toList();

        // Apply filtering locally
        return diamonds.where((diamond) {
          bool matchesCarat = (caratFrom == null || diamond.carat! >= caratFrom) &&
                              (caratTo == null || diamond.carat! <= caratTo);
          bool matchesLab = lab == null || diamond.lab == lab;
          bool matchesShape = shape == null || diamond.shape == shape;
          bool matchesColor = color == null || diamond.color == color;
          bool matchesClarity = clarity == null || diamond.clarity == clarity;

          return matchesCarat && matchesLab && matchesShape && matchesColor && matchesClarity;
        }).toList();
      } else {
        throw Exception("Failed to load diamonds");
      }
    } catch (e) {
      throw Exception("Error fetching diamonds: $e");
    }
  }
}