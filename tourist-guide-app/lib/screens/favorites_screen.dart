import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../data/dummy_data.dart';
import '../widgets/destination_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Text(
                'Favorites',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
            Expanded(
              child: Consumer2<BookmarkProvider, DestinationProvider>(
                builder: (context, bookmarkProvider, destProvider, child) {
                  final favoriteDestinations = destProvider.destinations
                      .where((dest) => bookmarkProvider.isFavorite(dest.id))
                      .toList();

                  if (destProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (favoriteDestinations.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No favorites yet',
                            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start exploring and save your favorite places!',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 120),
                    itemCount: favoriteDestinations.length,
                    itemBuilder: (context, index) {
                      return DestinationCard(destination: favoriteDestinations[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
