import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/time_capsule.dart'; // Make sure this import points to your TimeCapsule class

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  Box<TimeCapsule>? _capsuleBox;

  @override
  void initState() {
    super.initState();
    _initializeHiveBox();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _capsuleBox?.close(); // Close the Hive box when the widget is disposed
    super.dispose();
  }

  Future<void> _initializeHiveBox() async {
    _capsuleBox = await Hive.openBox<TimeCapsule>('capsuleBox');
  }

  // Function to clear the search bar and refresh the screen
  void _clearSearchAndRefresh() {
    _searchController.clear();
    setState(() {});
  }

  void _handleSearch(String query) {
    setState(() {}); // This refreshes the UI with each keystroke
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Vault Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _clearSearchAndRefresh,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Add your refresh logic here
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Time Vaults...',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: _clearSearchAndRefresh, // Clears the search field and search results
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: _handleSearch,
              ),
            ),
            // Only display search results if there is a search query
            Expanded(
              child: _searchController.text.isEmpty
                  ? Center(child: Text('Type above to search Time Vaults'))
                  : FutureBuilder(
                      future: Hive.openBox<TimeCapsule>('capsuleBox'),
                      builder: (BuildContext context, AsyncSnapshot<Box<TimeCapsule>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else {
                            var filteredCapsules = snapshot.data!.values
                                .where((capsule) =>
                                    capsule.title.toLowerCase().contains(_searchController.text.toLowerCase()))
                                .toList();

                            return ListView.builder(
                              itemCount: filteredCapsules.length,
                              itemBuilder: (context, index) {
                                final capsule = filteredCapsules[index];
                                return ListTile(
                                  title: Text(capsule.title),
                                  subtitle: Text('Unlock Date: ${capsule.unlockDate.toString()}'),
                                  onTap: () {
                                    // Handle tap, possibly navigate to a detail view
                                  },
                                );
                              },
                            );
                          }
                        } else {
                          // Show a loading indicator while waiting for the Hive box
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
            ),
            ElevatedButton(
              child: Text('Create Capsule'),
              onPressed: () {
                Navigator.pushNamed(context, '/create');
              },
            ),
            ElevatedButton(
              child: Text('View Capsules'),
              onPressed: () {
                Navigator.pushNamed(context, '/list');
              },
            ),
          ],
        ),
      ),
    );
  }
}
