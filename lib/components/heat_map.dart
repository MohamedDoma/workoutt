import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:workout/datetime/date_time.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDateYYYYMMDD;

  const MyHeatMap({
    super.key,
    required this.datasets,
    required this.startDateYYYYMMDD,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: HeatMap(
        startDate: createDateTimeObject(startDateYYYYMMDD),
        endDate: DateTime.now().add(const Duration(days: 0)),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: Colors.grey[200],
        textColor: Colors.white,
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 40,
        colorsets: const {
          1: Color.fromARGB(255, 204, 255, 204), // Light green for 25% completion
          2: Color.fromARGB(255, 153, 204, 153), // A bit darker green for 50% completion
          3: Color.fromARGB(255, 102, 153, 102), // Darker green for 75% completion
          4: Color.fromARGB(255, 51, 102, 51),   // Very dark green for 100% completion
        },
      ),
    );
  }
}
