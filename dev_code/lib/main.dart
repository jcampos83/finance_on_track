import 'package:flutter/material.dart';
import 'package:dev_code/line_chart_sample.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3, // 3 onglets
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Finance on Track'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Chart'),
                Tab(text: 'Fixed spending'),
                Tab(text: 'Budgets'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [GraphTab(), ExpensesTab(), BudgetsTab()],
          ),
        ),
      ),
    );
  }
}

class GraphTab extends StatelessWidget {
  const GraphTab({super.key});

  @override
  Widget build(BuildContext context) {
    final data = <FlSpot>[
      FlSpot(0, 0),
      FlSpot(5, 1500),
      FlSpot(10, 1000),
      FlSpot(15, 3000),
      FlSpot(20, 2000),
      FlSpot(25, 4000),
      FlSpot(30, 3500),
    ];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChartSample(dataPoints: data),
      ),
    );
  }
}

class ExpensesTab extends StatefulWidget {
  const ExpensesTab({super.key});

  @override
  _ExpensesTabState createState() => _ExpensesTabState();
}

class _ExpensesTabState extends State<ExpensesTab> {
  final List<Map<String, dynamic>> _expenses = [];

  void _addExpense() {
    String name = '';
    double amount = 0;
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter une dépense fixe'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Nom'),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Montant (€)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  amount = double.tryParse(value) ?? 0;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 365),
                    ),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
                child: const Text('Sélectionner la date'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Annuler
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _expenses.add({
                    'name': name,
                    'amount': amount,
                    'date': selectedDate,
                  });
                });
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _expenses.isEmpty
              ? const Center(child: Text('Pas encore de dépenses fixes.'))
              : ListView.builder(
                itemCount: _expenses.length,
                itemBuilder: (context, index) {
                  final expense = _expenses[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    elevation: 3, // petite ombre portée
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // coins arrondis
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.attach_money,
                        color: Colors.green,
                      ), // petite icône
                      title: Text(
                        expense['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${expense['amount']} € - ${expense['date'].day}/${expense['date'].month}/${expense['date'].year}',
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExpense,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class BudgetsTab extends StatelessWidget {
  const BudgetsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Ici, tu pourras gérer les budgets prévisionnels'),
    );
  }
}
