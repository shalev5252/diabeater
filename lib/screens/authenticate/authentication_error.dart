import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegError extends StatefulWidget {
  @override
  State<RegError> createState() => _RegErrorState();
}

class _RegErrorState extends State<RegError> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(AppLocalizations.of(context)!.general_error));
  }
}
