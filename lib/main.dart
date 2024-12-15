import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/favorites_page.dart';
import 'pages/profile_page.dart';
import 'models/note.dart';
import 'models/api_service.dart';
import 'pages/cart_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
      ),
      themeMode: ThemeMode.system,
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final List<Note> notes = [];
  final List<Note> favoriteNotes = [];
  final List<Note> cartItems = [];

  void _editNote(Note updatedNote) {
    setState(() {
      final index = notes.indexWhere((note) => note.id == updatedNote.id);
      if (index != -1) {
        notes[index] = updatedNote; // Обновляем данные в списке
      }
    });
  }

  void _toggleFavorite(Note note) {
    setState(() {
      note.isFavorite = !note.isFavorite;
      if (note.isFavorite) {
        if (!favoriteNotes.contains(note)) {
          favoriteNotes.add(note);
        }
      } else {
        favoriteNotes.removeWhere((item) => item.id == note.id);
      }
    });
  }

  void _addNote(Note note) {
    setState(() {
      notes.add(note);
    });
  }

  void _deleteNote(Note note) {
    setState(() {
      notes.remove(note);
      favoriteNotes.remove(note);
      cartItems.remove(note);
    });
  }

  void _addToCart(Note note) async {
    try {
      await ApiService().addToCart(1, note.id); // Передайте реальный userId вместо 1
      setState(() {
        if (!cartItems.contains(note)) {
          cartItems.add(note); // Добавляем элемент в локальную корзину
        }
      });
    } catch (e) {
      print('Ошибка добавления в корзину: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка добавления в корзину')),
      );
    }
  }

  void removeFromCart(Note note) async {
    try {
      await ApiService().removeFromCart(1, note.id); // Удаляем с сервера
      setState(() {
        cartItems.remove(note); // Удаляем из локального списка
      });
    } catch (e) {
      print('Ошибка удаления из корзины: $e');
    }
  }


  List<Widget> get _pages => [
    HomePage(
      onToggleFavorite: _toggleFavorite,
      onAddNote: _addNote,
      onDeleteNote: _deleteNote,
      cartItems: cartItems,
      onAddToCart: _addToCart,
      onEditNote: _editNote,
    ),
    FavoritesPage(
      favoriteNotes: favoriteNotes,
      onToggleFavorite: _toggleFavorite,
    ),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Future<void> _loadCartItems() async {
    try {
      final fetchedCartItems = await ApiService().getCart(1); // Используйте реальный userId

      setState(() {
        cartItems.clear();
      });

      for (var cartItem in fetchedCartItems) {
        try {
          final apartment = await ApiService().getApartmentById(cartItem.apartmentId); // Загружаем данные квартиры
          setState(() {
            cartItems.add(
              Note(
                id: apartment.id,
                title: apartment.title,
                description: apartment.description,
                photo_id: apartment.photo_id,
                price: apartment.price,
                isFavorite: false, // Настройте по необходимости
              ),
            );
          });
        } catch (e) {
          print('Ошибка загрузки данных квартиры: $e');
        }
      }

      print('Корзина успешно загружена');
    } catch (e) {
      print('Ошибка загрузки корзины: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка загрузки корзины')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _loadCartItems(); // Загружаем данные корзины
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartPage(cartItems: cartItems),
            ),
          );
        },
        child: const Icon(Icons.shopping_cart),
      ),

    );
  }
}
