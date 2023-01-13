// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'app_bloc.dart';

@immutable
abstract class AppEvent {}

class AppEventLogin extends AppEvent {
  final String storeID;
  final String courierID;
  AppEventLogin({
    required this.storeID,
    required this.courierID,
  });
}

class AppEventSignOut extends AppEvent {}

class AppEventGetData extends AppEvent {
  final String storeID;
  final String courierID;
  AppEventGetData({
    required this.storeID,
    required this.courierID,
  });
}

class AppEventGetDataPeriodic extends AppEvent {
  final String storeID;
  final String courierID;
  AppEventGetDataPeriodic({
    required this.storeID,
    required this.courierID,
  });
}

class AppEventCompleteOrder extends AppEvent {
  final String storeID;
  final String courierID;
  final String clientName;
  AppEventCompleteOrder({
    required this.clientName,
    required this.storeID,
    required this.courierID,
  });
}
