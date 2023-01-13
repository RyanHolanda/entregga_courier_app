import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:entregga_courier/data/models/address_model.dart';
import 'package:entregga_courier/data/repos/firebase_storage.dart';
import 'package:entregga_courier/domain/user_auth/auth.dart';
import 'package:entregga_courier/domain/login_error_format/login_error_format.dart';
import 'package:entregga_courier/main.dart';
import 'package:flutter/foundation.dart' show immutable;
part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppStateLoggedOut(isLoading: false)) {
    on<AppEventLogin>((event, emit) async {
      try {
        emit(const AppStateLoggedOut(isLoading: true));
        final addresses = await FetchFromStorage(
                storeid: event.storeID, courierId: event.courierID)
            .fethCourierAddresses();
        adressesList = addresses;
        await Auth().keepUserLoggedIn(
            storeID: event.storeID, courierId: event.courierID);
        emit(const AppStateLoggedIn(isLoading: false));
        await main();
        print('after main');
        add(AppEventGetDataPeriodic(
            storeID: event.storeID, courierID: event.courierID));
      } on FormatException catch (e) {
        if (e.message == 'not-found') {
          FormatError().setErrorMessage(e.message);
          emit(const AppStateLoginError(isLoading: false));
        } else {
          null;
        }
      }
    });
    on<AppEventGetData>((event, emit) async {
      emit(const AppStateLoggedIn(isLoading: true));
      final addresses = await FetchFromStorage(
              storeid: event.storeID, courierId: event.courierID)
          .fethCourierAddresses();
      adressesList = addresses;
      emit(const AppStateLoggedIn(isLoading: false));
      add(AppEventGetDataPeriodic(
          storeID: event.storeID, courierID: event.courierID));
    });
    on<AppEventGetDataPeriodic>((event, emit) {
      Timer.periodic(const Duration(seconds: 20), (timer) async {
        final addresses = await FetchFromStorage(
                storeid: event.storeID, courierId: event.courierID)
            .fethCourierAddresses();
        if (addresses.length > adressesList.length) {
          adressesList = addresses;
          final player = AudioPlayer();
          player.play(AssetSource('new_address.wav'));
          add(AppEventGetData(
              storeID: event.storeID, courierID: event.courierID));
        }
      });
    });

    on<AppEventSignOut>((event, emit) async {
      await Auth().signUserOut();
      await main();
      emit(const AppStateLoggedOut(isLoading: false));
    });

    on<AppEventCompleteOrder>((event, emit) async {
      emit(const AppStateLoggedIn(isLoading: true));
      await UpdateOnStorage(
              storeid: event.storeID,
              courierId: event.courierID,
              clientName: event.clientName)
          .completeOrder();
      add(AppEventGetData(storeID: event.storeID, courierID: event.courierID));
    });
  }
}
