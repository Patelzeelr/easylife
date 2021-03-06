import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/style/app_style.dart';

Widget dairyCard(Function()? onTap,QueryDocumentSnapshot doc){
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppStyle.cardColor[doc['color_id']],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(doc["note_title"],style: AppStyle.mainTitle),
          const SizedBox(height: 8.0),
          Text(doc["note_content"],style: AppStyle.mainContent,overflow: TextOverflow.ellipsis),
        ],
      ),
    ),
  );
}