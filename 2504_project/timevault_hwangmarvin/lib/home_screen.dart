import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/time_capsule.dart';
import 'package:http/http.dart' as http;

class WeatherApi {
  final String apiKey;

  WeatherApi(this.apiKey);

  Future<Map<String, dynamic>> getWeather(String city) async {
    final response = await http.get(
      'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey' as Uri,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

class RotatingLogo extends StatefulWidget {
  @override
  _RotatingLogoState createState() => _RotatingLogoState();
}

class _RotatingLogoState extends State<RotatingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.refresh, size: 50),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  Box<TimeCapsule>? _capsuleBox;
  final weatherApi = WeatherApi('17377a4e3159299707015c4a0e62f494');

  Map<String, dynamic>? _weatherData;

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

  void _fetchWeather() async {
    final weatherData = await weatherApi.getWeather('London');
    setState(() {
      _weatherData = weatherData;
    });
  }

  double _convertKelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Vault Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchWeather,
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
                    onPressed:
                        _clearSearchAndRefresh, // Clears the search field and search results
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: _handleSearch,
              ),
            ),
            // Only display search results if there is a search query
            if (_weatherData != null)
              Text(
                'Temperature in London: ${_convertKelvinToCelsius(_weatherData!['main']['temp']).toStringAsFixed(2)}°C',
              ),
            Expanded(
              child: _searchController.text.isEmpty
                  ? Center(child: Text('Type above to search Time Vaults'))
                  : FutureBuilder(
                      future: Hive.openBox<TimeCapsule>('capsuleBox'),
                      builder: (BuildContext context,
                          AsyncSnapshot<Box<TimeCapsule>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            var filteredCapsules = snapshot.data!.values
                                .where((capsule) => capsule.title
                                    .toLowerCase()
                                    .contains(
                                        _searchController.text.toLowerCase()))
                                .toList();

                            return ListView.builder(
                              itemCount: filteredCapsules.length,
                              itemBuilder: (context, index) {
                                final capsule = filteredCapsules[index];
                                return ListTile(
                                  title: Text(capsule.title),
                                  subtitle: Text(
                                      'Unlock Date: ${capsule.unlockDate.toString()}'),
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
            RotatingLogo(),
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