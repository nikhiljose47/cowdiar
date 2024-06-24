import "package:flutter/material.dart";

class PopupMenuButtonPage extends StatefulWidget {
  const PopupMenuButtonPage({super.key});

  @override
  _PopupMenuButtonState createState() => _PopupMenuButtonState();
}

class _PopupMenuButtonState extends State<PopupMenuButtonPage> {
  @override
  Widget build(BuildContext context) {
    Widget threeItemPopup() => PopupMenuButton(
      itemBuilder: (context) {
        var list = List<PopupMenuEntry<Object>>();
        list.add(
          const PopupMenuItem(
            value: "1",
            child: Text("Setting Language"),
          ),
        );
        list.add(
          const PopupMenuDivider(
            height: 10,
          ),
        );
        list.add(
          const CheckedPopupMenuItem(
            value: "2",
            checked: true,
            child: Text(
              "English",
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
        return list;

      },
      icon: const Icon(
        Icons.settings,
        size: 50,
        color: Colors.white,
      ),
    );
    Widget selectPopup() => PopupMenuButton<int>(

        itemBuilder: (context) => [
          PopupMenuItem(
            child: Container(
              color: Colors.red,
            child: const Text("filters"),
          ),
        ),
          const PopupMenuItem(
            value: 1,
            child: Text("All"),
          ),
          const PopupMenuItem(
            value: 2,
            child: Text("unread"),
          ),
          const PopupMenuItem(
            value: 3,
            child: Text("starred"),
          ),
          const PopupMenuItem(
            value: 4,
            child: Text("Archive"),
          ),
          const PopupMenuItem(
            value: 5,
            child: Text("spam"),
          ),
          const PopupMenuItem(
            value: 6,
            child: Text("send"),
          ),
          const PopupMenuItem(
            value: 7,
            child: Text("Custom Offers"),
          ),
          PopupMenuItem(
            child: Container(
              color: Colors.red,
              child: const Text("tags"),
            ),
          ),

        ],
        initialValue: 2,
        onCanceled: () {
          print("You have canceled the menu.");
        },
        onSelected: (value) {
          print("value:$value");
        },
        icon: const Icon(Icons.list),

    );


    return Scaffold(
      appBar: AppBar(
        title: const Text("POPUP_MENU_BUTTON"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Container(
              color: Colors.grey,
              constraints: const BoxConstraints.expand(height: 80),
              child: Container(

                  child: selectPopup()
              ),
            ),
          ],
        ),
      ),
    );
  }
}