import 'package:flutter/material.dart';
import 'package:note_app/utils/color_constants.dart';
import 'package:share_plus/share_plus.dart';

class NoteCard extends StatelessWidget {
  const NoteCard(
      {super.key,
      this.onDelete,
      required this.title,
      required this.desc,
      required this.date,
      this.isEdit,
      required this.noteColor});
  final void Function()? onDelete;
  final void Function()? isEdit;
  final String title;
  final String desc;
  final String date;
  final Color noteColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: noteColor, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                    color: ColorConstants.mainblack,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              IconButton(
                  onPressed: isEdit,
                  icon: Icon(Icons.edit, color: ColorConstants.mainblack)),
              IconButton(onPressed: onDelete, icon: Icon(Icons.delete)),
            ],
          ),
          Text(
            maxLines: 4,
            desc,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: ColorConstants.mainblack,
              fontSize: 18,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                date,
                style: TextStyle(
                    color: ColorConstants.mainblack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: () {
                    Share.share("$title \n$desc \n$date");
                  },
                  icon: Icon(Icons.share, color: ColorConstants.mainblack)),
            ],
          ),
        ],
      ),
    );
  }
}
