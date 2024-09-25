import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesGraph extends StatelessWidget {
  final List<double> salesData; // Sales data as a list

  const SalesGraph({super.key, required this.salesData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: salesData.reduce((a, b) => a > b ? a : b) + 10,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 38,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text('Jan');
                    case 1:
                      return const Text('Feb');
                    case 2:
                      return const Text('Mar');
                    case 3:
                      return const Text('Apr');
                    case 4:
                      return const Text('May');
                    case 5:
                      return const Text('Jun');
                    default:
                      return const Text('');
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(value.toString());
                },
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: salesData.asMap().entries.map((entry) {
            int index = entry.key;
            double value = entry.value;
            return BarChartGroupData(x: index, barRods: [
              BarChartRodData(toY: value, color: Colors.black, width: 20),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}

// Build Non-owner's view content with Sales only
Widget _buildSalesOnlyContent(double width, double height) {
  // Sample sales data for 6 months
  final List<double> salesData = [10, 20, 15, 30, 25, 40];

  return Container(
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(width * 0.075),
        topLeft: Radius.circular(width * 0.075),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: ListTile(
                leading: Image.asset(
                  "assets/salespng.png",
                ),
                title: const Text("Sales"),
                trailing: CircleAvatar(
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),
          ),
          // Sales graph
          const SizedBox(height: 12),
          SalesGraph(salesData: salesData),
        ],
      ),
    ),
  );
}
