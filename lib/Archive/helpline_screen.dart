import 'package:flutter/material.dart';
import 'card_list_tile.dart';

class HelplinePage extends StatelessWidget {
  HelplinePage({Key? key}) : super(key: key);

  final List<CardDetail> cards = [
    CardDetail(title: 'Women Helpline', subtitle: '1091'),
    CardDetail(title: 'Women Helpline - ( Domestic Abuse )', subtitle: '181'),
    CardDetail(title: 'Police Station', subtitle: '100'),
    CardDetail(title: 'Fire Station', subtitle: '101'),
    CardDetail(title: 'Ambulance', subtitle: '108'),
    CardDetail(title: 'Blood Bank', subtitle: '1910'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Helpline Numbers',style: TextStyle(fontFamily: 'Raleway'),),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: cards.length,
              itemBuilder: (context, index) => CardListTile(
                title: cards[index].title,
                subtitle: cards[index].subtitle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class CardDetail {
  String title;
  String subtitle;

  CardDetail({required this.title, required this.subtitle});
}