import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hng_mobile/infrastructure/image_upload_controller.dart';
import 'package:hng_mobile/screens/add_product_screen.dart';
import '../core/constants/app_color.dart';
import '../main.dart';
import '../utils/sql_helper.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<ProductModel>> _productFuture;
  Completer? completer;

  @override
  void initState() {
    super.initState();
    _productFuture = shoppingHelper!.getProducts();
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: StatefulBuilder(builder: (context, setModalState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Edit Product',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        ImageUploadController.showFilePickerButtomSheet(
                            context, completer, (pickedFile) {
                          setModalState(() {
                            selectedFile = pickedFile;
                          });
                        });
                      },
                      child: selectedFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                selectedFile!,
                                height: 140,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              height: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[100],
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: const Center(
                                  child: Text('Tap to select image')),
                            ),
                    ),
                    const SizedBox(height: 20),
                    _buildInputField('Product Name', nameController),
                    _buildInputField('Description', descController,
                        maxLines: 3),
                    Row(
                      children: [
                        Expanded(
                            child: _buildInputField('Price', priceController,
                                isNumber: true)),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _buildInputField(
                                'Quantity', quantityController,
                                isNumber: true)),
                      ],
                    ),
                    const SizedBox(height: 25),
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
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Update Product',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 20), // add bottom breathing space
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {int maxLines = 1, bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text('My Store'),
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          );
          _refreshProducts();
        },
        backgroundColor: AppColors.primaryColor,
        label: const Text('Add Product'),
        icon: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _productFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final products = snapshot.data!;
            if (products.isEmpty) {
              return const Center(child: Text('No products yet.'));
            }
            return RefreshIndicator(
              onRefresh: _refreshProducts,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: product.imagePath != null
                            ? Image.file(File(product.imagePath!),
                                width: 60, height: 60, fit: BoxFit.cover)
                            : Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[200],
                                child: const Icon(Icons.image_not_supported,
                                    color: Colors.grey),
                              ),
                      ),
                      title: Text(
                        product.title ?? 'No Title',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text(
                        product.description ?? 'No description',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Qty: ${product.quantity?.toInt() ?? 0}',
                              style: const TextStyle(color: Colors.grey)),
                          Flexible(
                            child: PopupMenuButton(
                              icon: const Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: const Text('Edit'),
                                  onTap: () =>
                                      Future.delayed(Duration.zero, () {
                                    _showEditProductSheet(product);
                                  }),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: const Text('Delete',
                                      style: TextStyle(color: Colors.red)),
                                  onTap: () async {
                                    await shoppingHelper
                                        ?.deleteProduct(product.id!);
                                    _refreshProducts();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
