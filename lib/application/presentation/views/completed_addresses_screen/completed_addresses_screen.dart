import 'package:entregga_courier/application/bloc/app_bloc.dart';
import 'package:entregga_courier/data/models/address_model.dart';
import 'package:entregga_courier/domain/user_auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class CompletedAdressesScreen extends StatelessWidget {
  const CompletedAdressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            title: Text(
              'Completed orders',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: adressesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      adressesList.sort(
                        (a, b) => a.date.compareTo(b.date),
                      );
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: adressesList[index].completed
                            ? Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 12,
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.1))
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          adressesList[index].name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Text(
                                          adressesList[index].date,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.2)),
                                        ),
                                      ],
                                    ),
                                    Text(adressesList[index].address),
                                    Text(adressesList[index].complement),
                                    Text(adressesList[index].observations),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(
                                                  text: adressesList[index]
                                                      .address));
                                            },
                                            icon: const Icon(Icons.copy)),
                                        Container(
                                          width: 1,
                                          height: 10,
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.3),
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                              final url =
                                                  'https://www.google.com/maps/dir//${adressesList[index].address}';
                                              if (await canLaunchUrl(
                                                  Uri.parse(url))) {
                                                await launchUrl(Uri.parse(url),
                                                    mode: LaunchMode
                                                        .externalApplication);
                                              }
                                            },
                                            icon:
                                                const Icon(Icons.open_in_new)),
                                        adressesList[index].completed
                                            ? const SizedBox.shrink()
                                            : Container(
                                                width: 1,
                                                height: 10,
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.3),
                                              ),
                                        adressesList[index].completed
                                            ? const SizedBox.shrink()
                                            : IconButton(
                                                onPressed: () {
                                                  context.read<AppBloc>().add(
                                                      AppEventCompleteOrder(
                                                          clientName:
                                                              adressesList[
                                                                      index]
                                                                  .name,
                                                          storeID:
                                                              userLoggedStoreID!,
                                                          courierID:
                                                              userLoggedCourierID!));
                                                },
                                                icon: const Icon(Icons.check))
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
