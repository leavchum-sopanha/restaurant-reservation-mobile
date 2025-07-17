import 'package:flutter/material.dart';

import 'message_util.dart';
import 'customer_api_service.dart';
import 'customer_model.dart';

class EditCustomerScreen extends StatefulWidget {
  final ModelCustomer item;

  const EditCustomerScreen(this.item, {super.key});

  @override
  State<EditCustomerScreen> createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  bool _changed = false;
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl = TextEditingController(
    text: widget.item.name,
  );
  late final TextEditingController _phoneCtrl = TextEditingController(
    text: widget.item.phone,
  );
  late final TextEditingController _emailCtrl = TextEditingController(
    text: widget.item.email,
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
          title: const Text("Edit Customer"),
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
      tooltip: 'Delete customer',
      onPressed: () async {
        final confirmed =
            await showMessageBox(
              context,
              "Delete Customer",
              "Are you sure you want to delete this customer? This action cannot be undone.",
            ) ??
            false;

        if (confirmed) {
          CustomerApiService()
              .delete(widget.item.id)
              .then((value) {
                if (value == true) {
                  _changed = true;
                  showSnackBar(context, "Customer deleted successfully!");
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
              _nameCtrl,
              "Full Name",
              Icons.person,
              context,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              _phoneCtrl,
              "Phone Number",
              Icons.phone,
              context,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              _emailCtrl,
              "Email Address",
              Icons.email,
              context,
              isEmail: true,
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
    BuildContext context, {
    bool isEmail = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType:
          isEmail
              ? TextInputType.emailAddress
              : (label.contains("Phone")
                  ? TextInputType.phone
                  : TextInputType.text),
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
        if (isEmail && !text.contains('@')) return "Enter a valid email";
        return null;
      },
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      height: 55,
      child: ElevatedButton.icon(
        onPressed: _updateCustomer,
        icon: const Icon(Icons.save),
        label: const Text("UPDATE CUSTOMER"),
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

  void _updateCustomer() {
    if (_formKey.currentState!.validate()) {
      final item = ModelCustomer(
        id: widget.item.id,
        name: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        createdAt: widget.item.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
        reservations: widget.item.reservations,
      );

      CustomerApiService()
          .update(item)
          .then((value) {
            if (value == true) {
              _changed = true;
              showSnackBar(context, "Customer updated successfully!");

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
              showSnackBar(context, "Request timed out. Please try again.");
            },
          );
    }
  }
}


