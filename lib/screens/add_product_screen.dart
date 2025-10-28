import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hng_mobile/core/constants/app_color.dart';
import 'package:hng_mobile/core/extensions/format_to_mb.dart';
import 'package:hng_mobile/infrastructure/image_upload_controller.dart';
import 'package:hng_mobile/main.dart';
import 'package:hng_mobile/utils/sql_helper.dart';
import '../core/widgets/image_previewer.dart';
import '../core/widgets/upload_container.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  File? selectedFile;
  Completer? completer;
  String? fileName;
  int? fileSize;

  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  void dispose() {
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Add Product',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Product Image'),
            const SizedBox(height: 8),
            selectedFile != null
                ? ImagePreviewer(
                    size: size,
                    pickedFile: selectedFile,
                    removeFile: removeFile,
                    context: context,
                    completer: completer,
                    setFile: setFile,
                  )
                : GestureDetector(
                    onTap: () {
                      ImageUploadController.showFilePickerButtomSheet(
                          context, completer, setFile);
                    },
                    child: UploadContainer(
                      size: size,
                      title: 'Tap to upload product image',
                    ),
                  ),
            const SizedBox(height: 20),
            _sectionTitle('Product Details'),
            const SizedBox(height: 8),
            _inputCard(
              child: Column(
                children: [
                  _buildInputField('Product Name', productNameController,
                      hint: 'Enter product name'),
                  const SizedBox(height: 12),
                  _buildInputField(
                    'Description',
                    descriptionController,
                    hint: 'Enter short description',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField('Price', priceController,
                            hint: '₦0.00', isNumber: true),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInputField('Quantity', quantityController,
                            hint: '0', isNumber: true),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ElevatedButton.icon(
            onPressed: () async {
              final productName = productNameController.text.trim();
              final description = descriptionController.text.trim();
              final price = double.tryParse(priceController.text.trim()) ?? 0.0;
              final quantity =
                  double.tryParse(quantityController.text.trim()) ?? 0.0;

              await shoppingHelper?.insertProductList(
                ProductModel(
                  title: productName,
                  description: description,
                  quantity: quantity,
                  price: price,
                  imagePath: selectedFile?.path,
                ),
              );

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product added successfully!')),
                );
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Product', style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    String? hint,
    int maxLines = 1,
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black87)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.primaryColor,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _inputCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
