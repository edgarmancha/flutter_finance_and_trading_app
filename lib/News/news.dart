import 'package:finance/News/posttile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../auth/wp_api.dart';

class NewsDashboard extends StatefulWidget {
  const NewsDashboard({super.key});

  @override
  State<NewsDashboard> createState() => _NewsDashboardState();
}

class _NewsDashboardState extends State<NewsDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<int> _categoryIds = [
    1, // Replace with actual category IDs
    2,
    3,
  ];
  final List<String> _categoryTitles = [
    'Category 1',
    'Category 2',
    'Category 3',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _categoryIds.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _categoryTitles.map((title) => Tab(text: title)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:
            _categoryIds.map((slug) => _buildCategory(slug as String)).toList(),
      ),
    );
  }

  Widget _buildCategory(String categorySlug) {
    return FutureBuilder<List<Post>>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return NewsPostTile(post: snapshot.data![index]);
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('${snapshot.error}'),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
