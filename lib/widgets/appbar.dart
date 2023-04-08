import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../utils.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? centerImage;
  final Color? backgroundColor;
  final double? elevation;

  const MyAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.centerImage,
    this.backgroundColor,
    this.elevation,
  });

  Future<String> _getCurrentUserId() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    return currentUser?.uid ?? '';
  }

  Future<String> _getProfilePictureUrl(String userId) async {
    if (userId.isEmpty) return '';
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (!userDoc.exists) return ''; // Check if the document exists
    return userDoc['profilePictureUrl'] ?? '';
  }

  Widget _buildProfilePicture(BuildContext context, String profilePictureUrl) {
    return profilePictureUrl.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: profilePictureUrl,
            imageBuilder: (context, imageProvider) => Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: GlobalColors.primaryColor,
                    width: 1.0,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: imageProvider,
                  radius: 17,
                ),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )
        : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation ?? 0,
      backgroundColor: backgroundColor ?? GlobalColors.primaryColor,
      leading: const Padding(
          padding: EdgeInsets.all(8.0), child: Icon(Icons.account_circle)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title!,
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              height: 1.5,
              color: GlobalColors.whiteAcc.withOpacity(0.8),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          tooltip: 'Edit',
          onPressed: () {
            // handle the press
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
