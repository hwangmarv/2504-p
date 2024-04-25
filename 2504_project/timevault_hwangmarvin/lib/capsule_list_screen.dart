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

  // Remove the late initializer for _capsuleBox
  Box<TimeCapsule>? _capsuleBox;

  // Modify the _openBox method to return a Future<Box<TimeCapsule>>
  Future<Box<TimeCapsule>> _openBox() async {
    return Hive.openBox<TimeCapsule>('capsuleBox');
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
                if (_capsuleBox != null) {
                  showSearch(context: context, delegate: CapsuleSearch(_capsuleBox!));
                }
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: _openBox(),
          builder: (context, AsyncSnapshot<Box<TimeCapsule>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error opening the capsule box.'));
            } else {
              _capsuleBox = snapshot.data; // Now the _capsuleBox is assigned
              return ValueListenableBuilder(
                valueListenable: _capsuleBox!.listenable(),
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
              );
            }
          },
        ),
    );
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

deleteCapsule(int index) {
}

archiveCapsule(int index) {
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
        close(context, TimeCapsule(title: '', message: '', description: '', unlockDate: DateTime.now()));
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
