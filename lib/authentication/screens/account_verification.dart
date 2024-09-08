import 'dart:async';

import 'package:flutter/material.dart';
import 'package:appsagetechwiz/authentication/widgets/otp_boxes.dart';

class AccountVerification extends StatefulWidget {
  const AccountVerification({super.key});

  @override
  State<AccountVerification> createState() => _AccountVerificationState();
}

class _AccountVerificationState extends State<AccountVerification> {
  int _remainingTime = 30;
  bool _isButtonEnabled = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _isButtonEnabled = true;
          timer.cancel();
        }
      });
    });
  }

  void _resendCode() {
    setState(() {
      _remainingTime = 30;
      _isButtonEnabled = false;
      _startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter the code",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: "An SMS code was sent to ",
                  style: Theme.of(context).textTheme.bodyMedium),
              TextSpan(
                  text: "+2347026833840",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold))
            ])),
            const SizedBox(
              height: 25,
            ),
            OTPField(
                length: 4,
                onCompleted: (pin) {
                  Navigator.pushNamed(context, "/profile-update");
                }),
            const SizedBox(
              height: 20,
            ),
            _isButtonEnabled
                ? GestureDetector(
                    onTap: _resendCode,
                    child: Text("Resend",
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary)),
                  )
                : Row(
                    children: [
                      Text(
                        "Resend code in ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text("$_remainingTime",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold))
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
