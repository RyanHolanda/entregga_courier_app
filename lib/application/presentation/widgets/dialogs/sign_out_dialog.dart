// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:entregga_courier/application/bloc/app_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MySignoutDialog {
  String title;
  String content;
  MySignoutDialog({
    required this.content,
    required this.title,
  });
  showMyDialog(context) {
    showDialog(
        context: context,
        builder: (context) => Platform.isAndroid
            ? AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                title: Text(title),
                content: Text(content),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppLocalizations.of(context)!.back)),
                  TextButton(
                      onPressed: () async {
                        Future signout() async {
                          context.read<AppBloc>().add(AppEventSignOut());
                        }

                        await signout();
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.signOut,
                        style: const TextStyle(color: Colors.red),
                      )),
                ],
              )
            : CupertinoAlertDialog(
                title: Text(title),
                content: Text(content),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppLocalizations.of(context)!.back)),
                  TextButton(
                      onPressed: () =>
                          context.read<AppBloc>().add(AppEventSignOut()),
                      child: Text(AppLocalizations.of(context)!.signOut)),
                ],
              ));
  }
}
