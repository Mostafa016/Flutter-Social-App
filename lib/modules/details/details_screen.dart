import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final String imageURL;

  const DetailsScreen({
    Key? key,
    required this.imageURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.8),
        body: Center(
          child: InteractiveViewer(
            child: Image.network(
              imageURL,
            ),
          ),
        ),
      ),
    );
  }
}
