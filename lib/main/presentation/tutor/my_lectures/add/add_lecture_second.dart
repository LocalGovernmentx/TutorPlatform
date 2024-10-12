import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/main/presentation/components/appbar/common_app_bar.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _maxFeeController.dispose();
    _minFeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: '강의 추가', actions: [Text('2/4 단계')]),
      body: Padding(
        padding: const EdgeInsets.only(left:30, right: 20, top: 20, bottom:20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('강의 금액', style: Theme.of(context).textTheme.bodyLarge,),
              const SizedBox(height: 7),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 10, top: 15, bottom: 15),
                    child: Text(
                      '1회 상한',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyLarge,
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
                    padding: const EdgeInsets.only(
                        right: 10, top: 15, bottom: 15),
                    child: Text(
                      '1회 하한',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyLarge,
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
              Divider(),
              Row(
                children: [
                  Text('선택된 분야 : ', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(width: 7),
                  const Text('분야 없음'),
                  const Expanded(child: SizedBox.shrink()),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('분야 선택'),
                  ),
                ],
              ),
              Divider(),
              const SizedBox(height: 15),
              const ExpansionTile(
                title: Text('추가 설정'),
                children: [
                  Text('activation'),
                  SizedBox(height: 7),
                  Text('최대 학생수 tuteenumber'),
                  SizedBox(height: 7),
                  Text('gender'),
                  SizedBox(height: 7),
                  Text('level'),
                  SizedBox(height: 7),
                ],
              ),
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
              if (_formKey.currentState!.validate()) {
                widget.lectureInfo['tuitionMaximum'] = _maxFeeController.text;
                widget.lectureInfo['tuitionMinimum'] = _minFeeController.text;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChangeNotifierProvider(
                          create: (context) => AddLectureImageViewModel(),
                          child: AddLectureThird(
                              lectureInfo: widget.lectureInfo),
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
