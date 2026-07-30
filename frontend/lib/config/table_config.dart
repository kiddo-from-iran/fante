import 'package:flutter/material.dart';
import 'package:frontend/models/bus.dart';
import 'package:frontend/models/schedule.dart';
import 'package:frontend/models/stop.dart';
import 'package:frontend/models/driver.dart';
import 'package:frontend/models/my_route.dart';

// TabData class for tab configuration
class TabData {
  final String title;
  final IconData icon;

  const TabData(this.title, this.icon);
}

// Table configuration for different entities
class TableConfig<T> {
  final List<String> columns;
  final List<Widget Function(T)> cellBuilders;
  final List<double> columnWidths;
  final List<Alignment> columnAlignments;

  const TableConfig({
    required this.columns,
    required this.cellBuilders,
    required this.columnWidths,
    required this.columnAlignments,
  });
}
// Buses table configuration
final TableConfig<Bus> busesTableConfig = TableConfig<Bus>(
  columns: [
    'شناسه',
    'کد',
    'مدل',
    'سال',
    'ظرفیت',
    'وضعیت',
    'عملیات',
  ],
  columnWidths: [80, 120, 120, 80, 80, 100, 120],
  columnAlignments: [
    Alignment.center,
    Alignment.centerRight,
    Alignment.centerRight,
    Alignment.center,
    Alignment.center,
    Alignment.center,
    Alignment.center,
  ],
  cellBuilders: [
    (bus) => Text('${bus.id}'),
    (bus) => Text(bus.identifier ?? 'نامشخص'),
    (bus) => Text(bus.model ?? 'نامشخص'),
    (bus) => Text('${bus.year}'),
    (bus) => Text('${bus.capacity}'),
    (bus) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(bus.status),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            bus.status ?? 'نامشخص',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
    (bus) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 16),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 16),
              onPressed: () {},
            ),
          ],
        ),
  ],
);

// Schedules table configuration
final TableConfig<Schedule> schedulesTableConfig = TableConfig<Schedule>(
  columns: [
    'شناسه',
    'اتوبوس',
    'مسیر',
    'زمان شروع',
    'زمان پایان',
    'عملیات',
  ],
  columnWidths: [80, 120, 150, 120, 120, 120],
  columnAlignments: [
    Alignment.center,
    Alignment.centerRight,
    Alignment.centerRight,
    Alignment.center,
    Alignment.center,
    Alignment.center,
  ],
  cellBuilders: [
    (schedule) => Text('${schedule.id}'),
    (schedule) => Text(schedule.bus.toString() ?? 'نامشخص'),
    (schedule) => Text(schedule.route.toString() ?? 'نامشخص'),
    (schedule) => Text(schedule.service ?? 'بدون سرویس'),
    (schedule) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 16),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 16),
              onPressed: () {},
            ),
          ],
        ),
  ],
);

// Stops table configuration
final TableConfig<Stop> stopsTableConfig = TableConfig<Stop>(
  columns: [
    'شناسه',
    'نام',
    'عرض جغرافیایی',
    'طول جغرافیایی',
    'عملیات',
  ],
  columnWidths: [80, 200, 120, 120, 120],
  columnAlignments: [
    Alignment.center,
    Alignment.centerRight,
    Alignment.center,
    Alignment.center,
    Alignment.center,
  ],
  cellBuilders: [
    (stop) => Text('${stop.id}'),
    (stop) => Text(stop.name ?? 'نامشخص'),
    (stop) => Text(stop.latitude ?? 'نامشخص'),
    (stop) => Text(stop.longitude ?? 'نامشخص'),
    (stop) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 16),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 16),
              onPressed: () {},
            ),
          ],
        ),
  ],
);

// Drivers table configuration
final TableConfig<Driver> driversTableConfig = TableConfig<Driver>(
  columns: [
    'شناسه',
    'نام',
    'نام خانوادگی',
    'تلفن',
    'وضعیت',
    'عملیات',
  ],
  columnWidths: [80, 150, 150, 120, 100, 120],
  columnAlignments: [
    Alignment.center,
    Alignment.centerRight,
    Alignment.centerRight,
    Alignment.center,
    Alignment.center,
    Alignment.center,
  ],
  cellBuilders: [
    (driver) => Text('${driver.id}'),
    (driver) => Text(driver.firstName),
    (driver) => Text(driver.lastName),
    (driver) => Text(driver.phone),
    (driver) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: driver.isActive ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            driver.isActive ? 'فعال' : 'غیرفعال',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
    (driver) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 16),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 16),
              onPressed: () {},
            ),
          ],
        ),
  ],
);

// Routes table configuration
final TableConfig<MyRoute> routesTableConfig = TableConfig<MyRoute>(
  columns: [
    'شناسه',
    'نام',
    'توضیحات',
    'مسافت',
    'زمان تخمینی',
    'وضعیت',
    'عملیات',
  ],
  columnWidths: [80, 200, 150, 100, 120, 100, 120],
  columnAlignments: [
    Alignment.center,
    Alignment.centerRight,
    Alignment.centerRight,
    Alignment.center,
    Alignment.center,
    Alignment.center,
    Alignment.center,
  ],
  cellBuilders: [
    (route) => Text('${route.id}'),
    (route) => Text(route.name),
    (route) => Text(route.description),
    (route) => Text('${route.distance} کیلومتر'),
    (route) => Text('${route.estimatedTime} دقیقه'),
    (route) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: route.isActive ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            route.isActive ? 'فعال' : 'غیرفعال',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
    (route) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 16),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 16),
              onPressed: () {},
            ),
          ],
        ),
  ],
);

// Helper function to get status color
Color _getStatusColor(String? status) {
  switch (status?.toLowerCase()) {
    case 'active':
    case 'فعال':
      return Colors.green;
    case 'inactive':
    case 'غیرفعال':
      return Colors.red;
    case 'pending':
    case 'در انتظار':
      return Colors.orange;
    case 'suspended':
    case 'معلق':
      return Colors.grey;
    default:
      return Colors.grey;
  }
}
