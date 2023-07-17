import 'package:flutter/material.dart';
import 'package:todo_app/model/todo_task.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({super.key, required this.onSaveCategory});

  final Function(Category) onSaveCategory;
  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  Category selectedCategory = Category.call;

  List<Padding> buildCategoryChips(
      Category selectedCategory, Function(Category) onCategorySelected) {
    List<Padding> chips = [];

    for (Category category in Category.values) {
      String firstName = category.name[0].toUpperCase();
      String categoryName = firstName + category.name.substring(1);
      chips.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
          child: ChoiceChip(
            selectedColor: Colors.blue,
            side: const BorderSide(color: Colors.blue),
            padding: const EdgeInsets.all(0),
            label: Text(categoryName),
            labelStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color:
                    selectedCategory == category ? Colors.white : Colors.blue),
            selected: selectedCategory == category,
            onSelected: (selected) {
              if (selected) {
                onCategorySelected(category);
              }
            },
          ),
        ),
      );
    }

    return chips;
  }

  void onCategorySelected(Category category) {
    setState(() {
      selectedCategory = category;
      widget.onSaveCategory(selectedCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        children: buildCategoryChips(selectedCategory, onCategorySelected),
      ),
    );
  }
}
