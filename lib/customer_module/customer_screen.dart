import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'add_customer_screen.dart';
import 'edit_customer_screen.dart';
import 'customer_api_service.dart';
import 'customer_model.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  late Future<List<ModelCustomer>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = CustomerApiService().read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Management"),
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
            CupertinoPageRoute(builder: (context) => const AddCustomerScreen()),
          );

          if (changed == true) {
            setState(() {
              _futureData = CustomerApiService().read();
            });
          }
        },
        label: const Text("Add Customer"),
        icon: const Icon(Icons.person_add_alt_1),
      ),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _futureData = CustomerApiService().read();
        });
      },
      child: FutureBuilder<List<ModelCustomer>>(
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

  Widget _buildListView(List<ModelCustomer> items) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          "No customers available.",
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
                child: Icon(Icons.person, color: Theme.of(context).hintColor),
              ),
              title: Text(
                item.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    item.phone,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    item.email,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              isThreeLine: true,
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                onPressed: () async {
                  bool? changed = await Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => EditCustomerScreen(item),
                    ),
                  );

                  if (changed == true) {
                    setState(() {
                      _futureData = CustomerApiService().read();
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
                  _futureData = CustomerApiService().read();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}


