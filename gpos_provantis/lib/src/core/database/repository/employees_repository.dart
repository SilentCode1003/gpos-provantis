import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/employees_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/employees_dao_provider.dart';

import '../domain/employees_dto.dart';

part 'employees_repository.g.dart';

@Riverpod(keepAlive: true)
EmployeesRepository employeesRepository(Ref ref) {
  final dao = ref.watch(employeesDaoProvider);
  return EmployeesRepository(ref, dao);
}

class EmployeesRepository {
  final Ref _ref;
  final EmployeesDao _dao;

  EmployeesRepository(this._ref, this._dao);

  // Fetch employees from the API and save them to the database.
  Future<void> fetchAndSaveEmployees() async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post('/employees/getactive');

    final apiResponse = ApiResponseModel<List<EmployeesDto>>.fromDioResponse(
      response,
      fromJson: (data) => (data as List)
          .map((x) => EmployeesDto.fromJson(x as Map<String, dynamic>))
          .toList(),
    );

    debugPrint('API Response: ${response.data}');

    final records = apiResponse.responseData;
    if (records == null || records.isEmpty) {
      throw Exception(
        'No employees returned from server: ${apiResponse.responseMessage}',
      );
    }

    final companions = records
        .map(
          (employee) => EmployeesTableCompanion.insert(
            employeeId: Value(employee.employeeId),
            fullName: Value(employee.fullName),
            position: Value(employee.position),
            contactInfo: Value(employee.contactInfo),
            dateHired: Value(employee.dateHired),
            status: Value(employee.status),
            createdBy: Value(employee.createdBy),
            createdDate: Value(employee.createdDate),
          ),
        )
        .toList();

    await _dao.replaceEmployees(companions);
  }
}
