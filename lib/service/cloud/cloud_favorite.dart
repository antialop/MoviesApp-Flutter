import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies/service/cloud/cloud_constants.dart';

class CloudFavorite {
  final String documentId;
  final String ownerUserId;
  final int movieId;
  

  const CloudFavorite({
    required this.documentId,
    required this.ownerUserId,
    required this.movieId,
  });

  CloudFavorite.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName] as String,
        movieId = snapshot.data()[movieIdFieldName] as int;

  @override
String toString() {
    return  movieId.toString();
}      
}
