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
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('IMAGE'),
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
                        title: 'an image of a food or snack',
                      ),
                    ),
              const SizedBox(height: 12),
              const Text('PRODUCT NAME'),
              const SizedBox(height: 8),
              TextField(
                controller: productNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  hintText: 'Enter product name',
                ),
              ),
              const SizedBox(height: 12),
              const Text('DESCRIPTION'),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                maxLength: 60,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  hintText: 'Enter product description (max 50 characters)',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('PRICE'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            hintText: 'Enter price',
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
                        const Text('QUANTITY'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            hintText: 'Enter quantity',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 65,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: () async {
                final productName = productNameController.text.trim();
                final description = descriptionController.text.trim();
                final price = double.parse(priceController.text.trim()) ?? 0.0;
                final quantity =
                    double.parse(quantityController.text.trim()) ?? 0.0;

                await shoppingHelper?.insertProductList(ProductModel(
                  title: productName,
                  description: description,
                  quantity: quantity,
                  price: price,
                  imagePath: selectedFile?.path,
                ));

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Product added successfully!')),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Add Product'),
            ),
          ),
        ),
      ),
    );
  }
}
