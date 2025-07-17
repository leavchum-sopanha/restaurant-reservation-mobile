import 'package:flutter/material.dart';

import 'message_util.dart';
import 'table_api_service.dart';
import 'table_model.dart';

class EditTableScreen extends StatefulWidget {
  final ModelTable item;

  const EditTableScreen(this.item, {super.key});

  @override
  State<EditTableScreen> createState() => _EditTableScreenState();
}

class _EditTableScreenState extends State<EditTableScreen> {
  bool _changed = false;
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _numberCtrl = TextEditingController(
    text: widget.item.number.toString(),
  );
  late final TextEditingController _capacityCtrl = TextEditingController(
    text: widget.item.capacity.toString(),
  );

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
          title: const Text("Edit Table"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop(_changed);
            },
          ),
          actions: [_buildDeleteIcon(context)],
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

  Widget _buildDeleteIcon(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete_forever, color: Theme.of(context).colorScheme.error),
      tooltip: 'Delete table',
      onPressed: () async {
        final confirmed =
            await showMessageBox(
              context,
              "Delete Table",
              "Are you sure you want to delete this table? This action cannot be undone.",
            ) ??
            false;

        if (confirmed) {
          TableApiService()
              .delete(widget.item.id)
              .then((value) {
                if (value == true) {
                  _changed = true;
                  showSnackBar(context, "Table deleted successfully!");
                  Navigator.of(context).pop(_changed);
                }
              })
              .onError((e, trace) {
                showSnackBar(context, e.toString());
              })
              .timeout(
                const Duration(seconds: 30),
                onTimeout: () {
                  showSnackBar(context, "Request timed out. Please try again.");
                },
              );
        }
      },
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
            _buildTextField(
              _numberCtrl,
              "Table Number",
              Icons.table_bar,
              context,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              _capacityCtrl,
              "Capacity",
              Icons.people,
              context,
            ),
            const SizedBox(height: 40),
            _buildSaveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    BuildContext context,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).hintColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColorLight, width: 1),
        ),
        filled: true,
        fillColor: Theme.of(context).cardColor,
      ),
      validator: (text) {
        if (text == null || text.trim().isEmpty) return "$label is required";
        if (int.tryParse(text.trim()) == null) return "Enter a valid number";
        return null;
      },
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      height: 55,
      child: ElevatedButton.icon(
        onPressed: _updateTable,
        icon: const Icon(Icons.save),
        label: const Text("UPDATE TABLE"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).hintColor, // Gold button
          foregroundColor: Colors.white, // White text
          textStyle: Theme.of(context).textTheme.labelLarge, // Use defined text style
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
        ),
      ),
    );
  }

  void _updateTable() {
    if (_formKey.currentState!.validate()) {
      final item = ModelTable(
        id: widget.item.id,
        number: int.parse(_numberCtrl.text.trim()),
        capacity: int.parse(_capacityCtrl.text.trim()),
        createdAt: widget.item.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
        reservations: widget.item.reservations,
      );

      TableApiService()
          .update(item)
          .then((value) {
            if (value == true) {
              _changed = true;
              showSnackBar(context, "Updated Successfully");

              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.of(context).pop(true);
              });
            }
          })
          .onError((e, trace) {
            showSnackBar(context, e.toString());
          })
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              showSnackBar(context, "Timeout Error");
            },
          );
    }
  }
}


