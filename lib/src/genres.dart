import 'dart:convert';

class Genres {
  int id;
  String name;

  Genres.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}

List<Genres> parseGenres(String jsonStr) {
  List<Genres> genres = [];

  var resultados = jsonDecode(jsonStr);

  for (var i = 0; i < resultados.length; i++) {
    print('genres: ${resultados[i]}');
    genres.add(Genres.fromJson(resultados[i]));
  }

  print(genres);

  return genres;
}

Genres parseGenre(String jsonStr) {
  var resultados = jsonDecode(jsonStr);
  return Genres.fromJson(resultados);
}
