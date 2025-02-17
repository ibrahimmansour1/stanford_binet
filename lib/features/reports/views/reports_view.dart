import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'session_report_view.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('sessions').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading');
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text('No Exams found');
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final sessionDoc = snapshot.data!.docs[index];
              final data = sessionDoc.data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text('Session Code: ${data['session_code']}'),
                  subtitle: Text('Session Name: ${data['name']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SessionReportView(
                            sessionCode: data['session_code']),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
