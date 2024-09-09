import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:note_app/dummy_db.dart';
import 'package:note_app/utils/app_sessions.dart';
import 'package:note_app/utils/color_constants.dart';
import 'package:note_app/view/notes_screen/widgets/note_card.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  TextEditingController DateController = TextEditingController();
  int selectedcolorIndex = 0;
  // STEP 2
  var noteBox = Hive.box(AppSessions.NOTEBOX);
  List noteKeys = [];
  @override
  void initState() {
    noteKeys = noteBox.keys.toList();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: ColorConstants.netgrey,
            onPressed: () {
              // To clear the controllers before opening the bottom sheet again.
              titleController.clear();
              DescriptionController.clear();
              DateController.clear();
              selectedcolorIndex = 0;
              customBottomSheet(context);
            },
            child: Icon(
              Icons.add,
              color: ColorConstants.mainwhite,
            )),
        body: ListView.separated(
            padding: EdgeInsets.all(15),
            itemBuilder: (context, index) {
              var currentNote = noteBox.get(noteKeys[index]);
              return NoteCard(
                noteColor: DummyDb
                    .noteColors[noteBox.get(noteKeys[index])["colorIndex"]],
                date: currentNote["date"],
                desc: currentNote["desc"],
                title: currentNote["title"],
                // for deletion
                onDelete: () {
                  noteBox.delete(noteKeys[index]);
                  noteKeys = noteBox.keys.toList();
                  setState(() {});
                },
                // for editing
                isEdit: () {
                  titleController.text = currentNote["date"];
                  titleController.text = currentNote["desc"];
                  titleController.text = currentNote["title"];
                  selectedcolorIndex = currentNote["colorIndex"];
                  //titleController = TextEditingController(text: DummyDb.notesList[index]["title"]);
                  customBottomSheet(context, isEdit: true, itemIndex: index);
                },
              );
            },
            separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
            itemCount: noteKeys.length),
      ),
    );
  }

  Future<dynamic> customBottomSheet(BuildContext context,
      {bool isEdit = false, int? itemIndex}) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => Padding(
              padding: const EdgeInsets.all(20),
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                          hintText: "Title",
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: DescriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                          hintText: "Description",
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      readOnly: true,
                      controller: DateController,
                      decoration: InputDecoration(
                          hintText: "Date",
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          suffixIcon: IconButton(
                              onPressed: () async {
                                var selectedDate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(2024),
                                  lastDate: DateTime.now(),
                                );
                                if (selectedDate != null) {
                                  DateController.text =
                                      DateFormat("yMMMMd").format(selectedDate);
                                }
                              },
                              icon: Icon(Icons.calendar_month_outlined))),
                    ),
                    SizedBox(height: 20),
                    //Build color section
                    StatefulBuilder(
                      builder: (context, setState) => Row(
                        children: List.generate(
                          DummyDb.noteColors.length,
                          (index) => Expanded(
                            child: InkWell(
                              onTap: () {
                                selectedcolorIndex = index;
                                setState(() {});
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                height: 50,
                                decoration: BoxDecoration(
                                    border: selectedcolorIndex == index
                                        ? Border.all(width: 3)
                                        : null,
                                    borderRadius: BorderRadius.circular(10),
                                    color: DummyDb.noteColors[index]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: ColorConstants.primaryRed,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "cancel",
                                style:
                                    TextStyle(color: ColorConstants.mainwhite),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (isEdit == true) {
                                noteBox.put(noteKeys[itemIndex!], {
                                  "title": titleController.text,
                                  "desc": DescriptionController.text,
                                  "colorIndex": selectedcolorIndex,
                                  "date": DateController.text
                                });
                                // DummyDb.notesList[itemIndex!] = {
                                //   "title": titleController.text,
                                //   "desc": DescriptionController.text,
                                //   "colorIndex": selectedcolorIndex,
                                //   "date": DateController.text
                                // };
                              } else {
                                // To add new note storage
                                noteBox.add({
                                  "title": titleController.text,
                                  "desc": DescriptionController.text,
                                  "date": DateController.text,
                                  "colorIndex": selectedcolorIndex
                                });
                              }
                              // To update the keys list after adding a note
                              noteKeys = noteBox.keys.toList();
                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: ColorConstants.maingreen,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                isEdit ? "Update" : "save",
                                style:
                                    TextStyle(color: ColorConstants.mainwhite),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }
}
