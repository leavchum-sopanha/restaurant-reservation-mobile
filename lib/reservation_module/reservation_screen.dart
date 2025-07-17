import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_reservation_screen.dart';
import 'edit_reservation_screen.dart';
import 'reservation_api_service.dart';
import 'reservation_model.dart' as reservation;

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  late Future<List<reservation.ModelReservation>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = ReservationApiService().read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reservation Management"),
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
            CupertinoPageRoute(
              builder: (context) => const AddReservationScreen(),
            ),
          );

          if (changed == true) {
            setState(() {
              _futureData = ReservationApiService().read();
            });
          }
        },
        label: const Text("Add Reservation"),
        icon: const Icon(Icons.add_box_outlined),
      ),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _futureData = ReservationApiService().read();
        });
      },
      child: FutureBuilder<List<reservation.ModelReservation>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('FutureBuilder error: ${snapshot.error}');
            return _buildError(snapshot.error);
          }
          print('FutureBuilder state: ${snapshot.connectionState}');
          print('FutureBuilder data: ${snapshot.data}');

          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              print('No reservation items found');
              return Center(child: Text('No reservations available.'));
            } else {
              return _buildListView(snapshot.data!);
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildListView(List<reservation.ModelReservation> items) {
    debugPrint('Items in _buildListView: ${items.length}');
    if (items.isEmpty) {
      return Center(
        child: Text(
          "No reservations.",
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColorLight,
                child:
                    Icon(Icons.event_note, color: Theme.of(context).hintColor),
              ),
              title: Text(
                item.customer?.name ?? 'Unknown Customer',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    'Table #${item.table?.number ?? 'N/A'}' ?? 'N/A',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    item.dateTime != null
                        ? '${DateTime.parse(item.dateTime!).toLocal().toString().split(' ')[0]} ${DateTime.parse(item.dateTime!).toLocal().toString().split(' ')[1].substring(0, 5)}'
                        : 'N/A',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Note: ${item.note ?? 'N/A'}' ?? 'N/A',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              isThreeLine: true,
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                onPressed: () async {
                  bool? changed = await Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => EditReservationScreen(item),
                    ),
                  );

                  if (changed == true) {
                    setState(() {
                      _futureData = ReservationApiService().read();
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
            Icon(Icons.error_outline,
                size: 60, color: Theme.of(context).primaryColorDark),
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
                  _futureData = ReservationApiService().read();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
