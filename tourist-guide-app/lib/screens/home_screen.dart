import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/app_state.dart';
import '../widgets/destination_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Popular', 'Mountains', 'Beaches', 'Cities'];

  @override
  Widget build(BuildContext context) {
    final destinationProvider = Provider.of<DestinationProvider>(context);
    final allDestinations = destinationProvider.destinations;

    // Filter logic
    var filteredDestinations = allDestinations.where((dest) {
      final matchesSearch = dest.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          dest.city.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          dest.country.toLowerCase().contains(_searchQuery.toLowerCase());
      
      bool matchesCategory = true;
      if (_selectedCategory != 'All') {
        if (_selectedCategory == 'Popular') {
          matchesCategory = dest.rating >= 4.8;
        } else {
          matchesCategory = dest.description.toLowerCase().contains(_selectedCategory.toLowerCase().substring(0, _selectedCategory.length - 1));
          if (!matchesCategory && dest.rating >= 4.9) matchesCategory = true;
        }
      }

      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Discover',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Explore the beauty of the world!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      return CircleAvatar(
                        radius: 24,
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        backgroundImage: auth.user?.photoURL != null ? NetworkImage(auth.user!.photoURL!) : null,
                        child: auth.user?.photoURL == null ? const Icon(Icons.person, color: Colors.white) : null,
                      );
                    },
                  ),
                ],
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search places, cities...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Category Filter (Horizontal Scroll)
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: _buildCategoryChip(category, isSelected, context),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            // Expanded List View for Cards
            Expanded(
              child: destinationProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredDestinations.isEmpty
                      ? Center(
                          child: Text(
                            'No destinations found.',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 100),
                          itemCount: filteredDestinations.length,
                          itemBuilder: (context, index) {
                            final destination = filteredDestinations[index];
                            return DestinationCard(destination: destination);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isSelected ? null : Border.all(color: Colors.grey[300]!),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
