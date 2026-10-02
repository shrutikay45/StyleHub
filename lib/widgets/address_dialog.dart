import 'package:flutter/material.dart';
import 'package:new_expense/data/user_data.dart';

Future<void> showAddressDialog(BuildContext context) {
  TextEditingController nameController = TextEditingController(text: UserData.name);
  TextEditingController phoneController = TextEditingController(text: UserData.phone);
  TextEditingController locController = TextEditingController(text: UserData.location);

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Update Address'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: locController,
                decoration: const InputDecoration(labelText: 'Address'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              UserData.name = nameController.text;
              UserData.phone = phoneController.text;
              UserData.location = locController.text;
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
