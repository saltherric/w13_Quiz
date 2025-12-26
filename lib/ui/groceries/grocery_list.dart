import 'package:flutter/material.dart';
import '../../data/mock_grocery_repository.dart';
import '../../models/grocery.dart';
import 'grocery_form.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  int _selectedIndex = 0;
  String searchItem = '';

  void onCreate() async {
    // Navigate to the form screen using the Navigator push
    Grocery? newGrocery = await Navigator.push<Grocery>(
      context,
      MaterialPageRoute(builder: (context) => const GroceryForm()),
    );
    if (newGrocery != null) {
      setState(() {
        dummyGroceryItems.add(newGrocery);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_selectedIndex == 0) {
        content = ListView.builder(
          itemCount: dummyGroceryItems.length,
          itemBuilder: (context, index) =>
            GroceryTile(grocery: dummyGroceryItems[index]),
        );
    } else {
      String search = searchItem.trim();

      final filterItem = dummyGroceryItems.where(
        (item) => 
          item.name.toLowerCase().startsWith(search.toLowerCase()),
      ).toList();

      if (filterItem.isEmpty) {
        content = const Center(child: Text('Items not found.'));
      } else {
        content = ListView.builder(
          itemCount: filterItem.length,
          itemBuilder: (context, index) =>
            GroceryTile(grocery: filterItem[index]),
        );
      }

      content = Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchItem = value;
                });
              },
            ),
          ),
          Expanded(child: content),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: onCreate, icon: const Icon(Icons.add))],
      ),
      body: content,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store),
            label: 'Groceries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search), 
            label: 'Search',
          ),
        ],
      ),
    );
  }
}

class GroceryTile extends StatelessWidget {
  const GroceryTile({super.key, required this.grocery});

  final Grocery grocery;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(width: 15, height: 15, color: grocery.category.color),
      title: Text(grocery.name),
      trailing: Text(grocery.quantity.toString()),
    );
  }
}
