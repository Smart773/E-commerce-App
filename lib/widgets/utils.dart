import 'package:flutter/material.dart';

class AppSpaceH20 extends StatelessWidget {
  const AppSpaceH20({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 20);
  }
}

class AppSpaceW20 extends StatelessWidget {
  const AppSpaceW20({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: 20);
  }
}

Future<dynamic> YNDialog(
    BuildContext context,
    String heading1,
    String subheading,
    Function() onPressedN,
    String noptionLable,
    Function() onPressedY,
    String yoptionLable) {
  return showDialog(
      context: context,
      builder: (contextx) {
        return AlertDialog(
          title: Text(heading1),
          content: Text(subheading),
          actions: [
            TextButton(onPressed: onPressedN, child: Text(noptionLable)),
            TextButton(onPressed: onPressedY, child: Text(yoptionLable)),
          ],
        );
      });
}
class DataWidget1 extends StatelessWidget {
  const DataWidget1({
    Key? key,
    required this.d1,
    required this.d2,
  }) : super(key: key);

  final String d1;
  final String d2;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          d1,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          d2,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 13.5,
          ),
        )
      ],
    );
  }
}

class DataWidget extends StatelessWidget {
  const DataWidget({
    Key? key,
    required this.d1,
    required this.d2,
  }) : super(key: key);

  final String d1;
  final String d2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          d1,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          d2,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 13.5,
          ),
        ),
      ],
    );
  }
}
