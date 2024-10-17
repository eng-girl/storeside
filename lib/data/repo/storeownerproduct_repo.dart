import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../models/storeowner_product.dart';

class StoreOwnerProductRepository {
  final Dio dio = Dio();

  Future<Product?> getProductByStoreOwner(String storeOwnerId) async {
    try {
      final response = await dio.get('${ApiConstants.storeOwnerProducts}/$storeOwnerId');
      if (response.statusCode == 200 && response.data != null) {
        return Product.fromJson(response.data); // Adjust according to your API response
      }
    } catch (e) {
      print('Error fetching product details: $e');
    }
    return null;
  }



}