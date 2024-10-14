import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesGraph extends StatelessWidget {
  final List<double> salesData;

  const SalesGraph({super.key, required this.salesData});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final totalSales = salesData.reduce((a, b) => a + b);

    return Container(
      height: width / 1.5,
      width: width/0.4,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Sales: ${totalSales.toInt()}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: salesData.length * 60,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceBetween,
                    barTouchData: BarTouchData(enabled: true),
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
                              case 6:
                                return const Text('Jul');
                              case 7:
                                return const Text('Aug');
                              case 8:
                                return const Text('Sep');
                              case 9:
                                return const Text('Oct');
                              case 10:
                                return const Text('Nov');
                              case 11:
                                return const Text('Dec');
                              default:
                                return const Text('');
                            }
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 38,
                          getTitlesWidget: (value, meta) {
                            return Text(value.toInt().toString());
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: salesData.asMap().entries.map((entry) {
                      int index = entry.key;
                      double value = entry.value;
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: value,
                            color: Colors.black,
                            width: 20,
                            borderSide: BorderSide.none,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


