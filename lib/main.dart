import 'package:flutter/material.dart';

void main() {
  runApp(const UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  const UnitConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFFF9F9FB),
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade900,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
          bodyMedium: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade700,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          color: Colors.white,
          shadowColor: Colors.black12,
        ),
      ),
      home: const ConverterHomePage(),
    );
  }
}

class ConverterHomePage extends StatefulWidget {
  const ConverterHomePage({super.key});

  @override
  State<ConverterHomePage> createState() => _ConverterHomePageState();
}

class _ConverterHomePageState extends State<ConverterHomePage> {
  int _selectedIndex = 0;

  final List<_Category> _categories = [
    _Category('Length', Icons.straighten,
        gradient: const LinearGradient(colors: [Colors.blue, Colors.cyan])),
    _Category('Weight', Icons.monitor_weight,
        gradient: const LinearGradient(colors: [Colors.orange, Colors.red])),
    _Category('Temperature', Icons.thermostat,
        gradient: const LinearGradient(colors: [Colors.green, Colors.teal])),
  ];

  @override
  Widget build(BuildContext context) {
    final category = _categories[_selectedIndex];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF9F9FB), Color(0xFFECE9E6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildConverterPage(category),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      decoration: BoxDecoration(
        gradient: _categories[_selectedIndex].gradient,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: _categories[_selectedIndex]
                .gradient
                .colors
                .first
                .withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(_categories[_selectedIndex].icon, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Unit Converter',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                _categories[_selectedIndex].name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_categories.length, (index) {
          final isSelected = _selectedIndex == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: isSelected ? _categories[index].gradient : null,
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () => setState(() => _selectedIndex = index),
              borderRadius: BorderRadius.circular(20),
              child: Row(
                children: [
                  Icon(_categories[index].icon,
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                      size: 22),
                  if (isSelected)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        _categories[index].name,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildConverterPage(_Category category) {
    return Padding(
      key: ValueKey(category.name),
      padding: const EdgeInsets.all(24),
      child: ConverterCard(category: category),
    );
  }
}

class ConverterCard extends StatefulWidget {
  final _Category category;
  const ConverterCard({required this.category, super.key});

  @override
  State<ConverterCard> createState() => _ConverterCardState();
}

class _ConverterCardState extends State<ConverterCard> {
  final TextEditingController _inputController = TextEditingController();
  String _selectedFrom = '';
  String _selectedTo = '';
  String _result = '';

  final Map<String, List<String>> _units = {
    'Length': ['Meters', 'Kilometers', 'Miles', 'Feet'],
    'Weight': ['Grams', 'Kilograms', 'Pounds', 'Ounces'],
    'Temperature': ['Celsius', 'Fahrenheit', 'Kelvin'],
  };

  @override
  void initState() {
    super.initState();
    _selectedFrom = _units[widget.category.name]!.first;
    _selectedTo = _units[widget.category.name]!.last;
  }

  void _convert() {
    if (_inputController.text.isEmpty) {
      setState(() => _result = '');
      return;
    }

    final value = double.tryParse(_inputController.text);
    if (value == null) return;

    double converted = value;

    switch (widget.category.name) {
      // Length Conversion
      case 'Length':
        const meterPerKm = 1000.0;
        const meterPerMile = 1609.34;
        const meterPerFoot = 0.3048;

        double meters = value;
        if (_selectedFrom == 'Kilometers') meters = value * meterPerKm;
        else if (_selectedFrom == 'Miles') meters = value * meterPerMile;
        else if (_selectedFrom == 'Feet') meters = value * meterPerFoot;

        if (_selectedTo == 'Kilometers') converted = meters / meterPerKm;
        else if (_selectedTo == 'Miles') converted = meters / meterPerMile;
        else if (_selectedTo == 'Feet') converted = meters / meterPerFoot;
        else converted = meters;
        break;

      // Weight Conversion
      case 'Weight':
        const gramPerKg = 1000.0;
        const gramPerPound = 453.592;
        const gramPerOunce = 28.3495;

        double grams = value;
        if (_selectedFrom == 'Kilograms') grams = value * gramPerKg;
        else if (_selectedFrom == 'Pounds') grams = value * gramPerPound;
        else if (_selectedFrom == 'Ounces') grams = value * gramPerOunce;

        if (_selectedTo == 'Kilograms') converted = grams / gramPerKg;
        else if (_selectedTo == 'Pounds') converted = grams / gramPerPound;
        else if (_selectedTo == 'Ounces') converted = grams / gramPerOunce;
        else converted = grams;
        break;

      // Temperature Conversion
      case 'Temperature':
        double celsius = value;
        if (_selectedFrom == 'Fahrenheit') celsius = (value - 32) * 5 / 9;
        else if (_selectedFrom == 'Kelvin') celsius = value - 273.15;

        if (_selectedTo == 'Fahrenheit') converted = (celsius * 9 / 5) + 32;
        else if (_selectedTo == 'Kelvin') converted = celsius + 273.15;
        else converted = celsius;
        break;
    }

    setState(() => _result = converted.toStringAsFixed(2));
  }

  void _swapUnits() {
    setState(() {
      final temp = _selectedFrom;
      _selectedFrom = _selectedTo;
      _selectedTo = temp;
    });
    _convert();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInputCard(context),
              const SizedBox(height: 24),
              _buildSwapButton(context),
              const SizedBox(height: 24),
              _buildOutputCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard(BuildContext context) {
    return _styledContainer(
      child: Column(
        children: [
          TextField(
            controller: _inputController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Enter value',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _convert(),
          ),
          const SizedBox(height: 16),
          _buildDropdown('From', _selectedFrom, (value) {
            setState(() => _selectedFrom = value!);
            _convert();
          }),
        ],
      ),
    );
  }

  Widget _buildOutputCard(BuildContext context) {
    return _styledContainer(
      child: Column(
        children: [
          _buildDropdown('To', _selectedTo, (value) {
            setState(() => _selectedTo = value!);
            _convert();
          }),
          const SizedBox(height: 16),
          Text(
            _result.isEmpty ? '--' : _result,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }

  Widget _styledContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget _buildDropdown(String label, String value, ValueChanged<String?> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        DropdownButton<String>(
          value: value,
          items: _units[widget.category.name]!
              .map((unit) => DropdownMenuItem(value: unit, child: Text(unit)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSwapButton(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: _swapUnits,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: widget.category.gradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.category.gradient.colors.first.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.swap_vert, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}

class _Category {
  final String name;
  final IconData icon;
  final Gradient gradient;

  _Category(this.name, this.icon, {required this.gradient});
}
