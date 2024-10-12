import 'package:flutter/material.dart';
import 'package:tutor_platform/main/presentation/components/lecture_list/scroll_view_model.dart';

class FeeSelection extends StatefulWidget {
  final ScrollViewModel viewModel;
  const FeeSelection({super.key, required this.viewModel});

  @override
  State<FeeSelection> createState() => _FeeSelectionState();
}

class _FeeSelectionState extends State<FeeSelection> {
  final selectionValue = [-1, for (int i = 10; i > 0; i--) i*100000];
  final selectionList = ['전체', for (int i = 10; i > 0; i--) '${i*10}만원 이하'];
  int _selectedValue = 0;

  @override
  Widget build(BuildContext context) {

    return IntrinsicHeight(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height:10),
            ListTile(
              title: Text('수업료', style: Theme.of(context).textTheme.headlineSmall,),
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
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    widget.viewModel.set(selectionValue[_selectedValue]);
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
