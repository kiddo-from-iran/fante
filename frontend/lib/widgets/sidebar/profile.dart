import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  final VoidCallback onTap;

  const ProfileItem({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Profile',
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 56,
          alignment: Alignment.center,
          child: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue.shade200,
            child: const Icon(
              Icons.person,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
