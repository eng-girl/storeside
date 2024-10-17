import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../data/models/product_store_owner.dart';
import 'dart:io';

class ProductRepository {
  final Dio dio = Dio();

  Future<bool> addProduct(Product product, String userId, File thumbnail, List<File> images) async {
    try {
      // Construct the URL using the user ID
      final url = '${ApiConstants.addstoreownerproduct}/$userId/product';

      // Create FormData
      final formData = FormData();

      // Add product data
      formData.fields.addAll([
        MapEntry('name', product.name),
        MapEntry('price', product.price.toString()),
        MapEntry('description', product.description),
        MapEntry('material', product.material),
        MapEntry('category', product.category),
        MapEntry('subcategory', product.subcategory ?? ''),
        MapEntry('colors', product.colors.join(',')), // Adjust if necessary
        MapEntry('timeToBeCreated', product.timeToBeCreated),
        MapEntry('stock', product.stock.toString()),
      ]);

      // Add thumbnail and images
      formData.files.add(MapEntry('thumbnail', await MultipartFile.fromFile(thumbnail.path)));
      for (var image in images) {
        formData.files.add(MapEntry('images', await MultipartFile.fromFile(image.path)));
      }

      // Send the request
      final response = await dio.post(url);
      return response.statusCode == 201; // Assuming 201 is the success status code
    } catch (e) {
      print('Error adding product: $e');
      return false;
    }
  }
}