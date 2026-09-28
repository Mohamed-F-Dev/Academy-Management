import 'package:flutter_bloc/flutter_bloc.dart';

import '../teacher_navigation_item.dart';

class TeacherNavigationCubit extends Cubit<TeacherSection> {
  TeacherNavigationCubit() : super(TeacherSection.dashboard);

  void select(TeacherSection section) {
    if (state != section) emit(section);
  }
}
