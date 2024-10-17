import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../models/storeowner_product.dart';

class StoreOwnerProductRepository {
  final Dio dio = Dio();

  Future<StoreOwnerProduct?> getProductByStoreOwner(String storeOwnerId) async {
    try {
      final response = await dio.get('${ApiConstants.storeOwner}/$storeOwnerId');

      if (response.statusCode == 200 && response.data != null) {
        print('Response data: ${response.data}');

        // Extract the product from the nested structure
        final storeData = response.data['store'];
        if (storeData != null && storeData['products'] != null) {
          final productList = List<Map<String, dynamic>>.from(storeData['products']);

          if (productList.isNotEmpty) {
            // Take the first product from the list (or adjust if you need to handle multiple products)
            return StoreOwnerProduct.fromJson(productList[0]);
          }
        }
      }
    } catch (e) {
      print('Error fetching product details: $e');
    }
    return null;
  }
}
