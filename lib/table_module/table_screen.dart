import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_table_screen.dart';
import 'edit_table_screen.dart';
import 'table_api_service.dart';
import 'table_model.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  late Future<List<ModelTable>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = TableApiService().read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Table Management"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).primaryColorLight.withOpacity(0.2),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          bool? changed = await Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => const AddTableScreen()),
          );

          if (changed == true) {
            setState(() {
              _futureData = TableApiService().read();
            });
          }
        },
        label: const Text("Add Table"),
        icon: const Icon(Icons.add_box_outlined),
      ),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _futureData = TableApiService().read();
        });
      },
      child: FutureBuilder<List<ModelTable>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildError(snapshot.error);
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return _buildListView(snapshot.data ?? []);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildListView(List<ModelTable> items) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          "No tables available.",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColorLight,
                child: Icon(Icons.table_restaurant, color: Theme.of(context).hintColor),
              ),
              title: Text(
                "Table ${item.number}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                "Capacity: ${item.capacity}\nReservations: ${item.reservations.length}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              isThreeLine: true,
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                onPressed: () async {
                  bool? changed = await Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => EditTableScreen(item),
                    ),
                  );

                  if (changed == true) {
                    setState(() {
                      _futureData = TableApiService().read();
                    });
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildError(Object? error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Theme.of(context).primaryColorDark),
            const SizedBox(height: 16),
            Text(
              "Error loading data:",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              onPressed: () {
                setState(() {
                  _futureData = TableApiService().read();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}


