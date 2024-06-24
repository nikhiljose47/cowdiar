import 'package:flutter/material.dart';
import 'package:cowdiar/screen/setting/account_settings.dart';
import 'package:cowdiar/screen/setting/profile_settings.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              color: Colors.white10,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white10,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: ListTile(
              title: const Text('Profile Settings',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  )),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileSettings(),
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white10,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: ListTile(
              title: const Text('Account Settings',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  )),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountSettings(),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
                left: 10.0, right: 10.0, top: 25.0, bottom: 10.0),
            child: Text(
              "v2.66.1(2)",
              style: TextStyle(color: Colors.black45),
            ),
          ),
        ],
      ),
    );
  }
}
