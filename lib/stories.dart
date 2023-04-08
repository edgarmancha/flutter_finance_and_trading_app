import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/dump.dart';
import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  List<Status> _statusList = [];

  @override
  void initState() {
    super.initState();

    // Retrieve status data from Firestore
    FirebaseFirestore.instance
        .collection('status')
        .orderBy('createdAt', descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      final List<Status> statuses = querySnapshot.docs.map((doc) {
        return Status(
          imageUrl: doc['imageUrl'],
          caption: doc['caption'],
          createdAt: doc['createdAt'].toDate(),
        );
      }).toList();

      setState(() {
        _statusList = statuses;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _statusList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(_statusList[index].imageUrl),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStatusPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Status {
  final String imageUrl;
  final String caption;
  final DateTime createdAt;

  Status({
    required this.imageUrl,
    required this.caption,
    required this.createdAt,
  });
}
