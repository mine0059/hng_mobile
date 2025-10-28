import 'package:flutter/material.dart';
import 'package:hng_mobile/main.dart';
import 'package:hng_mobile/screens/shoppingList_screen.dart';
import 'package:hng_mobile/utils/sql_helper.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';

class SqlHomeScreen extends StatefulWidget {
  const SqlHomeScreen({super.key});

  @override
  State<SqlHomeScreen> createState() => _SqlHomeScreenState();
}

class _SqlHomeScreenState extends State<SqlHomeScreen> {
  final TextEditingController titleController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shopping list app")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Shopping',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('List',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                  child: Text(loremIpsum(paragraphs: 1, words: 10)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('New List'),
                            content: TextField(controller: titleController),
                            actions: [
                              OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel")),
                              ElevatedButton(
                                  onPressed: () {
                                    if (titleController.text.isNotEmpty) {
                                      shoppingHelper?.insertShoppingList(
                                          ShoppingListModel(
                                              title: titleController.text));
                                    }

                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Save'))
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                    ),
                    child: const Text('Create new List'),
                  ),
                ),
                FutureBuilder(
                    future: shoppingHelper?.getShoppingLists(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      } else {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  title:
                                      Text(snapshot.data?[index].title ?? ""),
                                  trailing:
                                      const Icon(Icons.keyboard_arrow_right),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ShoppinglistScreen(
                                          list: snapshot.data![index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            });
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
