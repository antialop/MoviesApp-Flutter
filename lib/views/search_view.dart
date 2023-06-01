import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 22, 22, 22),
      body: Center(
        child: Text(
          'Esto es la vista de busqueda',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
