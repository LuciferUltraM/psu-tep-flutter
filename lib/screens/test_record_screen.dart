// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:psutep/components/audio_test_player.dart';
import 'package:psutep/components/audio_test_recorder.dart';
import 'package:psutep/constants.dart';
import 'package:psutep/models/examinee.dart';
import 'package:psutep/screens/examinee_quiz_screen.dart';
import 'package:psutep/services/app_service.dart';

class TestRecordScreen extends StatefulWidget {
  static const String id = 'test_record_screen';

  const TestRecordScreen({super.key});

  @override
  State<TestRecordScreen> createState() => _TestRecordScreenState();
}

class _TestRecordScreenState extends State<TestRecordScreen> {
  late AppService appService;
  bool showPlayer = false;
  String? audioPath;
  Examinee examinee = Examinee(0);

  @override
  void initState() {
    super.initState();
    AppService.getInstance().then((value) {
      appService = value;
      if (appService.getRole() != 'examinee') {
        appService.logout().then((value) {
          html.window.location.href = "/";
        });
        return;
      }
      setState(() {
        examinee = appService.getExaminee();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('PSU-TEP'),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {
                  appService.logout().then((value) {
                    html.window.location.href = "/";
                  });
                },
                child: const Icon(
                  Icons.exit_to_app,
                  size: 26.0,
                ),
              ),
            ),
          ]),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30.0,
            ),
            const Text(
              'Test Record Audio',
              style: TextStyle(
                fontSize: 26.0,
                fontFamily: kDefaultFont,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            showPlayer
                ? Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 400,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: AudioTestPlayer(
                          source: audioPath!,
                          onDelete: () {
                            setState(() => showPlayer = false);
                          },
                        ),
                      ),
                    ),
                  )
                : AudioTestRecorder(
                    onStop: (path) async {
                      if (kDebugMode) print('Recorded file path: $path');
                      setState(() {
                        audioPath = path;
                        showPlayer = true;
                      });
                    },
                  ),
            const SizedBox(
              height: 40.0,
            ),
            Text(
              'Examinee : ${examinee.code} ${examinee.firstname} ${examinee.lastname}',
              style: const TextStyle(
                  fontFamily: kDefaultFont,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 40.0,
            ),
            ElevatedButton(
                onPressed: () => startQuiz(),
                child: const Text('Start Quiz',
                    style: TextStyle(color: Colors.white, fontSize: 20)))
          ],
        ),
      ),
    );
  }

  void startQuiz() {
    appService.fetchQuiz().then((quiz) {
      Navigator.of(context).pushNamed(ExamineeQuizScreen.id, arguments: quiz);
    });
  }
}
