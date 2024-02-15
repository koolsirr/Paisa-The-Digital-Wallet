

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import 'image_picker_class.dart';

// void imagePickerModal(BuildContext context,
//     {VoidCallback? onCameraTap, VoidCallback? onGalleryTap}) {
//   showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.all(20),
//           height: 220,
//           child: Column(
//             children: [
//               GestureDetector(
//                 onTap: onCameraTap,
//                 child: Card(
//                   child: Container(
//                     alignment: Alignment.center,
//                     padding: const EdgeInsets.all(15),
//                     decoration: const BoxDecoration(color: Colors.grey),
//                     child: const Text("Camera11223",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 20)),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               GestureDetector(
//                 onTap: onGalleryTap,
//                 child: Card(
//                   child: Container(
//                     alignment: Alignment.center,
//                     padding: const EdgeInsets.all(15),
//                     decoration: const BoxDecoration(color: Colors.grey),
//                     child: const Text("Gallery",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 20)),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       });
// }
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
