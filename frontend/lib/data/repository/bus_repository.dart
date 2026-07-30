import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/data/network/http_client.dart';
import 'package:frontend/data/source/bus_data_source%20copy.dart';
import 'package:frontend/models/bus.dart';
import 'package:frontend/models/bus_location.dart';

final busRepository = BusRepository(BusRemoteDataSource(httpClient));

abstract class IBusRepository {
  Future<List<Bus>> getBusList({int offset = 0, int limit = 20});
  Future<Bus> getBusDetails(int busId);
  Future<void> updateBusDetails(Bus updatedBus);
  Future<void> patchBusDetails(int busId, Map<String, dynamic> updatedFields);
  Future<void> deleteBus(int busId);
  Future<void> createBus(Bus newBus);
  Future<List<BusLocation>> getRecentBusLocations();
}

class BusRepository implements IBusRepository {
  final IBusDataSource dataSource;

  BusRepository(this.dataSource);

  @override
  Future<List<Bus>> getBusList({int offset = 0, int limit = 20}) async {
    final busList = await dataSource.getBusList(offset: offset, limit: limit);
    final jsonList = busList.map((e) => e.toJson()).toList();
    debugPrint('message from server: ${jsonEncode(jsonList)}');
    return busList;
  }

  @override
  Future<Bus> getBusDetails(int busId) async {
    final bus = await dataSource.getBusDetails(busId);
    debugPrint('message from server: ${jsonEncode(bus.toJson())}');
    return bus;
  }

  @override
  Future<void> updateBusDetails(Bus updatedBus) async {
    final message = await dataSource.updateBusDetails(updatedBus);
    debugPrint('message from server: $message');
  }

  @override
  Future<void> patchBusDetails(int busId, Map<String, dynamic> updatedFields) async {
    final message = await dataSource.patchBusDetails(busId, updatedFields);
    debugPrint('message from server: $message');
  }

  @override
  Future<void> deleteBus(int busId) async {
    final message = await dataSource.deleteBus(busId);
    debugPrint('message from server: $message');
  }

  @override
  Future<void> createBus(Bus newBus) async {
    final message = await dataSource.postBus(newBus);
    debugPrint('message from server: $message');
  }

  @override
  Future<List<BusLocation>> getRecentBusLocations() async {
    final result = await dataSource.getRecentBusLocations();
    return result;
  }
}