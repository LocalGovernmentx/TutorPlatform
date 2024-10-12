import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/core/design/colors.dart';
import 'package:tutor_platform/core/design/style.dart';
import 'package:tutor_platform/core/properties/lecture_information.dart';
import 'package:tutor_platform/main/presentation/components/appbar/common_app_bar.dart';
import 'package:tutor_platform/main/presentation/tutor/my_lectures/add/fourth/add_lecture_date_selection.dart';
import 'package:tutor_platform/main/presentation/tutor/my_lectures/add/fourth/add_lecture_date_view_model.dart';
import 'package:tutor_platform/main/presentation/tutor/my_lectures/add/fourth/components/date_selecton_object.dart';

class AddLectureFourth extends StatelessWidget {
  const AddLectureFourth({super.key, required this.lectureInfo});

  final Map<String, dynamic> lectureInfo;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AddLectureDateViewModel>();

    return Scaffold(
      appBar: const CommonAppBar(title: '강의 추가', actions: [Text('4/4 단계')]),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (WeekDay day in WeekDay.values
                    .where((element) => element != WeekDay.unused)) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        viewModel.addDateSelections(day);
                      },
                      style: unfilledOutlinedButtonStyle,
                      child: Text(WeekDayString(day)),
                    ),
                  ),
                  if (day.index != WeekDay.values.length - 1)
                    const SizedBox(width: 7),
                ],
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  for (int i = 0; i < viewModel.dateSelections.length; i++) ...[
                    AddLectureDateSelection(
                      dateSelectionObject: viewModel.dateSelections[i],
                      onRemove: () {
                        viewModel.removeDateSelections(i);
                      },
                    ),
                    if (viewModel.dateSelections[i].validatedIncorrect)
                      const Padding(
                        padding: EdgeInsets.only(top: 5, left: 45),
                        child: Text(
                          '종료 시각은 시작 시각보다 빨라야 합니다.',
                          style: TextStyle(color: errorTextColor),
                        ),
                      ),
                  ]
                ],
              ),
            ),
            if (viewModel.errorMsg != null)
              Center(
                child: Text(
                  viewModel.errorMsg!,
                  style: const TextStyle(color: errorTextColor),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 54,
          child: ElevatedButton(
            onPressed: () {
              viewModel.finalize(lectureInfo);
            },
            child: const Text('강의 추가하기'),
          ),
        ),
      ),
    );
  }
}
