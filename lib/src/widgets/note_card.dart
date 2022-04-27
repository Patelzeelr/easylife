import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/style/app_style.dart';

Widget noteCard(Function()? onTap, QueryDocumentSnapshot doc) {
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
          Text(doc["note_title"], style: AppStyle.mainTitle),
          const Padding(padding: EdgeInsets.only(bottom: 4.0)),
          Text(doc["creation_date"], style: AppStyle.dateTitle),
          const Padding(padding: EdgeInsets.only(bottom: 8.0)),
          doc["image"] == ""
              ? const Text(" ")
              : Expanded(
                child: Image(
                image: NetworkImage(doc["image"]),
                height: 100.0,
                  ),
              ),
          const Padding(padding: EdgeInsets.only(bottom: 8.0)),
          Text(doc["note_content"],
              style: AppStyle.mainContent, overflow: TextOverflow.ellipsis),
        ],
      ),
    ),
  );
}
