import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/time_capsule.dart'; 

class CapsuleListScreen extends StatefulWidget {
  @override
  _CapsuleListScreenState createState() => _CapsuleListScreenState();
}

class _CapsuleListScreenState extends State<CapsuleListScreen> {
  late final Box<TimeCapsule> _capsuleBox;

  @override
  void initState() {
    super.initState();
    // Initialize the box asynchronously
    _openBox();
  }

  Future<void> _openBox() async {
    // Open the box and store the reference in the state variable
    _capsuleBox = await Hive.openBox<TimeCapsule>('capsuleBox');
  }

  void deleteCapsule(int index) {
    // Delete a capsule from the Hive box
    _capsuleBox.deleteAt(index);
  }

  void archiveCapsule(int index) {
    // Get the capsule from the box
    TimeCapsule? capsule = _capsuleBox.getAt(index);

    if (capsule != null) {
      // Toggle the isArchived status
      capsule.isArchived = !capsule.isArchived;

      // Save the updated capsule back to the box
      capsule.save(); // This updates the capsule in the Hive box

      // Optionally, refresh the UI or navigate away
      setState(() {});

      // Provide user feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(capsule.isArchived
                ? 'Capsule archived'
                : 'Capsule unarchived')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Capsule List'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context, delegate: CapsuleSearch(_capsuleBox));
              },
            ),
          ],
        ),
        // Use a ValueListenableBuilder to listen to changes in the box
        body: ValueListenableBuilder(
          valueListenable: _capsuleBox.listenable(),
          builder: (context, Box<TimeCapsule> box, _) {
            List<TimeCapsule> capsules = box.values.toList();
            // Now build your UI with the list of capsules
            return ListView.builder(
              itemCount: capsules.length,
              itemBuilder: (BuildContext context, int index) {
                final capsule = capsules[index];
                return _buildCapsuleItem(context, index, capsule);
              },
            );
          },
        ));
  }
}

Widget _buildCapsuleItem(BuildContext context, int index, TimeCapsule capsule) {
  return Slidable(
    actionPane: SlidableDrawerActionPane(),
    secondaryActions: <Widget>[
      IconSlideAction(
        caption: 'Archive',
        color: Colors.blue,
        icon: Icons.archive,
        onTap: () => archiveCapsule(index),
      ),
      IconSlideAction(
        caption: 'Delete',
        color: Colors.red,
        icon: Icons.delete,
        onTap: () => deleteCapsule(index),
      ),
    ],
    child: ListTile(
      title: Text(capsule.title),
      subtitle: Text(
          'Unlock Date: ${DateFormat('yyyy-MM-dd').format(capsule.unlockDate)}'),
      onTap: () {
        // Placeholder for action, e.g., navigating to a detail view.
        print('Tapped on ${capsule.title}');
      },
    ),
  );
}

// Search delegate to enable search functionality
class CapsuleSearch extends SearchDelegate<TimeCapsule> {
  final Box<TimeCapsule> capsuleBox;

  CapsuleSearch(this.capsuleBox);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(
              context); // Show all capsules when the query is cleared.
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // The search results can be shown here if needed
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Filter the list based on the query
    final filteredList = capsuleBox.values
        .where((capsule) =>
            capsule.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final TimeCapsule capsule = filteredList[index];
        return ListTile(
          title: Text(capsule.title),
          subtitle: Text(
              'Unlock Date: ${DateFormat('yyyy-MM-dd').format(capsule.unlockDate)}'),
          onTap: () {
            close(context,
                capsule); 
          },
        );
      },
    );
  }
}
