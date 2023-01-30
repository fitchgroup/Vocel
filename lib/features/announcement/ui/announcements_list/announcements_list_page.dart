import 'package:flutter/material.dart';
import 'package:vocel/common/utils/colors.dart' as constants;

class AnnouncementsListPage extends StatelessWidget {
  const AnnouncementsListPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Vocel Mobile App',
        ),
        backgroundColor: const Color(constants.primaryColorDark),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(constants.primaryColorDark),
        child: const Icon(Icons.add),
      ),
      body: const Center(
        child: Text('Announcements'),
      ),
    );
  }
}
