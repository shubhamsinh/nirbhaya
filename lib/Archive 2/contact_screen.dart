import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  final FlutterContactPicker _contactPicker = new FlutterContactPicker();

  List<String> contactsNums = [];
  List<String> contactsNames = [];

  late SharedPreferences prefs;

  _initializeContacts() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      contactsNums = prefs.getStringList('nums') ?? [];
      contactsNames = prefs.getStringList('names') ?? [];
    });
  }

  @override
  void initState() {
    _initializeContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    PermissionStatus permission;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:() => Navigator.pop(context, false),),
          title: Text("Emergency Contacts",style: TextStyle(fontFamily: 'Raleway'),),
        ),
        body: contactsNames.length > 0
            ? ListView.builder(
          itemCount: contactsNames.length,
          itemBuilder: (BuildContext ctx, int i) {
            return Card(
              margin: EdgeInsets.all(5),
              child: ListTile(
                leading: Icon(Icons.account_circle, size: 40,),
                title: Text(contactsNames[i],style: TextStyle(fontFamily: 'Raleway'),),
                subtitle: Text(contactsNums[i],style: TextStyle(fontWeight: FontWeight.w500),),
                trailing: GestureDetector(
                  child: Icon(Icons.delete, size: 30,),
                  onTap: () async {
                    setState(() {
                      contactsNames.removeAt(i);
                      contactsNums.removeAt(i);
                    });
                    await prefs.setStringList('nums', contactsNums);
                    await prefs.setStringList('names', contactsNames);
                  },
                ),
              ),
            );
          },
        )
            : Center(
          child: Text('No contacts added yet',
            style: TextStyle(color:Colors.white,fontSize: 20, fontFamily: 'Raleway'),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pinkAccent,
          child: Icon(Icons.add,size: 40,
            color: Colors.white,),
          onPressed: <PermissionStatus>()async{
            //Check contacts permission
            permission = await Permission.contacts.status;
            if (await Permission.contacts.request().isGranted) {
              final contact = await _contactPicker.selectContact();
              setState(() {
                contactsNames.add(contact!.fullName.toString());
                contactsNums.add(contact!.phoneNumbers.toString());
              });
              prefs.setStringList('nums', contactsNums);
              prefs.setStringList('names', contactsNames);
            }
            else{
              return permission;
            }
          },
        ),
      ),
    );
  }
}