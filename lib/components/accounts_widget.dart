import 'package:finance/components/smallbutton.dart';
import 'package:finance/constants/colors.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

// ignore: must_be_immutable
class AccountsView extends StatefulWidget {
  const AccountsView({
    Key? key,
  }) : super(key: key);

  @override
  State<AccountsView> createState() => _AccountsViewState();
}

class _AccountsViewState extends State<AccountsView> {
  @override
  Widget build(BuildContext context) {
    String walletBalance = '₦ 567,125.21';

    return Container(
      height: 200,
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Divider(
              color: GlobalColors.primaryColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SmallButton(
                      textColor: Colors.white,
                      backgroundColor: GlobalColors.secondaryColor,
                      height: 15,
                      width: 30,
                      borderColor: GlobalColors.secondaryColor,
                      text: "MT4",
                      isIcon: false,
                      icon: Icons.credit_card,

                      // icon: icon)
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    SmallButton(
                      textColor: Colors.white,
                      backgroundColor: Colors.green,
                      height: 15,
                      width: 30,
                      borderColor: GlobalColors.secondaryColor,
                      text: "DEMO",
                      isIcon: false,
                      icon: Icons.credit_card,

                      // icon: icon)
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SmallButton(
                      textColor: Colors.white,
                      backgroundColor: GlobalColors.primaryColor,
                      height: 15,
                      width: 75,
                      borderColor: GlobalColors.secondaryColor,
                      text: "# 12239485",
                      isIcon: false,
                      icon: Icons.credit_card,

                      // icon: icon)
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                SmallButton(
                  textColor: Colors.white,
                  backgroundColor: Colors.red,
                  height: 15,
                  width: 75,
                  borderColor: GlobalColors.secondaryColor,
                  text: "HIDE BALANCES",
                  isIcon: false,
                  icon: Icons.credit_card,

                  // icon: icon)
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    walletBalance,
                    style: SafeGoogleFont(
                      'Roboto',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                      color: GlobalColors.secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: SmallButton(
                    textColor: Colors.white,
                    backgroundColor: const Color.fromARGB(199, 67, 65, 65),
                    height: 35,
                    width: 75,
                    borderColor: const Color.fromARGB(199, 67, 65, 65),
                    text: "DEPOSIT",
                    isIcon: false,
                    icon: Icons.credit_card,

                    // icon: icon)
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {},
                  child: SmallButton(
                    textColor: Colors.white,
                    backgroundColor: const Color.fromARGB(199, 67, 65, 65),
                    height: 35,
                    width: 75,
                    borderColor: const Color.fromARGB(199, 67, 65, 65),
                    text: "WITHDRAW",
                    isIcon: false,
                    icon: Icons.credit_card,

                    // icon: icon)
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {},
                  child: SmallButton(
                    textColor: Colors.white,
                    backgroundColor: const Color.fromARGB(199, 67, 65, 65),
                    height: 35,
                    width: 35,
                    borderColor: const Color.fromARGB(199, 67, 65, 65),
                    text: "WITHDRAW",
                    isIcon: true,
                    icon: Icons.menu,

                    // icon: icon)
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
