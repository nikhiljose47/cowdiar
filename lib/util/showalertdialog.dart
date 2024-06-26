import 'package:flutter/material.dart';

class ShowAlertDialog extends StatelessWidget {  
  final BuildContext? context;
  final String? title;
  final String? content;

 const ShowAlertDialog({super.key, this.context, this.title, this.content});

  @override  
  Widget build(context) { 
    print("call came"); 
    return Padding(  
      padding: const EdgeInsets.all(20.0),  
      child: ElevatedButton(  
        child: const Text('Show alert'),  
        onPressed: () {  
          showAlertDialog(context);  
        },  
      ),  
    );  
  }  

  showAlertDialog(BuildContext context) {  
  Widget okButton = ElevatedButton(  
    child: const Text("OK"),  
    onPressed: () {  
      Navigator.of(context).pop();  
    },  
  );  
  
  // Create AlertDialog  
  AlertDialog alert = AlertDialog(  
    title: Text(title!),  
    content: Text(content!),  
    actions: [  
      okButton,  
    ],  
  );  
  
  // show the dialog  
  showDialog(  
    context: context,  
    builder: (BuildContext context) {  
      return alert;  
    },  
  );  
}  
}  