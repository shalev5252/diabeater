import 'dart:async';
import 'package:diabeater/screens/admin/bottomnavbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/screenSizeFit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool is_verified = false;
  bool can_reset_email = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    is_verified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!is_verified) {
      sendVerificationEmail();
    }

    timer = Timer.periodic(
      Duration(seconds: 2),
      (_) => checkEmailVerified(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      is_verified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (is_verified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => can_reset_email = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => can_reset_email = true);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double container_height = SizeConfig.blockSizeVertical * 7;
    double container_width = SizeConfig.blockSizeHorizontal * 90;
    if (is_verified) return const BottomNavBar();
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.verify_email)),
      body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Image.asset(
                'assets/blue_logo.png',
                height: SizeConfig.blockSizeVertical * 20,
                width: SizeConfig.blockSizeHorizontal * 20,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.verification_sent,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
                icon: Icon(Icons.email, size: 32),
                label: Text(
                  AppLocalizations.of(context)!.resend_email,
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: can_reset_email ? sendVerificationEmail : null),
            SizedBox(height: 8),
            TextButton(
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
              onPressed: () => FirebaseAuth.instance.signOut(),
              child: Text(AppLocalizations.of(context)!.cancel,
                  style: TextStyle(fontSize: 24)),
            )
          ])),
    );
  }
}
