import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'data/time_capsule.dart'; 
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> fetchWeather(String date, String location) async {
  var response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$location&date=$date&appid=17377a4e3159299707015c4a0e62f494'));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    // Process and use the weather data
    print(data);
  } else {
    // Handle errors
    throw Exception('Failed to load weather data');
  }
}

class CapsuleListScreen extends StatefulWidget {
  @override
  _CapsuleListScreenState createState() => _CapsuleListScreenState();
}

class _CapsuleListScreenState extends State<CapsuleListScreen> {
  late final Box<TimeCapsule> _capsuleBox;

  @override
  void initState() {
    super.initState();
    // Asynchronously open the Hive box
    _initializeHiveBox();
  }

  Future<void> _initializeHiveBox() async {
    _capsuleBox = await Hive.openBox<TimeCapsule>('capsuleBox');
    // The setState is only needed if you're going to update the UI once the box is opened
    setState(() {});
  }

  void _deleteCapsule(int index) {
    setState(() {
      _capsuleBox.deleteAt(index);
    });
  }

  Widget _buildCapsuleItem(BuildContext context, int index) {
    final capsule = _capsuleBox.getAt(index);

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: ListTile(
        title: Text(capsule?.title ?? ''),
        subtitle: Text('Unlock Date: ${capsule?.unlockDate.toString() ?? ''}'),
        onTap: () {
          // Handle the tap event, for example, navigate to a detail view
        },
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _deleteCapsule(index),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capsule List'),
      ),
      body: FutureBuilder(
        future: Hive.openBox<TimeCapsule>('capsuleBox'),
        builder: (context, AsyncSnapshot<Box<TimeCapsule>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error opening Hive box.'));
            }
            // Box is opened successfully
            final box = snapshot.data!;
            return ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box<TimeCapsule> box, _) {
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    return _buildCapsuleItem(context, index);
                  },
                );
              },
            );
          } else {
            // While the box is opening, show a loading indicator
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _capsuleBox.close(); // Don't forget to close the Hive box when the widget is disposed
    super.dispose();
  }
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
