import 'package:flutter/material.dart';
import 'ParamContainer.dart';

class HomeWidget extends StatefulWidget {
  final String millID;
  final List<String> timestamps;
  final List<int> currentValues;
  final List<int> maxValues;
  final List<String> metrics;
  const HomeWidget({
    super.key,
    required this.millID,
    required this.timestamps,
    required this.currentValues,
    required this.maxValues,
    required this.metrics,
  });

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 5,
      fit: FlexFit.loose,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(220, 248, 248, 248),
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 3),
            )
          ],
        ),
        height: 490,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('302121.1',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5)),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text('Kwh',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Next two rows are for the parameters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ParamContainer(
                  paramtype: widget.metrics[0],
                  max: widget.maxValues[0].toDouble(),
                  threshold: 10,
                  unit: determineUnit(widget.metrics[0]),
                  value: widget.currentValues[0].toDouble(),
                  millID: widget.millID,
                ),
                ParamContainer(
                  paramtype: widget.metrics[1],
                  max: widget.maxValues[1].toDouble(),
                  threshold: 20,
                  unit: determineUnit(widget.metrics[1]),
                  value: widget.currentValues[1].toDouble(),
                  millID: widget.millID,
                ),
              ],
            ),
            // Row for water level and turbine container
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ParamContainer(
                  paramtype: widget.metrics[2],
                  max: widget.maxValues[2].toDouble(),
                  threshold: 30,
                  unit: determineUnit(widget.metrics[2]),
                  value: widget.currentValues[2].toDouble(),
                  millID: widget.millID,
                ),
                ParamContainer(
                  paramtype: widget.metrics[3],
                  max: widget.maxValues[3].toDouble(),
                  threshold: 40,
                  unit: determineUnit(widget.metrics[3]),
                  value: widget.currentValues[3].toDouble(),
                  millID: widget.millID,
                ),
              ],
            ),
            Text(
              'Timestamp: ${widget.timestamps.isNotEmpty ? widget.timestamps[0] : "No Timestamp Available"}',
              style: const TextStyle(
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }

  String determineUnit(String metric) {
    // Define your logic for determining the unit based on the metric name
    switch (metric) {
      case 'Steam Pressure':
        return 'bar';
      case 'Steam Flow':
        return 'T/H';
      case 'Water Level':
        return '%';
      case 'Turbine Frequency':
        return 'Hz';
      // Add more cases as needed
      default:
        return ''; // Default unit if not specified
    }
  }
}
