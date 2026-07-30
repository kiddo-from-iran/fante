import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/data/network/http_client.dart';
import 'package:frontend/data/source/schedule_data_source.dart';
import 'package:frontend/models/schedule.dart';

final scheduleRepository =
    ScheduleRepository(ScheduleRemoteDataSource(httpClient));

abstract class IScheduleRepository {
  Future<List<Schedule>> getScheduleList({int offset = 0, int limit = 10});
  Future<List<Schedule>> getSchedulesByRoute(int routeId, {bool? includeRound});
  Future<Schedule> getScheduleDetails(int scheduleId);
  Future<void> updateScheduleDetails(int scheduleId, Schedule updatedSchedule);
  Future<void> patchScheduleDetails(
      int scheduleId, Map<String, dynamic> updatedFields);
  Future<void> deleteSchedule(int scheduleId);
  Future<void> postSchedule(Schedule newSchedule);
}

class ScheduleRepository implements IScheduleRepository {
  ScheduleRepository(this.scheduleDataSource);

  final IScheduleDataSource scheduleDataSource;

  @override
  Future<List<Schedule>> getScheduleList(
      {int offset = 0, int limit = 10}) async {
    final scheduleList = await scheduleDataSource.getScheduleList(
      offset: offset,
      limit: limit,
    );
    final jsonList = scheduleList.map((e) => e.toJson()).toList();
    debugPrint('message from server: ${jsonEncode(jsonList)}');
    return scheduleList; // Return the list instead of void
  }

  @override
  Future<List<Schedule>> getSchedulesByRoute(int routeId, {bool? includeRound}) async {
    final scheduleList = await scheduleDataSource.getSchedulesByRoute(routeId, includeRound: includeRound);
    final jsonList = scheduleList.map((e) => e.toJson()).toList();
    debugPrint('message from server: ${jsonEncode(jsonList)}');
    return scheduleList; // Return the list instead of void
  }

  @override
  Future<Schedule> getScheduleDetails(int scheduleId) async {
    final schedule = await scheduleDataSource.getScheduleDetails(scheduleId);
    debugPrint('message from server: ${jsonEncode(schedule.toJson())}');
    return schedule; // Return the schedule
  }

  @override
  Future<void> updateScheduleDetails(
      int scheduleId, Schedule updatedSchedule) async {

    final message = await scheduleDataSource.updateScheduleDetails(
        scheduleId, updatedSchedule);
    debugPrint('message from server: $message');
  }

  @override
  Future<void> patchScheduleDetails(
      int scheduleId, Map<String, dynamic> updatedFields) async {
    final message = await scheduleDataSource.patchScheduleDetails(
        scheduleId, updatedFields);
    debugPrint('message from server: $message');
  }

  @override
  Future<void> deleteSchedule(int scheduleId) async {
    final message = await scheduleDataSource.deleteSchedule(scheduleId);
    debugPrint('message from server: $message');
  }

  @override
  Future<void> postSchedule(Schedule newSchedule) async {
    final message = await scheduleDataSource.postSchedule(newSchedule);
    debugPrint('message from server: $message');
  }
}
