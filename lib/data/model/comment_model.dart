// ignore_for_file: non_constant_identifier_names

import 'package:admin_hrm/constants/enum.dart';
import 'package:admin_hrm/utils/helpers/helper_functions.dart';

class CommentModel {
  int id;
  String content;
  CommentStatus status;
  DateTime createAt;
  DateTime updateAt;
  int user_id;
  int blog_id;

  CommentModel({
    required this.id,
    required this.content,
    required this.status,
    required this.createAt,
    required this.updateAt,
    required this.user_id,
    required this.blog_id,
  });

  String get formattedCreateAt => THelperFunctions.getFormattedDate(createAt);
  String get formattedUpdateAt => THelperFunctions.getFormattedDate(updateAt!);
  String get orderStatusText => status == CommentStatus.pending
      ? 'Pending'
      : status == CommentStatus.approved
          ? 'Approved'
          : status == CommentStatus.spam
              ? 'Spam'
              : status == CommentStatus.deleted
                  ? 'Deleted'
                  : '';
}

class CommentData {
  static final List<CommentModel> comments = [
    CommentModel(
      id: 1,
      content: 'This is a comment',
      status: CommentStatus.pending,
      createAt: DateTime.now(),
      updateAt: DateTime.now(),
      user_id: 1,
      blog_id: 1,
    ),
    CommentModel(
      id: 2,
      content: 'This is another comment',
      status: CommentStatus.approved,
      createAt: DateTime.now(),
      updateAt: DateTime.now(),
      user_id: 2,
      blog_id: 1,
    ),
    CommentModel(
      id: 3,
      content: 'This is a spam comment',
      status: CommentStatus.spam,
      createAt: DateTime.now(),
      updateAt: DateTime.now(),
      user_id: 3,
      blog_id: 2,
    ),
    CommentModel(
      id: 4,
      content: 'This comment has been deleted',
      status: CommentStatus.deleted,
      createAt: DateTime.now(),
      updateAt: DateTime.now(),
      blog_id: 2,
      user_id: 4,
    ),
    CommentModel(
      id: 5,
      content: 'This is a comment',
      status: CommentStatus.pending,
      createAt: DateTime.now(),
      updateAt: DateTime.now(),
      user_id: 1,
      blog_id: 1,
    ),
    CommentModel(
      id: 6,
      content: 'This is another comment',
      status: CommentStatus.approved,
      createAt: DateTime.now(),
      updateAt: DateTime.now(),
      user_id: 2,
      blog_id: 1,
    ),
    CommentModel(
      id: 7,
      content: 'This is a spam comment',
      status: CommentStatus.spam,
      createAt: DateTime.now(),
      updateAt: DateTime.now(),
      user_id: 3,
      blog_id: 2,
    ),
    CommentModel(
      id: 8,
      content: 'This comment has been deleted',
      status: CommentStatus.deleted,
      createAt: DateTime.now(),
      updateAt: DateTime.now(),
      blog_id: 2,
      user_id: 4,
    ),
    CommentModel(
      id: 9,
      content: 'This is a comment',
      status: CommentStatus.pending,
      createAt: DateTime.now(),
      updateAt: DateTime.now(),
      user_id: 1,
      blog_id: 1,
    ),
    CommentModel(
      id: 10,
      content: 'This is another comment',
      status: CommentStatus.approved,
      createAt: DateTime.now(),
      updateAt: DateTime.now(),
      user_id: 2,
      blog_id: 1,
    ),
    CommentModel(
      id: 11,
      content: 'This is a spam comment',
      status: CommentStatus.spam,
      createAt: DateTime.now(),
      updateAt: DateTime.now(),
      user_id: 3,
      blog_id: 2,
    ),
    CommentModel(
      id: 12,
      content: 'This comment has been deleted',
      status: CommentStatus.deleted,
      createAt: DateTime.now(),
      updateAt: DateTime.now(),
      blog_id: 2,
      user_id: 4,
    ),
  ];
}
