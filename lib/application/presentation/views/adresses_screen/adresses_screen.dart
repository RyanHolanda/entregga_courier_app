import 'package:entregga_courier/application/bloc/app_bloc.dart';
import 'package:entregga_courier/application/presentation/views/completed_addresses_screen/completed_addresses_screen.dart';
import 'package:entregga_courier/application/presentation/views/loading_screen/loading_screen.dart';
import 'package:entregga_courier/application/presentation/widgets/buttons/main_button_with_icon.dart';
import 'package:entregga_courier/application/presentation/widgets/dialogs/sign_out_dialog.dart';
import 'package:entregga_courier/data/models/address_model.dart';
import 'package:entregga_courier/domain/user_auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdressesScreen extends StatelessWidget {
  const AdressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Scaffold(
          bottomSheet: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              height: 70,
              width: MediaQuery.of(context).size.width,
              child: MainButtonWithIcon(
                  icon: Icons.open_in_new,
                  onPressed: () async {
                    List urlList = [];
                    for (var i = 0; i < adressesList.length; i++) {
                      urlList.add(adressesList[i].completed
                          ? ''
                          : '${adressesList[i].address}/');
                    }

                    final url =
                        'https://www.google.com/maps/dir//${urlList.join()}';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url),
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  labelText: AppLocalizations.of(context)!.openAllInMaps,
                  backgroundColor: Theme.of(context).primaryColor,
                  height: 50)),
          appBar: AppBar(
            toolbarHeight: 0,
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          body: state.isLoading
              ? const LoadingAddressScreen()
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.yourAdresses,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            PopupMenuButton(
                              onSelected: (value) => value == 'finisheds'
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CompletedAdressesScreen(),
                                      ))
                                  : MySignoutDialog(
                                          content: AppLocalizations.of(context)!
                                              .areYouSureSignOutDescription,
                                          title: AppLocalizations.of(context)!
                                              .areYouSureSignOut)
                                      .showMyDialog(context),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    value: 'finisheds',
                                    child: Text(AppLocalizations.of(context)!
                                        .completeds),
                                  ),
                                  PopupMenuItem(
                                      onTap: () {},
                                      value: 'signOut',
                                      child: Text(
                                        AppLocalizations.of(context)!.signOut,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ))
                                ];
                              },
                            ),
                          ],
                        ),
                        ListView.builder(
                          padding: const EdgeInsets.only(bottom: 50),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: adressesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            adressesList.sort(
                              (a, b) => a.date.compareTo(b.date),
                            );
                            return adressesList[index].completed
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                adressesList[index].name,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                          Text(
                                              adressesList[index].observations),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    Clipboard.setData(
                                                        ClipboardData(
                                                            text: adressesList[
                                                                    index]
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
                                                      await launchUrl(
                                                          Uri.parse(url),
                                                          mode: LaunchMode
                                                              .externalApplication);
                                                    }
                                                  },
                                                  icon: const Icon(
                                                      Icons.open_in_new)),
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
                                                      icon: const Icon(
                                                          Icons.check))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
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
