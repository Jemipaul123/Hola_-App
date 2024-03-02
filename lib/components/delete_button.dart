//since ontap button we need gesture detector

import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final void Function()? onTap;
  const DeleteButton({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: const Icon(
          Icons.cancel,
          color: Colors.grey,
        ),
      ),
    );
  }
}
