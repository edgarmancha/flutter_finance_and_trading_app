import 'package:flutter/material.dart';
import '../auth/wp_api.dart';

class NewsPostTile extends StatelessWidget {
  final Post post;

  NewsPostTile({required this.post});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(post.imageUrl),
      title: Text(post.title),
      subtitle: Text(post.excerpt),
      trailing: Text(post.date),
      onTap: () {
        // Navigate to post detail page
      },
    );
  }
}
