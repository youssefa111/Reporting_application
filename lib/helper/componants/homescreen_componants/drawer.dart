import 'package:first_task/helper/constants/constants.dart';
import 'package:first_task/presentation/home_screens/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * .32,
            decoration: BoxDecoration(
              gradient: linearGradient,
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  BackButton(
                    color: Colors.white,
                  ),
                  Center(
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/grifatti.jpg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'Youssef Hussein',
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                      child: Text(
                    'youssefhussien97@gmail.com',
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: Colors.white,
                        ),
                  )),
                ],
              ),
            ),
          ),
          drawerSetting(title: 'Profile Settings', context: context),
          drawerSetting(title: 'Feed Preferences', context: context),
          drawerSetting(title: 'My Activites', context: context),
          drawerSetting(title: 'Notifcations', context: context),
          drawerSetting(title: 'Invite friends & neighbors', context: context),
          drawerSetting(title: 'Help/Instructions', context: context),
          drawerSetting(title: 'Privacy Policy', context: context),
          drawerSetting(title: 'Agreement', context: context),
          drawerSetting(title: 'Sign out', context: context),
        ],
      ),
    ));
  }
}

Widget drawerSetting({
  required String title,
  required BuildContext context,
}) =>
    InkWell(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ProfileScreen())),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 15.0),
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );