import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies/service/cloud/cloud_constants.dart';
import 'package:movies/service/cloud/cloud_favorite.dart';

class FirebaseCloudStorage {
  final favorites = FirebaseFirestore.instance.collection('favorites');

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._shareInstace();
  FirebaseCloudStorage._shareInstace();
  factory FirebaseCloudStorage() => _shared;

  Future<Iterable<CloudFavorite>> getFavoritesMovies(
      {required String ownerUserId}) async {
    try {
      return await favorites
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then((value) =>
              value.docs.map((doc) => CloudFavorite.fromSnapshot(doc)));
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<Iterable<CloudFavorite>> allFavorites({required String ownerUserId}) {
    final allFavorites = favorites
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => CloudFavorite.fromSnapshot(doc)));
    return allFavorites;
  }

  Future<void> deteleFavorite({required String documentId}) async {
    try {
      await favorites.doc(documentId).delete();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<CloudFavorite> newFavoriteMovie(
      {required String ownerUserId, required int movieId}) async {
    final document = await favorites.add({
      ownerUserIdFieldName: ownerUserId,
      movieIdFieldName: movieId,
    });

    final getFavorite = await document.get();
    return CloudFavorite(
      documentId: getFavorite.id,
      ownerUserId: ownerUserId,
      movieId: movieId,
    );
  }
}
