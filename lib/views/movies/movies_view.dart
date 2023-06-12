import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies/views/movies/home_view.dart';
import 'package:movies/views/movies/profile_view.dart';
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
    const WatchlistView(),
    const ProfileView()
  ];
  final List<bool> showAppBar = [true, false, true, true];

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final bool shouldShowAppBar = showAppBar[currentPageIndex];

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: shouldShowAppBar
              ? AppBar(
                  backgroundColor: Colors.red,
                  title: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('Movies',
                        style: GoogleFonts.bebasNeue(fontSize: 24)),
                  ),
                )
              : null,
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentPageIndex,
            onTap: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Icon(Icons.home),
                ),
                label: '',
                backgroundColor: Colors.black,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Icon(Icons.search),
                ),
                label: '',
                backgroundColor: Colors.black,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Icon(Icons.bookmark_border),
                ),
                label: '',
                backgroundColor: Colors.black,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Icon(Icons.account_circle),
                ),
                label: '',
                backgroundColor: Colors.black,
              ),
            ],
            selectedItemColor: Colors.red, 
            unselectedItemColor: Colors.white,
          ),
          body: IndexedStack(
            index: currentPageIndex,
            children: pages,
          ),
        );
      },
    );
  }
}
