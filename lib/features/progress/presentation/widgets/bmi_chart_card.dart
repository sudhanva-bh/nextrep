import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nextrep/core/common/utils/bmi_calculator.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/entities/user/user_profile_model.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class BmiChartCard extends StatefulWidget {
  final UserProfile profile;
  const BmiChartCard({super.key, required this.profile});

  @override
  State<BmiChartCard> createState() => _BmiChartCardState();
}

class _BmiChartCardState extends State<BmiChartCard> {
  // Chart panning state
  late double _minX, _maxX;
  late double _dataMinX, _dataMaxX;

  // Chart Y-axis (BMI range) state, now controlled by sliders
  late double _currentMinY;
  late double _currentMaxY;

  // --- Constants ---
  static const double _visibleDays = 15;
  static const double _dayInMilliseconds = 24 * 60 * 60 * 1000;
  // Define the absolute boundaries for the sliders
  static const double _sliderAbsoluteMinY = 10.0;
  static const double _sliderAbsoluteMaxY = 40.0;

  late final List<FlSpot> _spots;

  @override
  void initState() {
    super.initState();
    _spots = widget.profile.weightHistory.map((entry) {
      final bmi = calculateBmi(entry.weight, widget.profile.height);
      return FlSpot(entry.date.millisecondsSinceEpoch.toDouble(), bmi);
    }).toList()..sort((a, b) => a.x.compareTo(b.x));

    // Safety: ensure at least one spot
    if (_spots.isEmpty) {
      final now = DateTime.now().millisecondsSinceEpoch.toDouble();
      _spots.addAll([
        FlSpot(now - 7 * _dayInMilliseconds, 22.0),
        FlSpot(now, 22.0),
      ]);
    }

    // Initialize X-axis for panning
    _dataMinX = _spots.first.x;
    _dataMaxX = _spots.last.x;
    _maxX = _dataMaxX;
    _minX = max(_dataMinX, _maxX - (_visibleDays * _dayInMilliseconds));

    // Initialize Y-axis slider values to a sensible default
    _currentMinY = 16.0;
    _currentMaxY = 28.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPalette.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: WidgetProperties.dropShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'History',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppPalette.onSurface,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: AppPalette.primary),
                tooltip: "Refresh chart",
                onPressed: () {
                  setState(() {
                    _spots
                      ..clear()
                      ..addAll(
                        widget.profile.weightHistory.map((entry) {
                          final bmi = calculateBmi(
                            entry.weight,
                            widget.profile.height,
                          );
                          return FlSpot(
                            entry.date.millisecondsSinceEpoch.toDouble(),
                            bmi,
                          );
                        }).toList()..sort((a, b) => a.x.compareTo(b.x)),
                      );

                    // Recalculate x-axis bounds
                    _dataMinX = _spots.first.x;
                    _dataMaxX = _spots.last.x;
                    _maxX = _dataMaxX;
                    _minX = max(
                      _dataMinX,
                      _maxX - (_visibleDays * _dayInMilliseconds),
                    );
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // --- Chart Container with drop shadow ---
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              final sensitivity = (_maxX - _minX) / 200;
              double dx = details.primaryDelta! * sensitivity;

              if (_minX - dx < _dataMinX) dx = _minX - _dataMinX;
              if (_maxX - dx > _dataMaxX) dx = _maxX - _dataMaxX;

              setState(() {
                _minX -= dx;
                _maxX -= dx;
              });
            },
            child: Container(
              height: 280,
              padding: const EdgeInsets.only(
                left: 16,
                right: 24,
                top: 24,
                bottom: 12,
              ),
              decoration: BoxDecoration(
                color: AppPalette.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppPalette.outline),
              ),
              child: LineChart(
                LineChartData(
                  minX: _minX,
                  maxX: _maxX,
                  minY: _currentMinY,
                  maxY: _currentMaxY,
                  clipData: FlClipData.all(),
                  lineTouchData: _buildLineTouchData(),
                  rangeAnnotations: _buildRangeAnnotations(),
                  gridData: _buildGridData(),
                  titlesData: _buildTitles(),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [_buildLineBarData()],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // --- Min BMI Slider wrapped in a container with drop shadow ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: AppPalette.lightSurface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: WidgetProperties.dropShadow,
            ),
            child: Column(
              children: [
                _buildBmiSlider(
                  label: 'Min BMI',
                  value: _currentMinY,
                  onChanged: (value) {
                    if (value < _currentMaxY) {
                      setState(() => _currentMinY = value);
                    }
                  },
                ),
                const SizedBox(height: 8),
                _buildBmiSlider(
                  label: 'Max BMI',
                  value: _currentMaxY,
                  onChanged: (value) {
                    if (value > _currentMinY) {
                      setState(() => _currentMaxY = value);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Builder methods for chart components ---

  Widget _buildBmiSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            '$label: ${value.toStringAsFixed(1)}',
            style: const TextStyle(color: AppPalette.hintText, fontSize: 14),
          ),
        ),
        Slider(
          value: value,
          min: _sliderAbsoluteMinY,
          max: _sliderAbsoluteMaxY,
          divisions: (_sliderAbsoluteMaxY - _sliderAbsoluteMinY).toInt() * 2,
          label: value.toStringAsFixed(1),
          onChanged: onChanged,
          activeColor: AppPalette.primary,
          inactiveColor: AppPalette.lighterSurface,
        ),
      ],
    );
  }

  LineTouchData _buildLineTouchData() {
    return LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
        getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
          return touchedBarSpots.map((barSpot) {
            final flSpot = barSpot;

            // Recover date
            final date = DateTime.fromMillisecondsSinceEpoch(flSpot.x.toInt());
            final formattedDate = DateFormat('MMM d, yyyy').format(date);

            // Find matching WeightEntry from weightHistory
            final entry = widget.profile.weightHistory.firstWhere(
              (e) => e.date.millisecondsSinceEpoch.toDouble() == flSpot.x,
              orElse: () => WeightEntry(date: date, weight: 0),
            );

            final weight = entry.weight;
            // final height = widget.profile.height;

            return LineTooltipItem(
              '$formattedDate\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              children: [
                TextSpan(
                  text: 'Weight: ${weight.toStringAsFixed(1)} kg',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
              textAlign: TextAlign.left,
            );
          }).toList();
        },
      ),
    );
  }

  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      getDrawingHorizontalLine: (value) => FlLine(
        color: AppPalette.lightSurface.withValues(alpha: 0.4),
        strokeWidth: 1,
        dashArray: [4, 4],
      ),
    );
  }

  RangeAnnotations _buildRangeAnnotations() {
    return RangeAnnotations(
      horizontalRangeAnnotations: [
        // Underweight (<18.5): Blue
        HorizontalRangeAnnotation(
          y1: _sliderAbsoluteMinY,
          y2: 18.5,
          color: Colors.blue.withValues(alpha: 0.4),
        ),
        // Healthy (18.5-24.9): Green
        HorizontalRangeAnnotation(
          y1: 18.5,
          y2: 24.9,
          color: Colors.green.withValues(alpha: 0.4),
        ),
        // Overweight (25-29.9): Orange
        HorizontalRangeAnnotation(
          y1: 25,
          y2: 29.9,
          color: Colors.orange.withValues(alpha: 0.4),
        ),
        // Obese (>30): Red
        HorizontalRangeAnnotation(
          y1: 30,
          y2: _sliderAbsoluteMaxY,
          color: Colors.red.withValues(alpha: 0.4),
        ),
      ],
    );
  }

  LineChartBarData _buildLineBarData() {
    return LineChartBarData(
      spots: _spots,
      isCurved: true,
      color: AppPalette.onSurface, // <-- thinner graph color: onSurface
      barWidth: 2, // <-- thinner line
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 3, // smaller dot
            color: AppPalette.onSurface,
            strokeWidth: 1.5,
            strokeColor: AppPalette.surface,
          );
        },
      ),
      belowBarData: BarAreaData(show: false),
    );
  }

  FlTitlesData _buildTitles() {
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 36,
          getTitlesWidget: (value, meta) {
            if (value == meta.max || value == meta.min) return const SizedBox();
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                value.toInt().toString(),
                style: const TextStyle(
                  color: AppPalette.hintText,
                  fontSize: 12,
                ),
              ),
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: _dayInMilliseconds * 3,
          getTitlesWidget: (value, meta) {
            if (value < _minX || value > _maxX) return const SizedBox();

            final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                DateFormat('MMM d').format(date),
                style: const TextStyle(
                  color: AppPalette.hintText,
                  fontSize: 11,
                ),
              ),
            );
          },
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}
