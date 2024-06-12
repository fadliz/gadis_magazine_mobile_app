import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final ImageProvider<Object>? image;

  const CustomAppBar({super.key, this.title, this.image});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xfffd507e),
      flexibleSpace: FlexibleSpaceBar(
        title: title!= null
       ? Text(
              title!,
              style: const TextStyle(fontFamily: 'Rubik', fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            )
          : Image(
              image: image?? const AssetImage('assets/icons/logo.png'),
              height: kToolbarHeight/1.5,
              fit: BoxFit.cover,
            ),
        centerTitle: true,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(92.0);
}