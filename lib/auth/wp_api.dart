import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://affinitymarkets.co.uk/wp-json';

//   Future<List<Post>> fetchPosts({required String categoryId}) async {
//     try {
//       final response = await http.get(Uri.parse(
//           '$baseUrl/wp/v2/posts?_embed&categories=$categoryId&per_page=10'));

//       print('Response status code: ${response.statusCode}');
//       print('Response body: ${response.body}');

//       if (response.statusCode == 200) {
//         List jsonResponse = json.decode(response.body);
//         return jsonResponse.map((post) => Post.fromJson(post)).toList();
//       } else {
//         throw Exception('Failed to load news posts');
//       }
//     } catch (e) {
//       print('Error: $e');
//       throw Exception('Failed to load news posts');
//     }
//   }
// }
  Future<List<Post>> fetchPosts({required int categoryId}) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/wp/v2/posts?_embed&categories=$categoryId&per_page=10'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load news posts');
    }
  }
}

class Post {
  final int id;
  final String title;
  final String content;
  final String excerpt;
  final String imageUrl;
  final String date;
  final String category;

  Post(
      {required this.id,
      required this.title,
      required this.content,
      required this.excerpt,
      required this.imageUrl,
      required this.date,
      required this.category});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title']['rendered'],
      content: json['content']['rendered'],
      excerpt: json['excerpt']['rendered'],
      imageUrl: json['_embedded']['wp:featuredmedia'][0]['source_url'],
      date: json['date'],
      category: json['_embedded']['wp:term'][0][0]['name'],
    );
  }
}
