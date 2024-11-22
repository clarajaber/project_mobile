import 'package:flutter/material.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
      description:
      'One of the oldest continuously inhabited cities in the world.',
      imageUrl: 'assets/images/byblos.jpg',
      location: 'Jbeil, Lebanon',
    ),
    Destination(
      name: 'Jeita Grotto',
      description:
      'A spectacular limestone cave system with underground lakes.',
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
        title: const Text(
          'Hidden Gems of Lebanon',
          style: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.teal.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.currency_exchange),
            onPressed: () => showCurrencyTransferDialog(context),
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

  Widget _buildAnimatedCard(
      Destination destination, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: animation.drive(
          Tween(
            begin: const Offset(0, 0.2),
            end: Offset.zero,
          ).chain(
            CurveTween(curve: Curves.easeOut),
          ),
        ),
        child: DestinationCard(destination: destination),
      ),
    );
  }
}

void showCurrencyTransferDialog(BuildContext context) {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController feeController = TextEditingController();

  double totalAmount = 0.0;
  String fromCurrency = 'USD';
  String toCurrency = 'EUR';

  final Map<String, double> exchangeRates = {
    'USD': 1.0,
    'EUR': 0.85,
    'LBP': 89000.0,
  };

  void calculateTotal() {
    final double amount = double.tryParse(amountController.text) ?? 0.0;
    final double fee = double.tryParse(feeController.text) ?? 0.0;

    if (amount > 0) {
      final double rateFrom = exchangeRates[fromCurrency]!;
      final double rateTo = exchangeRates[toCurrency]!;
      final double convertedAmount = (amount / rateFrom) * rateTo;
      totalAmount = convertedAmount + (convertedAmount * fee / 100);
    } else {
      totalAmount = 0.0;
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                gradient: LinearGradient(
                  colors: [Colors.teal.shade400, Colors.teal.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dialog Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.teal.shade800,
                      ),
                      child: const Center(
                        child: Text(
                          'Currency Transfer',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(calculateTotal);
                      },
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        prefixIcon: const Icon(Icons.money),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: fromCurrency,
                            onChanged: (value) {
                              setState(() {
                                fromCurrency = value!;
                                calculateTotal();
                              });
                            },
                            items: exchangeRates.keys.map((currency) {
                              return DropdownMenuItem(
                                value: currency,
                                child: Text(currency),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'From',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: toCurrency,
                            onChanged: (value) {
                              setState(() {
                                toCurrency = value!;
                                calculateTotal();
                              });
                            },
                            items: exchangeRates.keys.map((currency) {
                              return DropdownMenuItem(
                                value: currency,
                                child: Text(currency),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'To',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: feeController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(calculateTotal);
                      },
                      decoration: InputDecoration(
                        labelText: 'Fee (%)',
                        prefixIcon: const Icon(Icons.percent),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    if (totalAmount > 0)
                      Text(
                        'Total: ${totalAmount.toStringAsFixed(2)} $toCurrency',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    const SizedBox(height: 16),
                    // Close Button
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        child: Text(
                          'Close',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Set the text color to white
                          ),
                        ),
                      ),

                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}


class DestinationCard extends StatelessWidget {
  final Destination destination;

  const DestinationCard({required this.destination, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 12.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      shadowColor: Colors.teal.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: destination.name,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20.0),
              ),
              child: Image.asset(
                destination.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  destination.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Route _createRoute(Destination destination) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        AttractionDetailScreen(destination: destination),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

class AttractionDetailScreen extends StatelessWidget {
  final Destination destination;
  const AttractionDetailScreen({required this.destination, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade700,
      appBar: AppBar(
        title: Text(
          destination.name,
          style: const TextStyle(
            fontFamily: 'Raleway',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal.shade700,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Colors.teal.shade700,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: destination.name,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.asset(
                      destination.imageUrl,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  destination.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  destination.description,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Location: ${destination.location}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
