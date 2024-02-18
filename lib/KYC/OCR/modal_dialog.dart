

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import 'image_picker_class.dart';

void imagePickerModal(BuildContext context,
    {VoidCallback? onCameraTap, VoidCallback? onGalleryTap}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Use Camera?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: onCameraTap,
              leading: Icon(Iconsax.tick_circle),
              title: Text("Yes"),
            ),

            const SizedBox(height: 10),
            // ListTile(
            //   onTap: onGalleryTap,
            //   leading: Icon(Iconsax.gallery),
            //   title: Text("Gallery"),
            // ),
          ],
        ),
      );
    },
  );
}
