import 'package:flutter/material.dart';
import 'package:hng_mobile/main.dart';
import 'package:hng_mobile/utils/sql_helper.dart';

class ShoppinglistScreen extends StatefulWidget {
  const ShoppinglistScreen({super.key, required this.list});

  final ShoppingListModel list;

  @override
  State<ShoppinglistScreen> createState() => _ShoppinglistScreenState();
}

class _ShoppinglistScreenState extends State<ShoppinglistScreen> {
  final TextEditingController itemController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  @override
  void dispose() {
    itemController.dispose();
    priceController.dispose();
    quantityController.dispose();
    unitController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.list.title ?? ''),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ActionChip(
              label: const Text("Delete list"),
              onPressed: () {
                shoppingHelper!.deleteShoppingList(widget.list.id!);
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: shoppingHelper!.getShoppingItems(widget.list.id!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                } else {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("items (${snapshot.data!.length})"),
                          RichText(
                            text: TextSpan(
                              text: "Total: ",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                              children: [
                                const TextSpan(text: ' \$'),
                                TextSpan(
                                    text: getSum(snapshot.data!).toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          )
                        ],
                      ),
                      TextField(
                        controller: itemController,
                        decoration: const InputDecoration(hintText: "Add Item"),
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            shoppingHelper!.insertShoppingItem(
                              ShoppingItemModel(
                                listId: widget.list.id,
                                title: value,
                                quantity: 0,
                                unit: '',
                                price: 0,
                                done: false,
                              ),
                            );
                            setState(() {
                              itemController.clear();
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 15),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: snapshot.data![index].title,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                          children: [
                                            const TextSpan(text: ' | '),
                                            TextSpan(
                                                text: snapshot
                                                    .data![index].quantity
                                                    .toString()),
                                            TextSpan(
                                                text:
                                                    " ${snapshot.data![index].unit}"),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "\$${snapshot.data![index].price}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () async {
                                      snapshot.data![index].done =
                                          !(snapshot.data![index].done!);
                                      snapshot.data![index].listId =
                                          widget.list.id;
                                      await shoppingHelper?.updateShoppingItem(
                                          snapshot.data![index]);
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Icons.check,
                                      color: (snapshot.data![index].done !=
                                                  null &&
                                              snapshot.data![index].done ==
                                                  false)
                                          ? Colors.black
                                          : (snapshot.data![index].done !=
                                                      null &&
                                                  snapshot.data![index].done ==
                                                      true)
                                              ? Colors.red
                                              : Colors.black,
                                      weight: 5,
                                      fill: 0.9,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      priceController.text = snapshot
                                          .data![index].price
                                          .toString();
                                      quantityController.text = snapshot
                                          .data![index].quantity
                                          .toString();
                                      unitController.text =
                                          snapshot.data![index].unit.toString();
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                                snapshot.data![index].title ??
                                                    ""),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller: priceController,
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText:
                                                              "Enter Quanty"),
                                                ),
                                                TextField(
                                                  controller:
                                                      quantityController,
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText:
                                                              "Enter Price"),
                                                ),
                                                TextField(
                                                  controller: unitController,
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText:
                                                              "Enter Unit"),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Cancel")),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    snapshot.data![index]
                                                            .quantity =
                                                        double.parse(
                                                            quantityController
                                                                .text);
                                                    snapshot.data![index].unit =
                                                        unitController.text;
                                                    snapshot.data![index]
                                                            .price =
                                                        double.parse(
                                                            priceController
                                                                .text);
                                                    snapshot.data![index]
                                                            .listId =
                                                        widget.list.id;
                                                    shoppingHelper
                                                        ?.updateShoppingItem(
                                                            snapshot
                                                                .data![index]);

                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  },
                                                  child: const Text('Save'))
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.more_vert),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        shoppingHelper?.deleteShoppingItem(
                                            snapshot.data![index].id!);
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.delete))
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}

getSum(List<ShoppingItemModel> items) {
  double sum = 0;
  for (ShoppingItemModel item in items) {
    sum += item.price ?? 0;
  }
  return sum;
}
