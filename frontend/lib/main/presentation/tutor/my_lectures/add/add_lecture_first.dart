import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_platform/main/domain/use_case/handle_categories.dart';
import 'package:tutor_platform/main/presentation/components/appbar/common_app_bar.dart';
import 'package:tutor_platform/main/presentation/components/selection/category_selection.dart';
import 'package:tutor_platform/main/presentation/components/selection/category_selection_view_model.dart';
import 'package:tutor_platform/main/presentation/tutor/my_lectures/add/add_lecture_second.dart';

class AddLectureFirst extends StatefulWidget {
  const AddLectureFirst({super.key});

  @override
  State<AddLectureFirst> createState() => _AddLectureFirstState();
}

class _AddLectureFirstState extends State<AddLectureFirst> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: '강의 추가', actions: [Text('1/4 단계')]),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('강의 타이틀'),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '내용을 입력해주세요';
                  }
                  return null;
                },
                controller: _titleController,
                decoration: const InputDecoration(hintText: '강의 제목을 입력해주세요'),
                maxLength: 100,
                minLines: 1,
              ),
              const Text('강의 내용'),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '내용을 입력해주세요';
                  }
                  return null;
                },
                controller: _contentController,
                decoration: const InputDecoration(hintText: '강의에 대한 내용을 입력해주세요'),
                maxLength: 1000,
                minLines: 8,
                maxLines: 8,
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
              final Map<String, dynamic> lectureInfo = {};
              if (_formKey.currentState!.validate()) {
                lectureInfo['title'] = _titleController.text;
                lectureInfo['content'] = _contentController.text;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider<CategorySelectionViewModel>(
                      create: (context) => CategorySelectionViewModel(
                        context.read<HandleCategories>(),
                      ),
                        child: AddLectureSecond(lectureInfo: lectureInfo)),
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
