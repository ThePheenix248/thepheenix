import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Sharing App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  void _signInAnonymously(BuildContext context) {
    debugPrint("User signed in anonymously");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreenAccent.shade100,
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _signInAnonymously(context),
          child: const Text('Sign in Anonymously', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Column(
        children: const [
          Expanded(child: FoodListScreen()),
        ],
      ),
    );
  }
}

class FoodListScreen extends StatelessWidget {
  const FoodListScreen({super.key});

  final List<Map<String, dynamic>> foodListings = const [
    {'lat': 37.7749, 'lng': -122.4194, 'description': 'Pizza available!'},
    {'lat': 37.7799, 'lng': -122.4144, 'description': 'Fresh vegetables!'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: foodListings.length,
      itemBuilder: (context, index) {
        final food = foodListings[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 5,
          child: ListTile(
            tileColor: Colors.white,
            leading: const Icon(Icons.fastfood, color: Colors.green, size: 30),
            title: Text(
              food['description'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            subtitle: Text(
              'Location: (${food['lat']}, ${food['lng']})',
              style: TextStyle(color: Colors.grey[700]),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.green),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodDetailScreen(food: food),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class FoodDetailScreen extends StatelessWidget {
  final Map<String, dynamic> food;
  const FoodDetailScreen({super.key, required this.food});

  void _openMap() async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${food['lat']},${food['lng']}';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              food['description'],
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green[800]),
            ),
            const SizedBox(height: 10),
            Text('Latitude: ${food['lat']}', style: const TextStyle(fontSize: 16)),
            Text('Longitude: ${food['lng']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: _openMap,
              icon: const Icon(Icons.map, color: Colors.white),
              label: const Text('View on Google Maps', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
