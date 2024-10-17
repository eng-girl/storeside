import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/product_store_owner.dart';
import '../../data/repo/product_storeowner_repo.dart';
import '../state/productstoreowner_state.dart';


class ProductCubit extends Cubit<ProductState> {
  final ProductRepository productRepository;

  ProductCubit(this.productRepository) : super(ProductInitial());

  Future<void> addProduct(Product product, String userId, File thumbnail, List<File> images) async {
    emit(ProductLoading());
    try {
      final success = await productRepository.addProduct(product, userId, thumbnail, images);
      if (success) {
        emit(ProductAdded());
      } else {
        emit(ProductError('Failed to add product.'));
      }
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}