import 'package:flutter/material.dart';
import 'package:tutor_platform/core/properties/lecture_information.dart';
import 'package:tutor_platform/main/presentation/tutor/my_lectures/add/fourth/components/date_selecton_object.dart';

class AddLectureDateSelection extends StatefulWidget {
  final DateSelectonObject dateSelectionObject;
  final void Function() onRemove;

  const AddLectureDateSelection({
    super.key,
    required this.dateSelectionObject,
    required this.onRemove,
  });

  @override
  State<AddLectureDateSelection> createState() =>
      _AddLectureDateSelectionState();
}

class _AddLectureDateSelectionState extends State<AddLectureDateSelection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 20),
            child: Text(WeekDayString(widget.dateSelectionObject.weekDay)),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  for (Map<String, dynamic> selection
                      in widget.dateSelectionObject.startSelection)
                    if (selection.keys.contains('text'))
                      Text(selection['text'])
                    else
                      Expanded(
                        child: Center(
                          child: DropdownButton(
                            value: selection['value'],
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                selection['change'](value);
                              });
                            },
                            items: selection['variants']
                                .map<DropdownMenuItem<Object>>(
                                  (Object index) => DropdownMenuItem(
                                    value: index,
                                    child: Text(index.toString()),
                                  ),
                                )
                                .toList(),
                            underline: const SizedBox(),
                            icon: const SizedBox(),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text('-'),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  for (Map<String, dynamic> selection
                  in widget.dateSelectionObject.endSelection)
                    if (selection.keys.contains('text'))
                      Text(selection['text'])
                    else
                      Expanded(
                        child: Center(
                          child: DropdownButton(
                            value: selection['value'],
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                selection['change'](value);
                              });
                            },
                            items: selection['variants']
                                .map<DropdownMenuItem<Object>>(
                                  (Object index) => DropdownMenuItem(
                                value: index,
                                child: Text(index.toString()),
                              ),
                            )
                                .toList(),
                            underline: const SizedBox(),
                            icon: const SizedBox(),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              widget.onRemove();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
