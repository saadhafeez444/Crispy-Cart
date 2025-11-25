import 'package:flutter/material.dart';
import 'package:crispycart/screens/favourites.dart';
import 'package:crispycart/screens/home.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepOrange),
            child: Text('CrispyCart!', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            trailing: Icon(Icons.home),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => const HomeScreen(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            trailing: Icon(Icons.favorite_outline_sharp),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const FavoritesScreen(),
              ));
            },
          ),
        ],
      ),
    );
  }
}
