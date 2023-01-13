// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entregga_courier/data/models/address_model.dart';

abstract class Storage {
  final storage = FirebaseFirestore.instance;
  final String storeid;
  final String courierId;
  final String? clientName;
  Storage({
    this.clientName,
    required this.storeid,
    required this.courierId,
  });
}

class FetchFromStorage extends Storage {
  FetchFromStorage({required super.storeid, required super.courierId});
  Future<List<AddressModel>> fethCourierAddresses() async {
    final ref = storage
        .collection('stores')
        .doc(storeid)
        .collection('couriers')
        .doc(courierId);
    final doc = await ref.get();
    if (doc.exists) {
      final addresses = await ref.collection('addresses').get();
      QuerySnapshot querySnapshot = addresses;
      final List data = querySnapshot.docs.map((doc) => doc.data()).toList();
      return data.map((data) => AddressModel.fromMap(data)).toList();
    } else {
      [];
      throw const FormatException('not-found');
    }
  }
}

class UpdateOnStorage extends Storage {
  UpdateOnStorage(
      {required super.storeid,
      required super.courierId,
      required super.clientName});
  Future completeOrder() async {
    await storage
        .collection('stores')
        .doc(storeid)
        .collection('couriers')
        .doc(courierId)
        .collection('addresses')
        .doc(clientName)
        .update({'completed': true});
  }
}
