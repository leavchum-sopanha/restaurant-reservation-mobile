import 'package:flutter/material.dart';
import 'package:app1/customer_module/customer_api_service.dart'; // Assuming this path
import 'package:app1/table_module/table_api_service.dart'; // Assuming this path
import 'package:app1/customer_module/customer_model.dart'; // Assuming this path
import 'package:app1/table_module/table_model.dart'; // Assuming this path

import 'reservation_api_service.dart';
import 'reservation_model.dart' as reservation;
import 'message_util.dart';

class AddReservationScreen extends StatefulWidget {
  const AddReservationScreen({super.key});

  @override
  State<AddReservationScreen> createState() => _AddReservationScreenState();
}

class _AddReservationScreenState extends State<AddReservationScreen> {
  bool _changed = false;
  final _formKey = GlobalKey<FormState>();

  ModelCustomer? _selectedCustomer;
  ModelTable? _selectedTable;
  List<ModelCustomer> _customers = [];
  List<ModelTable> _tables = [];

  final _dateTimeCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
    _fetchTables();
  }

  Future<void> _fetchCustomers() async {
    try {
      final customers = await CustomerApiService().read();
      setState(() {
        _customers = customers.cast<ModelCustomer>();
        // Set initial selected customer if available
        if (_customers.isNotEmpty) {
          _selectedCustomer = _customers.first;
        }
      });
    } catch (e) {
      showSnackBar(context, 'Failed to load customers: $e');
    }
  }

  Future<void> _fetchTables() async {
    try {
      final tables = await TableApiService().read();
      setState(() {
        _tables = tables.cast<ModelTable>();
        // Set initial selected table if available
        if (_tables.isNotEmpty) {
          _selectedTable = _tables.first;
        }
      });
    } catch (e) {
      showSnackBar(context, 'Failed to load tables: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.of(context).pop(_changed);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add New Reservation"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(_changed),
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
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const SizedBox(height: 20),
            _buildCustomerDropdown(context),
            const SizedBox(height: 20),
            _buildTableDropdown(context),
            const SizedBox(height: 20),
            _buildDateTimeTextField(context),
            const SizedBox(height: 20),
            _buildNoteTextField(context),
            const SizedBox(height: 40),
            _buildSaveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerDropdown(BuildContext context) {
    return DropdownButtonFormField<ModelCustomer>(
      value: _selectedCustomer,
      decoration: InputDecoration(
        labelText: "Select Customer",
        prefixIcon: Icon(Icons.person, color: Theme.of(context).primaryColor),
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).hintColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Theme.of(context).primaryColorLight, width: 1),
        ),
        filled: true,
        fillColor: Theme.of(context).cardColor,
      ),
      items: _customers.map((customer) {
        return DropdownMenuItem(
          value: customer,
          child: Text('${customer.name} (ID: ${customer.id})'),
        );
      }).toList(),
      onChanged: (customer) {
        setState(() {
          _selectedCustomer = customer;
        });
      },
      validator: (customer) => customer == null ? "Customer is required" : null,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  Widget _buildTableDropdown(BuildContext context) {
    return DropdownButtonFormField<ModelTable>(
      value: _selectedTable,
      decoration: InputDecoration(
        labelText: "Select Table",
        prefixIcon:
            Icon(Icons.table_bar, color: Theme.of(context).primaryColor),
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).hintColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Theme.of(context).primaryColorLight, width: 1),
        ),
        filled: true,
        fillColor: Theme.of(context).cardColor,
      ),
      items: _tables.map((table) {
        return DropdownMenuItem(
          value: table,
          child: Text('Table ${table.number} (Capacity: ${table.capacity})'),
        );
      }).toList(),
      onChanged: (table) {
        setState(() {
          _selectedTable = table;
        });
      },
      validator: (table) => table == null ? "Table is required" : null,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  Widget _buildDateTimeTextField(BuildContext context) {
    return TextFormField(
      controller: _dateTimeCtrl,
      keyboardType: TextInputType.none,
      readOnly: true,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (pickedTime != null) {
            final DateTime combined = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
            final String formatted =
                "${combined.year.toString().padLeft(4, '0')}-${combined.month.toString().padLeft(2, '0')}-${combined.day.toString().padLeft(2, '0')} "
                "${combined.hour.toString().padLeft(2, '0')}:${combined.minute.toString().padLeft(2, '0')}";
            _dateTimeCtrl.text = formatted;
          }
        }
      },
      decoration: InputDecoration(
        labelText: "Date & Time (YYYY-MM-DD HH:MM)",
        prefixIcon:
            Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).hintColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Theme.of(context).primaryColorLight, width: 1),
        ),
        filled: true,
        fillColor: Theme.of(context).cardColor,
      ),
      validator: (text) {
        if (text == null || text.trim().isEmpty)
          return "Date & Time is required";
        try {
          DateTime.parse(text.trim().replaceFirst(' ', 'T'));
        } catch (e) {
          return "Enter a valid date and time (YYYY-MM-DD HH:MM)";
        }
        return null;
      },
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  Widget _buildNoteTextField(BuildContext context) {
    return TextFormField(
      controller: _noteCtrl,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Note",
        prefixIcon: Icon(Icons.note, color: Theme.of(context).primaryColor),
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).hintColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Theme.of(context).primaryColorLight, width: 1),
        ),
        filled: true,
        fillColor: Theme.of(context).cardColor,
      ),
      validator: (text) =>
          (text == null || text.trim().isEmpty) ? "Note is required" : null,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      height: 55,
      child: ElevatedButton.icon(
        onPressed: _saveReservation,
        icon: const Icon(Icons.save),
        label: const Text("SAVE RESERVATION"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).hintColor,
          foregroundColor: Colors.white,
          textStyle: Theme.of(context).textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
        ),
      ),
    );
  }

  void _saveReservation() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCustomer == null || _selectedTable == null) {
        showSnackBar(context, "Please select a customer and a table.");
        return;
      }

      final item = reservation.ModelReservation(
        id: 0,
        customerId: _selectedCustomer!.id,
        tableId: _selectedTable!.id,
        dateTime: _dateTimeCtrl.text.trim(),
        note: _noteCtrl.text.trim(),
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        customer: _selectedCustomer,
        table: _selectedTable,
      );

      ReservationApiService().post(item).then((value) {
        if (value == true) {
          _changed = true;
          showSnackBar(context, "Reservation added successfully!");

          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.of(context).pop(true);
          });
        }
      }).onError((e, trace) {
        showSnackBar(context, e.toString());
      }).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          showSnackBar(context, "Request timed out. Please try again.");
        },
      );
    }
  }
}


