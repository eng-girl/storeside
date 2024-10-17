import 'package:equatable/equatable.dart';


abstract class ProductState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductAdded extends ProductState {}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);

  @override
  List<Object> get props => [message];
}