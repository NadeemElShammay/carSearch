import 'package:flutter/material.dart';
import 'car.dart';
import 'api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Car> _cars = [];
  List<Car> _filteredCars = [];
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCars();
  }

  Future<void> _fetchCars() async {
    try {
      final cars = await ApiService.fetchCars();
      setState(() {
        _cars = cars;
        _filteredCars = cars;
      });
    } catch (e) {
      print('Error fetching cars: $e');
    }
  }

  void _filterByPriceRange() {
    final String minPriceText = _minPriceController.text;
    final String maxPriceText = _maxPriceController.text;

    if (minPriceText.isEmpty || maxPriceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both minimum and maximum prices')),
      );
      return;
    }

    final double? minPrice = double.tryParse(minPriceText);
    final double? maxPrice = double.tryParse(maxPriceText);

    if (minPrice == null || maxPrice == null || minPrice > maxPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid price range')),
      );
      return;
    }

    setState(() {
      _filteredCars = _cars.where((car) {
        final double carPrice = double.parse(car.price);
        return carPrice >= minPrice && carPrice <= maxPrice;
      }).toList();
    });
  }

  void _showAllCars() {
    setState(() {
      _filteredCars = _cars;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Cars by Price Range')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Min Price',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Max Price',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _filterByPriceRange,
                  child: const Text('Search'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showAllCars,
              child: const Text('Show All'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredCars.isEmpty
                  ? const Center(child: Text('No cars found.'))
                  : ListView.builder(
                itemCount: _filteredCars.length,
                itemBuilder: (context, index) {
                  final car = _filteredCars[index];
                  return ListTile(
                    title: Text(car.name),
                    subtitle: Text('Model: ${car.model} - Price: \$${car.price}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }
}
