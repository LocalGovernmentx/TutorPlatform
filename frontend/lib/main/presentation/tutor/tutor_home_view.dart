import 'package:flutter/material.dart';
import 'package:tutor_platform/core/design/colors.dart';
import 'package:tutor_platform/core/design/style.dart';
import 'package:tutor_platform/main/presentation/components/appbar/main_page_app_bar.dart';
import 'package:tutor_platform/main/presentation/tutor/my_lectures/tutor_my_lectures_di.dart';

class TutorHomeView extends StatelessWidget {
  const TutorHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainPageAppBar(
        isTutor: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: ListView(
          children: [
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: () {},
            //     style: faintButtonStyle(faintGreen),
            //     child: Row(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Flexible(
            //           child: Padding(
            //             padding: const EdgeInsets.only(
            //               left: 17,
            //               right: 18,
            //               top: 22,
            //             ),
            //             child: Image.asset(
            //               'assets/images/tutor_main_page/sapling.png',
            //               fit: BoxFit.scaleDown,
            //               width: 59,
            //             ),
            //           ),
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.only(
            //             top: 28,
            //             bottom: 24,
            //             right: 7,
            //           ),
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               const Text('튜터로 처음 가입하신 선생님은'),
            //               const Text('마이페이지에서 프로필을 완성해주세요.'),
            //               const SizedBox(height: 7),
            //               Text(
            //                 '프로필 작성하러 가기.→',
            //                 style: Theme.of(context).textTheme.bodySmall,
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 10),
            IntrinsicHeight(
              child: Row(
                children: [
                  // Expanded(
                  //   child: ElevatedButton(
                  //     onPressed: () {},
                  //     style: faintButtonStyle(faintBlue),
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(
                  //           top: 30, left: 20, right: 19, bottom: 14),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text('멘티 찾기',
                  //               style:
                  //                   Theme.of(context).textTheme.headlineMedium),
                  //           const SizedBox(height: 7),
                  //           const Text('멘토를 찾고 있는'),
                  //           const Text('학생들을 빠르게'),
                  //           const Text('검색해보세요'),
                  //           const SizedBox(height: 14),
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.end,
                  //             children: [
                  //               Image.asset(
                  //                 'assets/images/tutor_main_page/magnifying_glass.png',
                  //                 width: 63,
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TutorMyLecturesDi(),
                          ),
                        );
                      },
                      style: faintButtonStyle(faintPurple),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 30, left: 20, right: 19, bottom: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('내 강의 관리',
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                            const SizedBox(height: 7),
                            const Text('내 강의를 등록하고'),
                            const Text('관리를 해보세요'),
                            const SizedBox(height: 13),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Image.asset(
                                  'assets/images/tutor_main_page/manage_my_lectures.png',
                                  width: 90,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 10),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: () {},
            //     style: faintButtonStyle(faintRed),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.only(
            //             left: 20,
            //             top: 30,
            //           ),
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text('방과 후 강의 모집공고',
            //                   style:
            //                       Theme.of(context).textTheme.headlineMedium),
            //               const SizedBox(height: 7),
            //               const Text('학교에서 진행하는 방과후 수업의'),
            //               const Text('강사모집 공고 입니다'),
            //             ],
            //           ),
            //         ),
            //         Flexible(
            //           child: Padding(
            //             padding: const EdgeInsets.only(
            //               left: 7,
            //               right: 15,
            //               top: 23,
            //               bottom: 24,
            //             ),
            //             child: Image.asset(
            //               'assets/images/tutor_main_page/classroom.png',
            //               width: 108,
            //               fit: BoxFit.scaleDown,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
