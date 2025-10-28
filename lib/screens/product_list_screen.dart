import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hng_mobile/core/extensions/format_to_mb.dart';
import 'package:hng_mobile/infrastructure/image_upload_controller.dart';
import 'package:hng_mobile/screens/add_product_screen.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';

import '../core/constants/app_color.dart';
import '../core/widgets/image_previewer.dart';
import '../main.dart';
import '../utils/sql_helper.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<ProductModel>> _productFuture;

  File? selectedFile;
  Completer? completer;
  String? fileName;
  int? fileSize;

  @override
  void initState() {
    super.initState();
    _productFuture = shoppingHelper!.getProducts();
  }

  void setFile(File? pickedFile) {
    setState(() {
      selectedFile = pickedFile;
      if (pickedFile != null) {
        fileName = pickedFile.path.split('/').last;
        fileSize = pickedFile.lengthSync().formatToMegaByte();
      }
    });
  }

  void removeFile() {
    setState(() {
      selectedFile = null;
      fileSize = null;
    });
  }

  Future<void> _refreshProducts() async {
    final products = await shoppingHelper!.getProducts();
    setState(() {
      _productFuture = Future.value(products);
    });
  }

  void _showEditProductSheet(ProductModel product) {
    final nameController = TextEditingController(text: product.title ?? '');
    final descController =
        TextEditingController(text: product.description ?? '');
    final priceController =
        TextEditingController(text: product.price?.toString() ?? '');
    final quantityController =
        TextEditingController(text: product.quantity?.toString() ?? '');
    File? selectedFile =
        product.imagePath != null ? File(product.imagePath!) : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Edit Product',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Image section
                    GestureDetector(
                      onTap: () async {
                        ImageUploadController.showFilePickerButtomSheet(
                            context, completer, setFile);
                        // ImageUploadController.showFilePickerButtomSheet(
                        //   context,
                        //   null,
                        //   (pickedFile) {
                        //     setModalState(() {
                        //       selectedFile = pickedFile;
                        //     });
                        //   },
                        // );
                      },
                      child: selectedFile != null
                          // ? ClipRRect(
                          //     borderRadius: BorderRadius.circular(8),
                          //     child: Image.file(
                          //       selectedFile!,
                          //       height: 120,
                          //       width: double.infinity,
                          //       fit: BoxFit.cover,
                          //     ),
                          //   )
                          ? ImagePreviewer(
                              size: MediaQuery.sizeOf(context),
                              pickedFile: selectedFile,
                              removeFile: () {
                                setModalState(() {
                                  selectedFile = null;
                                });
                              },
                              context: context,
                              completer: completer,
                              setFile: (pickedFile) {
                                setModalState(() {
                                  selectedFile = pickedFile;
                                });
                              },
                            )
                          : Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[100],
                              ),
                              child: const Center(
                                child: Text('Tap to select image'),
                              ),
                            ),
                    ),

                    const SizedBox(height: 16),
                    const Text('Product Name'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('Description'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Price'),
                              const SizedBox(height: 8),
                              TextField(
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Quantity'),
                              const SizedBox(height: 8),
                              TextField(
                                controller: quantityController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Update button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final updatedProduct = ProductModel(
                            id: product.id,
                            title: nameController.text.trim(),
                            description: descController.text.trim(),
                            price:
                                double.tryParse(priceController.text.trim()) ??
                                    0.0,
                            quantity: double.tryParse(
                                    quantityController.text.trim()) ??
                                0.0,
                            imagePath: selectedFile?.path,
                          );

                          await shoppingHelper?.updateProduct(updatedProduct);

                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Product updated successfully!')),
                            );
                            _refreshProducts();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Update Product'),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Management App'),
        actions: [
          IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddProductScreen(),
                  ),
                );
                _refreshProducts();
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshProducts,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Product',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'List',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                    child: Text(loremIpsum(paragraphs: 1, words: 10)),
                  ),
                  FutureBuilder(
                      future: shoppingHelper?.getProducts(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('No products available.'),
                          );
                        } else {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                for (var product in snapshot.data!)
                                  ListTile(
                                    leading: product.imagePath != null
                                        ? Container(
                                            width: 55,
                                            height: 55,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Image.file(
                                                File(product.imagePath!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            width: 55,
                                            height: 55,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: const Icon(
                                                Icons.image_not_supported,
                                                color: Colors.grey),
                                          ),
                                    title: Text(product.title ?? 'No Title'),
                                    subtitle: Text(product.description ??
                                        'No Description'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              'Qty: ${product.quantity?.toStringAsFixed(0) ?? '0'}',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                        PopupMenuButton(
                                          icon: const Icon(Icons.more_vert),
                                          color: Colors.white,
                                          iconSize: 25,
                                          offset: const Offset(0,
                                              53), // This moves the menu down
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                12), // Rounded corners
                                          ),
                                          onSelected: (value) {
                                            if (value == 'edit-product') {
                                              _showEditProductSheet(product);
                                            } else if (value ==
                                                'delete-product') {
                                              shoppingHelper
                                                  ?.deleteProduct(product.id!);
                                              setState(() {});
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            const PopupMenuItem(
                                              value: 'edit-product',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.edit,
                                                      color: Colors.black),
                                                  SizedBox(width: 10),
                                                  Text('Edit Product'),
                                                ],
                                              ),
                                            ),
                                            const PopupMenuItem(
                                              value: 'delete-product',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.delete,
                                                      color: Colors.red),
                                                  SizedBox(width: 10),
                                                  Text('Delete Product',
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
