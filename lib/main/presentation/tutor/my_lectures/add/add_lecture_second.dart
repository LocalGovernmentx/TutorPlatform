import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/core/design/colors.dart';
import 'package:tutor_platform/main/presentation/components/appbar/common_app_bar.dart';
import 'package:tutor_platform/main/presentation/components/selection/category_selection.dart';
import 'package:tutor_platform/main/presentation/components/selection/category_selection_view_model.dart';
import 'package:tutor_platform/main/presentation/tutor/my_lectures/add/third/add_lecture_third.dart';
import 'package:tutor_platform/main/presentation/tutor/my_lectures/add/third/add_lecture_image_view_model.dart';

class AddLectureSecond extends StatefulWidget {
  final Map<String, dynamic> lectureInfo;

  const AddLectureSecond({super.key, required this.lectureInfo});

  @override
  State<AddLectureSecond> createState() => _AddLectureSecondState();
}

class _AddLectureSecondState extends State<AddLectureSecond> {
  final TextEditingController _maxFeeController = TextEditingController();
  final TextEditingController _minFeeController = TextEditingController();
  // final TextEditingController _tuteeNumController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isActivated = true;
  String categoryError = '';

  @override
  void dispose() {
    // _tuteeNumControllerer.dispose();
    _maxFeeController.dispose();
    _minFeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CategorySelectionViewModel>();
    String categoryMsg = viewModel.chosenCategories.isEmpty
        ? '분야 선택'
        : viewModel.chosenCategories[0].specificCategory;

    return Scaffold(
      appBar: const CommonAppBar(title: '강의 추가', actions: [Text('2/4 단계')]),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 30, right: 20, top: 20, bottom: 20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                '강의 금액',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 7),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 10, top: 15, bottom: 15),
                    child: Text(
                      '1회 상한',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _maxFeeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '내용을 입력해주세요';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(hintText: '금액을 입력해주세요'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 10, top: 15, bottom: 15),
                    child: Text(
                      '1회 하한',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _minFeeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null;
                        }
                        if (int.parse(value) >
                            int.parse(_maxFeeController.text)) {
                          return '상한 금액보다 작아야 합니다';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: _minFeeController.text.isEmpty
                              ? '금액을 입력해주세요'
                              : _maxFeeController.text),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Divider(),
              Row(
                children: [
                  Text('선택된 분야 : ',
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(width: 7),
                  Text(categoryMsg),
                  const Expanded(child: SizedBox.shrink()),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider<
                              CategorySelectionViewModel>.value(
                            value: viewModel,
                            child: CategorySelection(
                              changeCategory: (_) {},
                              canSelectMultiple: false,
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text('분야 선택'),
                  ),
                ],
              ),
              const Divider(),
              Text(
                categoryError,
                style: const TextStyle(color: errorTextColor),
              ),
              // const SizedBox(height: 15),
              // ExpansionTile(
              //   title: const Text('추가 설정'),
              //   children: [
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         const Text('activation'),
              //         Checkbox(
              //           value: _isActivated,
              //           onChanged: (bool? value) {
              //             setState(() {
              //               _isActivated = value ?? _isActivated;
              //             });
              //           },
              //         ),
              //       ],
              //     ),
              //     const SizedBox(height: 7),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         const Text('최대 학생수'),
              //         SizedBox(
              //           width: 100,
              //           child: TextField(
              //             controller: _tuteeNumController,
              //             decoration: const InputDecoration(hintText: '무제한'),
              //             keyboardType: TextInputType.number,
              //           ),
              //         ),
              //       ],
              //     ),
                  // const SizedBox(height: 7),
                  // Row(
                  //   children: [
                  //     const Text('학생 성별'),
                  //     const SizedBox(width: 7),
                  //
                  //   ],
                  // ),
              //     const SizedBox(height: 7),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         const Text('level'),
              //
              //       ],
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 54,
          child: ElevatedButton(
            onPressed: () {
              if (viewModel.chosenCategories.isEmpty) {
                setState(() {
                  categoryError = '분야를 선택해주세요';
                });
                return;
              } else {
                setState(() {
                  categoryError = '';
                });
              }
              if (_formKey.currentState!.validate()) {
                widget.lectureInfo['categoryId'] = viewModel.chosenCategories[0].id;
                widget.lectureInfo['tuitionMaximum'] = int.parse(_maxFeeController.text) ~/ 1000;
                widget.lectureInfo['tuitionMinimum'] = int.parse(_minFeeController.text) ~/ 1000;
                widget.lectureInfo['activation'] = _isActivated;
                widget.lectureInfo['tuteeNumber'] = 10;
                widget.lectureInfo['online'] = 3;
                widget.lectureInfo['gender'] = 3;
                widget.lectureInfo['level'] = 2;
                widget.lectureInfo['reviews'] = [];
                widget.lectureInfo['locations'] = [];
                widget.lectureInfo['ages'] = [];
                widget.lectureInfo['images'] = [];

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (context) => AddLectureImageViewModel(),
                      child: AddLectureThird(lectureInfo: widget.lectureInfo),
                    ),
                  ),
                );
              }
            },
            child: const Text('다음단계'),
          ),
        ),
      ),
    );
  }
}
