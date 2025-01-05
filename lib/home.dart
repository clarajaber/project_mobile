
import 'package:flutter/material.dart';
import 'login_screen.dart';

class Destination {
  final String name;
  final String description;
  final String imageUrl;
  final String location;

  const Destination({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.location,
  });
}

class Booking {
  final String name;
  final String location;
  final String type;
  final String imageUrl;

  const Booking({
    required this.name,
    required this.location,
    required this.type,
    required this.imageUrl,
  });
}

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final List<Destination> destinations = const [
    Destination(
      name: 'Beirut',
      description: 'The vibrant capital of Lebanon.',
      imageUrl: 'assets/images/beirutt.jpg',
      location: 'Beirut, Lebanon',
    ),
    Destination(
      name: 'Cedars of God',
      description: 'An ancient forest of majestic cedar trees.',
      imageUrl: 'assets/images/Cedars-of-God-Bcharre.jpg',
      location: 'Bcharre, Lebanon',
    ),
    Destination(
      name: 'Byblos',
      description: 'One of the oldest continuously inhabited cities in the world.',
      imageUrl: 'assets/images/byblos.jpg',
      location: 'Jbeil, Lebanon',
    ),
    Destination(
      name: 'Jeita Grotto',
      description: 'A spectacular limestone cave system with underground lakes.',
      imageUrl: 'assets/images/Jeita-grotto-.jpg',
      location: 'Jeita, Lebanon',
    ),
    Destination(
      name: 'Baalbek',
      description: 'A UNESCO World Heritage Site with impressive Roman ruins.',
      imageUrl: 'assets/images/baalbek.jpg',
      location: 'Baalbek, Lebanon',
    ),
    Destination(
      name: 'Tyre',
      description: 'An ancient Phoenician city with a rich history.',
      imageUrl: 'assets/images/TYRE9431.jpg',
      location: 'Sour, Lebanon',
    ),
  ];

  final List<Booking> bookings = const [
    Booking(
      name: 'Hotel Phoenicia',
      location: 'Beirut, Lebanon',
      type: 'Hotel',
      imageUrl: 'assets/images/phoenicia.jpg',
    ),
    Booking(
      name: 'Al Falamanki',
      location: 'Beirut, Lebanon',
      type: 'Restaurant',
      imageUrl: 'assets/images/al_falamanki.jpg',
    ),
    Booking(
      name: 'The Smallville Hotel',
      location: 'Beirut, Lebanon',
      type: 'Hotel',
      imageUrl: 'assets/images/Smallville.jpg',
    ),
    Booking(
      name: 'Roadster Diner',
      location: 'Beirut, Lebanon',
      type: 'Restaurant',
      imageUrl: 'assets/images/Roadster.jpg',
    ),
  ];

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _addItemsToList();
  }

  void _addItemsToList() async {
    for (int i = 0; i < destinations.length; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      _listKey.currentState?.insertItem(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome, ${widget.username}!',
          style: const TextStyle(fontSize: 22),
        ),
        backgroundColor: Colors.teal.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.currency_exchange),
            onPressed: () => showCurrencyTransferDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.book),
            onPressed: () => showBookingDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade200, Colors.teal.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: AnimatedList(
          key: _listKey,
          initialItemCount: 0,
          itemBuilder: (context, index, animation) {
            final destination = destinations[index];
            return _buildAnimatedCard(destination, animation);
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedCard(Destination destination, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: animation.drive(
          Tween(
            begin: const Offset(0, 0.2),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOut)),
        ),
        child: DestinationCard(destination: destination),
      ),
    );
  }

  void showCurrencyTransferDialog(BuildContext context) {
    // Currency transfer dialog implementation here
  }

  void showBookingDialog(BuildContext context) {
    // Booking dialog implementation here
  }
}

class DestinationCard extends StatelessWidget {
  final Destination destination;

  const DestinationCard({required this.destination, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: destination.name,
            child: Image.asset(
              destination.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              destination.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
