import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../items_feature/item_details_page.dart';
import '../items_feature/new_item_page.dart';
import '../models/item_model.dart';
import '../widgets/item_button.dart';
import '../widgets/todo_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Previously, we use a `List` of `String`.
  /// This time, we're using a list of `ItemModel`.
  /// `ItemModel` is a Dart object class we created.

  /// This is the `List` we use for storing
  /// locally in the memory using setState();
  /// List<ItemModel> todoItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      backgroundColor: Colors.black87,
      body: Center(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: FutureBuilder<Box>(
                  future: Hive.openBox('todo_items'),
                  builder: (context, todoBox) {
                    if (todoBox.data != null) {
                      final items =
                          List<Map<String, dynamic>>.from(todoBox.data!.values)
                              .map((e) => ItemModel.fromJson(e))
                              .toList();
                      return ValueListenableBuilder(
                        valueListenable: todoBox.data!.listenable(),
                        builder: (context, box, widget) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              for (int i = 0; i < items.length; i++)
                                TodoItem(
                                  title: items[i].title,
                                  description: items[i].description,
                                  date: items[i].date,
                                  onItemPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) {
                                        return ItemDetailsPage(
                                          id: i,
                                          itemModel: items[i],
                                          onItemDeleted: () {
                                            setState(() {
                                              final box =
                                                  Hive.box('todo_items');

                                              box.deleteAt(i);
                                            });
                                          },
                                        );
                                      }),
                                    ).then((value) => null);
                                  },
                                )
                            ],
                          );
                        },
                      );
                    }

                    return const Center(
                      child: Text('No items found.'),
                    );
                  }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ItemButton(
                title: 'New Item',
                color: Colors.green,
                onItemPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) {
                      return const NewItemPage(
                        itemModel: null,
                        itemPageMode: ItemPageMode.add,
                      );
                    }),
                  ).then((value) {
                    /// This checks if the value from the
                    /// previous route is an instance of
                    /// `ItemModel`. If so, read
                    /// the value accordingly.
                    if (value is ItemModel) {
                      /// `setState` notifies the Flutter
                      /// to rebuild the UI
                      setState(() {
                        final todoBox = Hive.box('todo_items');
                        todoBox.add(value.toMap());
                      });
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
