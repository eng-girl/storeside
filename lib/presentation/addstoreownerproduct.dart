import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../bloc/cubit/auth_cubit.dart';
import '../../../data/models/product_store_owner.dart';
import '../../../data/models/store_model.dart';
import '../../../bloc/cubit/store_cubit.dart';
import '../../../bloc/state/store_state.dart';
import '../bloc/cubit/productstoreowner_cubit.dart';
import '../bloc/state/productstoreowner_state.dart';

class AddStoreOwnerProduct extends StatefulWidget {
  @override
  _AddStoreOwnerProductState createState() => _AddStoreOwnerProductState();
}

class _AddStoreOwnerProductState extends State<AddStoreOwnerProduct> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  double price = 0;
  String description = '';
  String material = '';
  String category = '';
  String? subcategory;
  List<String> colors = [];
  String storeOwner = '';
  String timeToBeCreated = DateTime.now().toIso8601String();
  XFile? thumbnailImage; // Store thumbnail image
  List<XFile> galleryImages = []; // Store picked gallery images
  int stock = 0;

  final ImagePicker _picker = ImagePicker();
  Store? store;

  @override
  void initState() {
    super.initState();
    final user = BlocProvider.of<AuthCubit>(context).currentUser;
    if (user != null) {
      storeOwner = user.id; // Set store owner ID
      context.read<StoreCubit>().fetchStore(storeOwner);
    }
  }

  Future<void> _pickThumbnail() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        thumbnailImage = pickedImage; // Store the selected thumbnail image
      });
    }
  }

  Future<void> _pickGalleryImages() async {
    final List<XFile>? pickedImages = await _picker.pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        galleryImages = pickedImages; // Store the selected gallery images
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: BlocConsumer<StoreCubit, StoreState>(
        listener: (context, storeState) {
          if (storeState is StoreError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(storeState.message)),
            );
          } else if (storeState is StoreLoaded) {
            store = storeState.store;
          }
        },
        builder: (context, storeState) {
          if (storeState is StoreLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Product Name'),
                      onChanged: (value) => name = value,
                      validator: (value) => value == null || value.isEmpty ? 'Enter product name' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => price = double.tryParse(value) ?? 0,
                      validator: (value) => value == null || value.isEmpty ? 'Enter product price' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Description'),
                      onChanged: (value) => description = value,
                      validator: (value) => value == null || value.isEmpty ? 'Enter product description' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Material'),
                      onChanged: (value) => material = value,
                      validator: (value) => value == null || value.isEmpty ? 'Enter material' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Category'),
                      onChanged: (value) => category = value,
                      validator: (value) => value == null || value.isEmpty ? 'Enter category' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Subcategory (optional)'),
                      onChanged: (value) => subcategory = value.isNotEmpty ? value : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Colors (comma separated)'),
                      onChanged: (value) {
                        colors = value.split(',').map((color) => color.trim()).toList();
                      },
                    ),
                    ElevatedButton(
                      onPressed: _pickThumbnail,
                      child: Text('Select Thumbnail Image'),
                    ),
                    thumbnailImage != null
                        ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                        File(thumbnailImage!.path),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Container(),
                    ElevatedButton(
                      onPressed: _pickGalleryImages,
                      child: Text('Select Gallery Images'),
                    ),
                    Wrap(
                      children: galleryImages.map((image) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.file(
                            File(image.path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        );
                      }).toList(),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Stock'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => stock = int.tryParse(value) ?? 0,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          if (store != null) {
                            final product = Product(
                              id: '', // ID will be generated by the backend
                              name: name,
                              price: price,
                              description: description,
                              material: material,
                              category: category,
                              subcategory: subcategory,
                              colors: colors,
                              storeOwner: storeOwner,
                              timeToBeCreated: timeToBeCreated,
                              images: galleryImages.map((image) => image.path).toList(), // Gallery image paths
                              thumbnail: thumbnailImage?.path ?? '', // Thumbnail image path
                              stock: stock,
                            );

                            // Call the Cubit to add the product
                            context.read<ProductCubit>().addProduct(product, storeOwner, File(thumbnailImage!.path), galleryImages.map((image) => File(image.path)).toList());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Store details not loaded.')),
                            );
                          }
                        }
                      },
                      child: BlocBuilder<ProductCubit, ProductState>(
                        builder: (context, state) {
                          if (state is ProductLoading) {
                            return CircularProgressIndicator();
                          }
                          return Text('Add Product');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}