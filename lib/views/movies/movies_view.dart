import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies/service/auth/bloc/auth_bloc.dart';
import 'package:movies/service/auth/bloc/auth_events.dart';
import 'package:movies/utilities/dialogs/logout_dialog.dart';
import 'package:movies/views/movies/home_view.dart';
import 'package:movies/views/movies/search_view.dart';
import 'package:movies/views/movies/watchlist_view.dart';

class MoviesView extends StatefulWidget {
  const MoviesView({super.key});

  @override
  State<MoviesView> createState() => _MoviesViewState();
}

class _MoviesViewState extends State<MoviesView> {
  int currentPageIndex = 0;
  final List<Widget> pages = [
    const HomeView(),
    const SearchView(),
    const WatchlistView()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text('Movies', style: GoogleFonts.bebasNeue(fontSize: 24)),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final shouldLogout = await showLogOutDialog(context);
              if (shouldLogout) {
                // ignore: use_build_context_synchronously
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          currentIndex: currentPageIndex,
          onTap: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(Icons.home, color: Colors.red),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(Icons.search, color: Colors.red),
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(Icons.bookmark_border, color: Colors.red),
              ),
              label: 'Watchlist',
            ),
          ],
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.white,
        ),
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: pages,
      ),
    );
  }
}
