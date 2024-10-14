import 'package:flutter/material.dart';
import 'package:pks6/components/item.dart';
import 'package:pks6/model/product.dart';
import 'package:pks6/pages/add_car_page.dart';

class HomePage extends StatefulWidget {
  final Function(Car) onFavoriteToggle;
  final List<Car> favoriteCars;
  final Function(Car) onAddToCart;

  const HomePage({
    super.key,
    required this.onFavoriteToggle,
    required this.favoriteCars,
    required this.onAddToCart,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Car> cars = List.from(initialCars);

  void _addNewCar(Car car) {
    setState(() {
      cars.add(car);
    });
  }

  void _removeCar(int id) {
    setState(() {
      cars.removeWhere((car) => car.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'BMW Модели',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.blueGrey,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: cars.isNotEmpty
              ? GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: cars.length,
            itemBuilder: (BuildContext context, int index) {
              final car = cars[index];
              final isFavorite = widget.favoriteCars.contains(car);
              return Dismissible(
                key: Key(car.id.toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _removeCar(car.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${car.title} удален")),
                  );
                },
                child: ItemNote(
                  car: car,
                  isFavorite: isFavorite,
                  onFavoriteToggle: () => widget.onFavoriteToggle(car),
                  onAddToCart: () => widget.onAddToCart(car),
                ),
              );
            },
          )
              : const Center(child: Text('Нет доступных автомобилей')),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final newCar = await Navigator.push<Car>(
              context,
              MaterialPageRoute(builder: (context) => const AddCarPage()),
            );
            if (newCar != null) {
              _addNewCar(newCar);
            }
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.blueGrey,
        ),
      ),
    );
  }
}
