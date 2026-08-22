import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpos_provantis/src/features/employees/domain/employees_model.dart';
import '../controllers/employees_controller.dart';

class EmployeesScreen extends ConsumerWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeesState = ref.watch(employeesControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Employees')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEmployeeForm(context, ref),
        child: const Icon(Icons.add),
      ),
      body: employeesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (employees) {
          if (employees.isEmpty) {
            return const Center(child: Text('No employees found.'));
          }

          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index];

              return Dismissible(
                key: Key(employee.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  ref
                      .read(employeesControllerProvider.notifier)
                      .deleteEmployee(employee.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${employee.fullName} deleted')),
                  );
                },
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      employee.fullName.isNotEmpty
                          ? employee.fullName[0].toUpperCase()
                          : '?',
                    ),
                  ),
                  title: Text(employee.fullName),
                  subtitle: Text(
                    'ID: ${employee.employeeId} • ${employee.email}',
                  ),
                  trailing: Icon(
                    employee.isActive ? Icons.check_circle : Icons.cancel,
                    color: employee.isActive ? Colors.green : Colors.red,
                  ),
                  onTap: () =>
                      _showEmployeeForm(context, ref, employee: employee),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEmployeeForm(
    BuildContext context,
    WidgetRef ref, {
    EmployeesModel? employee,
  }) {
    final nameController = TextEditingController(text: employee?.fullName);
    final empIdController = TextEditingController(text: employee?.employeeId);
    final contactController = TextEditingController(text: employee?.contactNo);
    final emailController = TextEditingController(text: employee?.email);
    bool isActive = employee?.isActive ?? true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        // Added to handle switch state in modal
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  employee == null ? 'Add Employee' : 'Edit Employee',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                TextField(
                  controller: empIdController,
                  decoration: const InputDecoration(labelText: 'Employee ID'),
                ),
                TextField(
                  controller: contactController,
                  decoration: const InputDecoration(labelText: 'Contact No'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                SwitchListTile(
                  title: const Text('Active Status'),
                  value: isActive,
                  onChanged: (val) {
                    setModalState(() => isActive = val);
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final now = DateTime.now();
                    final newEmployee = EmployeesModel(
                      // For new employees, let the DB handle the UUID (pass empty/temp)
                      // For existing, keep the original UUID
                      id: employee?.id ?? '',
                      employeeId: empIdController.text,
                      fullName: nameController.text,
                      contactNo: contactController.text,
                      email: emailController.text,
                      isActive: isActive,
                      // Audit fields
                      createdBy: employee?.createdBy ?? 'Admin',
                      updatedBy: 'Admin',
                      createdAt: employee?.createdAt ?? now,
                      updatedAt: now,
                    );

                    if (employee == null) {
                      ref
                          .read(employeesControllerProvider.notifier)
                          .addEmployee(newEmployee);
                    } else {
                      ref
                          .read(employeesControllerProvider.notifier)
                          .updateEmployee(newEmployee);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(employee == null ? 'Create' : 'Update'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
