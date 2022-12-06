import 'package:playback/model.dart';
import 'package:playback/widgets/layout/data_dialog.dart';
import 'package:playback/widgets/school_year/school_year_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SchoolYearDialog extends StatelessWidget {
  final SchoolYear schoolYear;

  const SchoolYearDialog({super.key, required this.schoolYear});

  @override
  Widget build(BuildContext context) {
    return DataDialog(
      title: Text(AppLocalizations.of(context)!.schoolYear),
      content: SizedBox(
        width: 320,
        child: SchoolYearForm(schoolYear: schoolYear),
      ),
    );
  }
}
