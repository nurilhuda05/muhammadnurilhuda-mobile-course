import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/models/post.dart';


class PostTile extends StatelessWidget {
  const PostTile({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            post.id.toString(),
          ),
        ),
        title: Text(
          post.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
  
        onTap: () => context.push('/post/${post.id}'),
      ),
    );
  }
}
