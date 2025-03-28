import 'package:flutter/material.dart';
import 'models.dart';
import 'video_card.dart';
import 'video_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Video>? _searchResults;
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = null;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final results = await VideoService.searchVideos(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search YouTube',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchResults = null;
                });
              },
            ),
          ),
          onSubmitted: _performSearch,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _performSearch(_searchController.text),
          ),
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () {},
          ),
        ],
      ),
      body: _isSearching
          ? const Center(child: CircularProgressIndicator())
          : _searchResults == null
              ? _buildSearchSuggestions()
              : _searchResults!.isEmpty
                  ? const Center(child: Text('No results found'))
                  : ListView.builder(
                      itemCount: _searchResults!.length,
                      itemBuilder: (context, index) {
                        return VideoCard(video: _searchResults![index]);
                      },
                    ),
    );
  }

  Widget _buildSearchSuggestions() {
    return ListView(
      children: [
        _buildSearchHistoryItem('flutter tutorial'),
        _buildSearchHistoryItem('dart programming'),
        _buildSearchHistoryItem('supabase flutter'),
        _buildSearchHistoryItem('mobile app development'),
        _buildSearchHistoryItem('flutter state management'),
      ],
    );
  }

  Widget _buildSearchHistoryItem(String query) {
    return ListTile(
      leading: const Icon(Icons.history),
      title: Text(query),
      trailing: const Icon(Icons.north_west),
      onTap: () {
        _searchController.text = query;
        _performSearch(query);
      },
    );
  }
}

