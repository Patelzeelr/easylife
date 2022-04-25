import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:take_notes/src/style/app_style.dart';

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
          const SizedBox(height: 4.0),
          Text(doc["creation_date"], style: AppStyle.dateTitle),
          const SizedBox(height: 8.0),
          doc["image"] == ""
              ? const Text(" ")
              : Expanded(
                  child: Image(
                  image: NetworkImage(doc["image"]),
                  height: 100.0,
                )),
          Text(doc["note_content"],
              style: AppStyle.mainContent, overflow: TextOverflow.ellipsis),
          Expanded(
            child: Container(
              height: 300,
              child: ListView.builder(
                itemCount: doc["list"].length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(doc["list"][index],
                        style: AppStyle.mainContent),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
