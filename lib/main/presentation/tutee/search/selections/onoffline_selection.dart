import 'package:flutter/material.dart';
import 'package:tutor_platform/main/presentation/components/lecture_list/scroll_view_model.dart';

class OnofflineSelection extends StatefulWidget {
  final ScrollViewModel viewModel;
  const OnofflineSelection({super.key, required this.viewModel});

  @override
  State<OnofflineSelection> createState() => _OnofflineSelectionState();
}

class _OnofflineSelectionState extends State<OnofflineSelection> {
  final selectionList = ['전체', '온라인', '오프라인'];
  int _selectedValue = 0;

  @override
  Widget build(BuildContext context) {

    return IntrinsicHeight(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            ListTile(
              title: Text('수업 방식 선택', style: Theme.of(context).textTheme.headlineSmall,),
              trailing: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ),
            for (int i = 0; i < selectionList.length; i++)
              ListTile(
                title: Text(selectionList[i]),
                trailing: Radio<int>(
                  value: i,
                  groupValue: _selectedValue,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedValue = value!;
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    _selectedValue = i;
                  });
                },
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.viewModel.set(_selectedValue);
                    Navigator.pop(context);
                  },
                  child: const Text('선택 완료'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
