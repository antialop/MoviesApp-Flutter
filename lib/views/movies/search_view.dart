import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies/search/search_delegate.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 22, 22, 22),
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text('Movies', style: GoogleFonts.bebasNeue(fontSize: 24)),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: MovieSearchDelegate());
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: const [
              Icon(
                Icons.movie_creation_outlined,
                size: 130,
                color: Colors.white,
              ),
            ],
          ),
        ));
  }
}
