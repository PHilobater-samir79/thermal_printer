import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_printer/bluetooth/print_screen_with_bluetooth.dart';
import 'package:test_printer/ip/print_with_ip.dart';

class HomeBodyView extends StatefulWidget {
  const HomeBodyView({super.key});

  @override
  State<HomeBodyView> createState() => _HomeBodyViewState();
}

class _HomeBodyViewState extends State<HomeBodyView> {
  int _total = 0;
  final List<Map<String, dynamic>> data = [
    {'title': 'Cadbury Dairy Milk', 'price': 15, 'qty': 2},
    {'title': 'Parle-G Gluco Biscut', 'price': 5, 'qty': 5},
    {'title': 'Fresh Onion - 1KG', 'price': 20, 'qty': 1},
    {'title': 'Fresh Sweet Lime', 'price': 20, 'qty': 5},
    {'title': 'Maggi', 'price': 10, 'qty': 5},
  ];
  final f = NumberFormat("\$###,###.00", "en_US");
  @override
  Widget build(BuildContext context) {
    _total = data.map((e) => e['price'] * e['qty']).reduce(
          (value, element) => value + element,
        );
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (c, i) {
              return ListTile(
                title: Text(
                  data[i]['title'].toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "${f.format(data[i]['price'])} x ${data[i]['qty']}",
                ),
                trailing: Text(
                  f.format(
                    data[i]['price'] * data[i]['qty'],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Text(
                "Total: ${f.format(_total)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 80,
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PrintPageWithBluetooth(data),
                      ),
                    );
                  },
                  icon: const Icon(Icons.print),
                  label: const Text('Print Bluetooth'),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green),
                ),
              )
            ],
          ),
        ),
        Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Text(
                "Total: ${f.format(_total)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 80,
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PrintWithIp(
                          data: data,
                          total: _total,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.print),
                  label: const Text('Print with ip'),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
