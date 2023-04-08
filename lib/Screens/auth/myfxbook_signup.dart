// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';
import '../../utils.dart';

class MyfxBookSignup extends StatelessWidget {
  const MyfxBookSignup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return Padding(
      padding: mediaQueryData.viewInsets,
      child: SizedBox(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "To create an account...",
                      style: SafeGoogleFont(
                        'Roboto',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                        color: GlobalColors.secondaryColor,
                      ),
                    )),
                SizedBox(
                  height: 450,
                  child: ListView(
                    children: [
                      _buildStepCard(
                        title: 'Step 1: Go to MyFxbook Website',
                        subtitle: 'https://www.myfxbook.com',
                        onTap: () => _launchUrl('https://www.myfxbook.com'),
                      ),
                      _buildStepCard(
                        title: 'Step 2: Click on "Register" Button',
                        subtitle:
                            'Located in the top right corner of the website',
                        onTap: () =>
                            _launchUrl('https://www.myfxbook.com/register'),
                      ),
                      _buildStepCard(
                        title: 'Step 3: Fill in the Registration Form',
                        subtitle:
                            'Enter your email, desired username and password in the form',
                      ),
                      _buildStepCard(
                        title: 'Step 4: Verify Your Email Address',
                        subtitle:
                            'Check your email inbox for a verification link and follow the instructions',
                      ),
                      _buildStepCard(
                        title: 'Step 5: Log in to TradeStack',
                        subtitle:
                            'Use the username and password you entered during registration to login on the app',
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Card _buildStepCard({
    required String title,
    String subtitle = '',
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: ListTile(
        title: Text(
          title,
          style: SafeGoogleFont(
            'Roboto',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1.5,
            color: GlobalColors.secondaryColor,
          ),
        ),
        subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
