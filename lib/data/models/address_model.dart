// ignore_for_file: public_member_api_docs, sort_constructors_first
class AddressModel {
  String name;
  String observations;
  String address;
  String complement;
  String date;
  bool completed;
  AddressModel({
    required this.completed,
    required this.date,
    required this.name,
    required this.observations,
    required this.address,
    required this.complement,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      completed: map['completed'] as bool,
      date: map['date'] as String,
      name: map['client_name'] as String,
      observations: map['observations'] as String,
      address: map['address'] as String,
      complement: map['complement'] as String,
    );
  }
}

List<AddressModel> adressesList = [];
