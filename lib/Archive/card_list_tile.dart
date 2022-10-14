import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';


class CardListTile extends StatefulWidget {

  final String title;
  final String subtitle;

  CardListTile({required this.title, required this.subtitle});

  @override
  _CardListTileState createState() => _CardListTileState();
}

class _CardListTileState extends State<CardListTile> {

  List<String> contactsNums = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      // color: ChangeTheme.of(context).theme == Themes.dark ? Colors.grey[600] : Colors.white,
      //color: Color.fromRGBO(60, 75, 96, .9),
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 10.0,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0,),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1.0, color: Colors.white24,),
            ),
          ),
          child: Icon(Icons.account_balance_sharp,
            color: Colors.black),
        ),
        title: Text( widget.title,
          style: TextStyle(color: Colors.black),
          // style: TextStyle(color:ChangeTheme.of(context).theme == Themes.dark ? Colors.white : Colors.black,fontFamily: 'Raleway'),
        ),
        subtitle: Text( widget.subtitle,
          style: TextStyle(color: Colors.black),
          // style: TextStyle(color: ChangeTheme.of(context).theme == Themes.dark ? Colors.white : Colors.grey[700],fontWeight: FontWeight.w500),
        ),

        trailing: Icon(Icons.call, color: Colors.green, size: 30.0,),
        onTap: () {
          setState(() {
            contactsNums.add(widget.subtitle);
            print(contactsNums);

            FlutterPhoneDirectCaller.callNumber(contactsNums.toString());
          });
        },
      ),
    );
  }
}