import 'package:flutter/material.dart';


class WatchlistView extends StatefulWidget {
  const WatchlistView({super.key});

  @override
  State<WatchlistView> createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView> {
  @override
  Widget build(BuildContext context) {
  return const Center(
      child: Text(
        'Esto es la vista de favoritos',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }
}