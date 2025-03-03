import 'package:attendance_app/src/models/api_response.dart';
import 'package:attendance_app/src/models/student.model.dart';
import 'package:attendance_app/src/providers/student_provider.dart';
import 'package:attendance_app/src/providers/user_provider.dart';
import 'package:attendance_app/src/services/api/api.dart';
import 'package:attendance_app/src/views/screens/student/home/subjects_list.dart';
import 'package:attendance_app/src/views/widgets/widgets.dart';
import 'package:attendance_app/src/views/widgets/home_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StudentHome extends ConsumerStatefulWidget {
  const StudentHome({super.key});

  @override
  ConsumerState<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends ConsumerState<StudentHome> {
  bool isLoading = false;

  Future<void> getStudent() async {
    try {
      setState(() {
        isLoading = true;
      });
      ApiResponse<StudentModel> studentData =
          await Api().student.getStudent();

      if (studentData.success) {
        if (!mounted) return;
        ref.read(studentProvider.notifier).setStudent(studentData.data);
      }
    } catch (error) {
      debugPrint("ERROR: $error");
      if (!mounted) return;
      context.go("/");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // getStudent();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    String studentName = "User";

    if (user is StudentUser) {
      studentName = user.student.user?.name ?? "User";
    } else {
      studentName = "User";
    }

    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    context.go("/student/profile");
                  },
                  icon: const Icon(Icons.account_circle_outlined),
                ),
              ],
              forceMaterialTransparency: true,
            ),
            body: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  HomeTitle(name: studentName),
                  const Expanded(
                    child: SubjectsList(),
                  ),
                ],
              ),
            ),
          );
  }
}
