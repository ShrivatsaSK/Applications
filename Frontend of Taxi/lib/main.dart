import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your journey begins here."),
        actions: [Icon(Icons.map)],
        leading: Icon(Icons.menu),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                RideOption(
                  imagePath: "assets/images/car.png",
                  label: "Rides",
                  subtitle: "Let’s get moving",
                ),
                RideOption(
                  imagePath: "assets/images/steering.png",
                  label: "Bolt Drive",
                  subtitle: "6 min away",
                ),
                RideOption(
                  imagePath: "assets/images/scooter.png",
                  label: "2 Wheels",
                  subtitle: "Scan and go",
                ),
                RideOption(
                  imagePath: "assets/images/schedule.png",
                  label: "Schedule",
                  subtitle: "Book ahead",
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: "Where to?",
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),
            LocationTile(
              icon: Icons.local_airport,
              title: "Terminal 1 Berlin Brandenburg Airport",
              subtitle: "Melli-Beese-Ring 1, Schönefeld",
            ),
            LocationTile(
              icon: Icons.location_on,
              title: "Berlin Central Station",
              subtitle: "Europaplatz 1, Berlin",
            ),
            LocationTile(
              icon: Icons.directions_bus,
              title: "Alexanderplatz",
              subtitle: "Mitte, Berlin",
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/car.png", height: 40, width: 40),
            label: "Rides",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class RideOption extends StatelessWidget {
  final String imagePath;
  final String label;
  final String subtitle;

  RideOption({
    required this.imagePath,
    required this.label,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 80, width: 80),
          SizedBox(height: 10),
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

class LocationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  LocationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 24, color: Colors.black),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey)),
    );
  }
}
