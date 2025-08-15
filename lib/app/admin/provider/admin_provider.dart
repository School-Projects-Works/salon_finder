import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_finder/app/data/salon_model.dart';
import 'package:salon_finder/app/data/transactions_model.dart';
import '../../data/appointment_model.dart';
import '../../data/user_model.dart';
import '../core/custom_dialog.dart';
import '../core/functions/sms_functions.dart';
import '../services/admin_services.dart';

final userStream = StreamProvider<List<UserModel>>((ref) async* {
  var data = AdminServices.getUsers();
  await for (var value in data) {
    ref.read(usersFilterProvider.notifier).setUsers(value);
    yield value;
  }
});

final salonsStream = StreamProvider<List<SalonModel>>((ref) async* {
  var data = AdminServices.getSalons();
  await for (var value in data) {
    ref.read(salonsFilterProvider.notifier).setSalons(value);
    yield value;
  }
});

class UserFilter {
  List<UserModel> items;
  List<UserModel> filter;
  UserFilter({required this.items, required this.filter});

  UserFilter copyWith({List<UserModel>? items, List<UserModel>? filter}) {
    return UserFilter(
      items: items ?? this.items,
      filter: filter ?? this.filter,
    );
  }
}

class SalonsFilter {
  List<SalonModel> items;
  List<SalonModel> filter;
  SalonsFilter({required this.items, required this.filter});

  SalonsFilter copyWith({List<SalonModel>? items, List<SalonModel>? filter}) {
    return SalonsFilter(
      items: items ?? this.items,
      filter: filter ?? this.filter,
    );
  }
}

final usersFilterProvider = StateNotifierProvider<SalonsProvider, UserFilter>((
  ref,
) {
  return SalonsProvider();
});

class SalonsProvider extends StateNotifier<UserFilter> {
  SalonsProvider() : super(UserFilter(items: [], filter: []));

  void filterUsers(String query) {
    state = state.copyWith(
      filter: state.items
          .where(
            (element) =>
                element.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList(),
    );
  }

  void setUsers(List<UserModel> items) {
    state = state.copyWith(items: items, filter: items);
  }

  void updateStatus(UserModel copyWith) async {
    CustomAdminDialog.dismiss();
    CustomAdminDialog.showLoading(message: 'Updating User Status');
    var results = await AdminServices.updateUser(copyWith);
    await sendMessage(
      copyWith.phoneNumber,
      'Your account has been ${copyWith.status == 'active' ? 'activated, login to start using the platform.' : 'banned. Contact admin for more information'}',
    );
    CustomAdminDialog.dismiss();
    if (results) {
      CustomAdminDialog.showToast(message: 'User Status Updated');
    } else {
      CustomAdminDialog.showToast(message: 'Unable to update user status');
    }
  }
}

final salonsFilterProvider = StateNotifierProvider<ClientsProvider, SalonsFilter>(
  (ref) {
    return ClientsProvider();
  },
);

class ClientsProvider extends StateNotifier<SalonsFilter> {
  ClientsProvider() : super(SalonsFilter(items: [], filter: []));

  void filterSalons(String query) {
    state = state.copyWith(
      filter: state.items
          .where(
            (element) =>
                element.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList(),
    );
  }

  void setSalons(List<SalonModel> items) {
    state = state.copyWith(items: items, filter: items);
  }

  void updateStatus(SalonModel copyWith) async {
    CustomAdminDialog.dismiss();
    CustomAdminDialog.showLoading(message: 'Updating Salon Status');
    var results = await AdminServices.updateSalon(copyWith);
    //send salon sms
    await sendMessage(
      copyWith.contact.phoneNumber,
      'Your account has been ${copyWith.status == 'active' ? 'activated, login to start using the platform.' : 'banned. Contact admin for more information'}',
    );
    CustomAdminDialog.dismiss();
    if (results) {
      CustomAdminDialog.showToast(message: 'User Status Updated');
    } else {
      CustomAdminDialog.showToast(message: 'Unable to update user status');
    }
  }
}


class AppointmentsFilter {
  List<AppointmentModel> items;
  List<AppointmentModel> filter;
  AppointmentsFilter({required this.items, required this.filter});

  AppointmentsFilter copyWith({List<AppointmentModel>? items, List<AppointmentModel>? filter}) {
    return AppointmentsFilter(
      items: items ?? this.items,
      filter: filter ?? this.filter,
    );
  }
}

final appointmentsStream = StreamProvider<List<AppointmentModel>>((ref) async* {
  var data = AdminServices.getAppointments();
  await for (var value in data) {
    ref.read(appointmentsFilterProvider.notifier).setAppointments(value);
    yield value;
  }
});


final appointmentsFilterProvider = StateNotifierProvider<AppointmentsProvider, AppointmentsFilter>(
  (ref) {
    return AppointmentsProvider();
  },
);

class AppointmentsProvider extends StateNotifier<AppointmentsFilter> {
  AppointmentsProvider() : super(AppointmentsFilter(items: [], filter: []));

  void filterAppointments(String query) {
    state = state.copyWith(
      filter: state.items
          .where(
            (element) =>
                element.user.name.toLowerCase().contains(query.toLowerCase()) ||
                element.saloon.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList(),
    );
  }

  void setAppointments(List<AppointmentModel> items) {
    state = state.copyWith(items: items, filter: items);
  }
}

class TransactionsFilter {
  List<TransactionsModel> items;
  List<TransactionsModel> filter;
  TransactionsFilter({required this.items, required this.filter});

  TransactionsFilter copyWith({List<TransactionsModel>? items, List<TransactionsModel>? filter}) {
    return TransactionsFilter(
      items: items ?? this.items,
      filter: filter ?? this.filter,
    );
  }
}

final transactionsStream = StreamProvider<List<TransactionsModel>>((ref) async* {
  var data = AdminServices.getTransactions();
  await for (var value in data) {
    ref.read(transactionsFilterProvider.notifier).setTransactions(value);
    yield value;
  }
});

final transactionsFilterProvider = StateNotifierProvider<TransactionsProvider, TransactionsFilter>(
  (ref) {
    return TransactionsProvider();
  },
);

class TransactionsProvider extends StateNotifier<TransactionsFilter> {
  TransactionsProvider() : super(TransactionsFilter(items: [], filter: []));

  void filterTransactions(String query) {
    state = state.copyWith(
      filter: state.items
          .where(
            (element) =>
                element.paymentMethod.toLowerCase().contains(query.toLowerCase()) ||
                element.appointmentId.toLowerCase().contains(query.toLowerCase()),
          )
          .toList(),
    );
  }

  void setTransactions(List<TransactionsModel> items) {
    state = state.copyWith(items: items, filter: items);
  }
}
