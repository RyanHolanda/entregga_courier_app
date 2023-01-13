import 'package:entregga_courier/application/bloc/app_bloc.dart';
import 'package:entregga_courier/application/presentation/views/qr_code_screen/qr_code_screen.dart';
import 'package:entregga_courier/application/presentation/widgets/buttons/main_button.dart';
import 'package:entregga_courier/application/presentation/widgets/buttons/main_button_with_icon.dart';
import 'package:entregga_courier/application/presentation/widgets/dialogs/alert_dialog.dart';
import 'package:entregga_courier/domain/text_controllers/textcontrollers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state is AppStateLoginError) {
          MyAlertDialog(
                  content: AppLocalizations.of(context)!.unknownStoreOrCourier,
                  title: AppLocalizations.of(context)!.notFound)
              .showMyDialog(context);
        }
      },
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                toolbarHeight: 0,
              ),
              body: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                  return true;
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 50, horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.helloCourier,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22)),
                        Text(AppLocalizations.of(context)!.loginDescription,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.3))),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 3.5,
                          child: LottieBuilder.asset(
                            'assets/login_animation.json',
                          ),
                        ),
                        TextField(
                          controller: TextControllers.storeIdController,
                          decoration: InputDecoration(
                              filled: true,
                              hintText: AppLocalizations.of(context)!.storeID,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: TextControllers.courierIdController,
                          decoration: InputDecoration(
                              filled: true,
                              hintText: AppLocalizations.of(context)!.courierID,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        state.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : MainButton(
                                label: AppLocalizations.of(context)!.login,
                                onPressed: () {
                                  if (TextControllers
                                          .storeIdController.text.isNotEmpty &&
                                      TextControllers.courierIdController.text
                                          .isNotEmpty) {
                                    context.read<AppBloc>().add(AppEventLogin(
                                        storeID: TextControllers
                                            .storeIdController.text,
                                        courierID: TextControllers
                                            .courierIdController.text));
                                  } else {
                                    null;
                                  }
                                },
                              ),
                        const SizedBox(
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: 1,
                              color: Theme.of(context).dividerColor,
                              width: MediaQuery.of(context).size.width / 4,
                            ),
                            Text(AppLocalizations.of(context)!.or),
                            Container(
                              color: Theme.of(context).dividerColor,
                              height: 1,
                              width: MediaQuery.of(context).size.width / 4,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        MainButtonWithIcon(
                          height: 55,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QrCodeScreen(),
                                ));
                          },
                          icon: Icons.qr_code,
                          backgroundColor: Theme.of(context).primaryColor,
                          labelText: AppLocalizations.of(context)!.scanQrCode,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
