import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AjouterPublicitePage(),
    );
  }
}

class AjouterPublicitePage extends StatelessWidget {
  const AjouterPublicitePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
          title: const Text('Ajouter une publicité', style: TextStyle(color: Colors.black)),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.red),
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.red,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.red,
            tabs: [
              Tab(text: 'Vidéo'),
              Tab(text: 'Image'),
              Tab(text: 'Bannière'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            FormVideoWidget(),
            FormImageWidget(),
            FormBanniereWidget(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Naviguer'),
            BottomNavigationBarItem(icon: Icon(Icons.route), label: 'Itinéraire'),
            BottomNavigationBarItem(icon: Icon(Icons.navigation), label: 'Indications'),
            BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'publicité'),
          ],
        ),
      ),
    );
  }
}

class FormVideoWidget extends StatelessWidget {
  const FormVideoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              buildTextField('Titre de la publicité'),
              buildTextField('Description'),
              buildTextField('Durée (en secondes)'),
              const DatePickerField(label: 'Date de début'),
              const DatePickerField(label: 'Date de fin'),
              buildUploadButton('Téléverser une vidéo'),
              const SizedBox(height: 16),
              buildSubmitButton('Publier la vidéo'),
            ],
          ),
        ),
      ),
    );
  }
}

class FormImageWidget extends StatelessWidget {
  const FormImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              buildTextField('Titre de la publicité'),
              buildTextField('Lien de redirection (URL)'),
              const DatePickerField(label: 'Date de début'),
              const DatePickerField(label: 'Date de fin'),
              buildUploadButton('Téléverser une image'),
              const SizedBox(height: 16),
              buildSubmitButton('Publier l\'image'),
            ],
          ),
        ),
      ),
    );
  }
}

class FormBanniereWidget extends StatelessWidget {
  const FormBanniereWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              buildTextField('Titre de la publicité'),
              DropdownButtonFormField<String>(
                value: 'Haut',
                decoration: const InputDecoration(
                  labelText: 'Position d\'affichage',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                iconEnabledColor: Colors.red,
                dropdownColor: Colors.white,
                items: ['Haut', 'Milieu', 'Bas']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              const DatePickerField(label: 'Date de début'),
              const DatePickerField(label: 'Date de fin'),
              const SizedBox(height: 16),
              buildSubmitButton('Publier la bannière'),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildTextField(String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextField(
      cursorColor: Colors.red,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    ),
  );
}

Widget buildUploadButton(String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.upload_file, color: Colors.red),
      label: Text(label, style: const TextStyle(color: Colors.red)),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.red),
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Coins légèrement arrondis
        ),
      ),
    ),
  );
}

Widget buildSubmitButton(String label) {
  return SizedBox(
    width: double.infinity,
    height: 48,
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        side: const BorderSide(color: Colors.red),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Coins légèrement arrondis
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}

class DatePickerField extends StatefulWidget {
  final String label;

  const DatePickerField({super.key, required this.label});

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  DateTime? selectedDate;

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.red,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        readOnly: true,
        onTap: _selectDate,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: const TextStyle(color: Colors.black),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          suffixIcon: const Icon(Icons.calendar_today, color: Colors.red),
        ),
        controller: TextEditingController(
          text: selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : '',
        ),
        cursorColor: Colors.red,
      ),
    );
  }
}
