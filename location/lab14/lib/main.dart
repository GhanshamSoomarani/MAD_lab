import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position? _currentPosition;
  String? _currentAddress;
  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enable Location Service"),
        ),
      );
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {}
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Location Permission Denied Go to your app "),
        ));
        return false;
      }
    }
    return true;
  }

  Future<void> _getCurrentLocation() async {
    final bool hasPermission = await _handlePermission();
    if (!hasPermission) {
      return;
    }
    try {
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
      getAddressFromCoordinates(_currentPosition!);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getAddressFromCoordinates(Position position) async {
    final List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    final place = placemark[0];
    setState(() {
      _currentAddress =
          "${place.name}, ${place.street} , ${place.locality} , ${place.country}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lab 14"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Text('LAT: ${_currentPosition?.latitude ?? ""}'),
            const SizedBox(
              height: 20,
            ),
            Text('LNG: ${_currentPosition?.longitude ?? ""}'),
            const SizedBox(
              height: 20,
            ),
            Text('ADDRESS: ${_currentAddress ?? ""}'),
            ElevatedButton(
              onPressed: () {},
              child: const Text("click here"),
            )
          ],
        ),
      ),
    );
  }
}





// const SizedBox(height: 40.0),
//             TextField(
//               controller: _emailcontroller,
//               decoration: const InputDecoration(
//                 hintText: 'University Email',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             SizedBox(height: 16.0),
//             TextField(
//               controller: _passwordcontroller,
//               decoration: const InputDecoration(
//                 hintText: 'Enter some text here',
//                 border: OutlineInputBorder(),
//               ),
//               obscureText: true,
//             ),
//             const SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {},
//               child: const Text('click here'),
//             ),


