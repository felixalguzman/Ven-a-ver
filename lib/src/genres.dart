import 'dart:convert';

class Genres {
  int? id;
  String? name;

  Genres.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  static String generos = """{
  "genres": [
    {
      "id": 28,
      "name": "Action"
    },
    {
      "id": 12,
      "name": "Adventure"
    },
    {
      "id": 16,
      "name": "Animation"
    },
    {
      "id": 35,
      "name": "Comedy"
    },
    {
      "id": 80,
      "name": "Crime"
    },
    {
      "id": 99,
      "name": "Documentary"
    },
    {
      "id": 18,
      "name": "Drama"
    },
    {
      "id": 10751,
      "name": "Family"
    },
    {
      "id": 14,
      "name": "Fantasy"
    },
    {
      "id": 36,
      "name": "History"
    },
    {
      "id": 27,
      "name": "Horror"
    },
    {
      "id": 10402,
      "name": "Music"
    },
    {
      "id": 9648,
      "name": "Mystery"
    },
    {
      "id": 10749,
      "name": "Romance"
    },
    {
      "id": 878,
      "name": "Science Fiction"
    },
    {
      "id": 10770,
      "name": "TV Movie"
    },
    {
      "id": 53,
      "name": "Thriller"
    },
    {
      "id": 10752,
      "name": "War"
    },
    {
      "id": 37,
      "name": "Western"
    }
  ]
}""";
}

List<Genres> parseGenres(var jsonStr) {
  List<Genres> genres = [];

//  var resultados = jsonDecode(jsonStr);
//  print('res: $jsonStr');

  var generos = jsonDecode(Genres.generos);
  var salida = generos['genres'];

  for (var i = 0; i < salida.length; i++) {
    for (var j = 0; j < jsonStr.length; j++) {
//      print('ids: ${salida[i]['id']}');
      if (salida[i]['id'] == jsonStr[j]) {
//        print('genero: ${salida[i]}');
        genres.add(Genres.fromJson(salida[i]));
      }
    }
//    if (generos[i]) {}

//    genres.add(Genres.fromJson(resultados[i]));
  }

//  print(genres);

  return genres;
}

Genres parseGenre(String jsonStr) {
  var resultados = jsonDecode(jsonStr);
  return Genres.fromJson(resultados);
}
