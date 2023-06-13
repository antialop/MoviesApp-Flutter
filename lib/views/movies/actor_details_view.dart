import 'package:flutter/material.dart';
import 'package:movies/models/actor_response.dart';
import 'package:movies/service/api/movies_provider.dart';

class ActorDetails extends StatefulWidget {
  final ActorResponse actor;

  const ActorDetails(this.actor, {Key? key}) : super(key: key);

  @override
  State<ActorDetails> createState() => _ActorDetailsState();
}

class _ActorDetailsState extends State<ActorDetails> {
  final MoviesProvider _moviesProvider = MoviesProvider();
  late Future<ActorResponse> _actorDetailsFuture;

  @override
  void initState() {
    super.initState();
    _actorDetailsFuture = _moviesProvider.getDetailsCast(widget.actor.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 22, 22, 22),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<ActorResponse>(
        future: _actorDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading actor details'),
            );
          }

          final ActorResponse actor = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          width: 130,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                          ),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/no-image.jpg',
                            image: actor.fullProfilePath ?? '',
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/no-image.jpg');
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 50),
                              child: Text(
                                actor.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              actor.placeOfBirth,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              actor.knownForDepartment,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Text(
                      actor.biography,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),               
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

