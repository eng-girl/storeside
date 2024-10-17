import 'package:bloc/bloc.dart';
import '../../data/models/storeowner_product.dart';
import '../../data/repo/storeownerproduct_repo.dart';
import '../state/storeownerproduct_state.dart';

class StoreOwnerProductCubit extends Cubit<StoreOwnerProductState> {
  final StoreOwnerProductRepository repository;

  StoreOwnerProductCubit(this.repository) : super(ProductInitial());

  Future<void> fetchProductByStoreOwner(String storeOwnerId) async {
    emit(ProductLoading());
    try {
      final List<StoreOwnerProduct> products = await repository.getProductsByStoreOwner(storeOwnerId); // Updated to fetch a list
      if (products.isNotEmpty) {
        emit(ProductLoaded(products));
      } else {
        emit(ProductError('No products available.'));
      }
    } catch (e) {
      emit(ProductError('Error: $e'));
    }
  }
}