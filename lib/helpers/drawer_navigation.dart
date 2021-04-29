import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
           children: [
             UserAccountsDrawerHeader(
               currentAccountPicture: Image.asset(
                 'assets/logo.png',
               ),
               accountName: Text('HelpNow'),
               accountEmail: Text('gethelpnow.in')
             ),
             ListTile(
               title: Text('Home'),
               leading: Icon(Icons.home),
               onTap: () {
                 Navigator.pop(context);
               },
             ),
             ListTile(
               title: Text('About Us'),
               leading: Icon(Icons.info_outline),
               onTap: _launchUrl,

             ),
           ],
        ),
      ),
    );
  }

  _launchUrl() async{
    const url = 'https://www.linkedin.com/company/helpnow-8899889952/';
    if(await canLaunch(Uri.encodeFull(url))) {
      await launch(url);
    }
  }
}
