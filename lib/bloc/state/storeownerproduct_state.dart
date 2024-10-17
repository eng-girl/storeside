import '../../data/models/storeowner_product.dart';

abstract class StoreOwnerProductState {}

class ProductInitial extends StoreOwnerProductState {}

class ProductLoading extends StoreOwnerProductState {}

class ProductLoaded extends StoreOwnerProductState {
  final StoreOwnerProduct product; // Changed to StoreOwnerProduct

  ProductLoaded(this.product);
}

class ProductError extends StoreOwnerProductState {
  final String message;

  ProductError(this.message);
}