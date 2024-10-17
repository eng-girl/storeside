import 'package:bloc/bloc.dart';
import '../../data/repo/storeownerproduct_repo.dart';
import '../state/storeownerproduct_state.dart';

class StoreOwnerProductCubit extends Cubit<StoreOwnerProductState> {
  final StoreOwnerProductRepository repository;

  StoreOwnerProductCubit(this.repository) : super(ProductInitial());

  Future<void> fetchProductByStoreOwner(String storeOwnerId) async {
    emit(ProductLoading());
    try {
      final product = await repository.getProductByStoreOwner(storeOwnerId);
      if (product != null) {
        emit(ProductLoaded(product));
      } else {
        emit(ProductError('Failed to load product details.'));
      }
    } catch (e) {
      emit(ProductError('Error: $e'));
    }
  }
}