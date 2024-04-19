import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  // Function to simulate data fetch
  Future<void> _refreshData() async {
    // In a real app, you would replace this with a data fetch call
    await Future.delayed(Duration(seconds: 2));
  }

  void _showLongPressToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text('Long press detected'),
        action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Vault Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search or filter capsules...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onSubmitted: (String value) {
                  // Handle search or filter action
                },
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Welcome to Time Vault!'),
                  ElevatedButton(
                    child: Text('Create Capsule'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/create');
                    },
                    onLongPress: () {
                      _showLongPressToast(context);
                    },
                  ),
                  ElevatedButton(
                    child: Text('View Capsules'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/list');
                    },
                    onLongPress: () {
                      _showLongPressToast(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
