
import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:openvpn/presentations/bloc/app_cubit.dart';
import 'package:openvpn/presentations/bloc/app_state.dart';
import 'package:openvpn/presentations/page/main/setting_page/settingpage.dart';
import 'package:openvpn/presentations/page/main/vpn_page.dart';
import 'package:openvpn/presentations/route/app_router.gr.dart';
import 'package:openvpn/presentations/widget/impl/app_buttons.dart';
import 'package:openvpn/presentations/widget/impl/customdata.dart';
import 'package:openvpn/resources/colors.dart';
import 'package:openvpn/resources/icondata.dart';
import 'package:openvpn/resources/strings.dart';
import 'package:openvpn/resources/theme.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late TabController controller;
   late Timer? _timer;
  bool _dialogShown = false;
  Timer? _connectingTimer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maintenancePopup();
      context.read<AppCubit>().startBilling();
    });
    setState(() {
      
    });
    controller = TabController(length: 3, vsync: this);
  }

  Future<void> _maintenancePopup() async {
    await Future.delayed(const Duration(seconds: 7));
    if (context.read<AppCubit>().state.servers.isEmpty && !_dialogShown) {
      _showMaintenanceDialog();
    }
    _timer = Timer.periodic(const Duration(seconds: 60), (Timer timer) {
      context.read<AppCubit>().fetchServerList();
      if (context.read<AppCubit>().state.servers.isEmpty && !_dialogShown) {
        _showMaintenanceDialog();
      }
    });
  }

  void _showMaintenanceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        _dialogShown = true;
        return AlertDialog(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Network Error'),
            ],
          ),
          content: const Text(
              textAlign: TextAlign.center,
              'We are maintaining the system to upgrade the server. Please try again later'),
          actions: <Widget>[
            AppButtons(
                textColor: AppColors.primary,
                text: "Close",
                backgroundColor: AppColors.colorRed,
                onPressed: () {
                  Navigator.pop(context);
                  _dialogShown = false;
                }),
          ],
        );
      },
    );
  }
void _showDisconnectDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        _dialogShown = true;
        return AlertDialog(
          title: const Text('Oops! Sorry (-_-)'),
          content: const Text(
              'This server is currently down, please disconnect and choose other server'),
          actions: <Widget>[
            AppButtons(
                textColor: AppColors.primary,
                text: "Disconnect",
                backgroundColor: AppColors.colorRed,
                onPressed: () {
                  _handleConnectButtonPressed();
                  // Navigator.pop(context);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  _dialogShown = false;
                }),
          ],
        );
      },
    );
  }
 
  
  


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading : false,
          backgroundColor: Colors.black,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 20,
              ),
              const Image(
                image: AssetImage('assets/images/Group51.png'),
                height: 30,
              ),
              Text(
                'Unlimited Connection',
                style: CustomTheme.textTheme.labelLarge?.copyWith(),
              )
            ],
          ),
          actions: [
           
            const SizedBox(
              width: 13,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Color(0xff131313),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SettingPage()));
                },
                child: Icon(
                  Appicon.menu,
                  color: AppColors.icon,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            // BlocBuilder<AppCubit, AppState>(
            //   builder: (context, state) {
            //     return Container(
            //       decoration: const BoxDecoration(
            //         boxShadow: <BoxShadow>[
            //           BoxShadow(
            //             color: Colors.white12,
            //             blurRadius: 10,
            //           ),
            //         ],
            //         borderRadius: BorderRadius.all(Radius.circular(100)),
            //       ),
            //       padding: const EdgeInsets.symmetric(horizontal: 16),
            //       child: CachedNetworkImage(
            //         imageUrl: state.currentServer?.flag ?? 'assets/images/Frame.png',
            //         height: 32,
            //       ),
            //     );
            //   },
            // )
          ],
        ),
        body:  const VpnPage(),
      
          // CustomBar(
          //   lenght: controller.length,
          //   icon: [
          //     Appicon.heart,
          //     Appicon.flashcircle,
          //     Icons.settings,
          //   ],
          //   onSelect: (index ) => controller.animateTo(index),
          // )
        
        bottomNavigationBar: BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            return Container(
              color: const Color(0xff131313),
              height: MediaQuery.of(context).size.height / 5.3,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomData(
                            icon: Appicon.download,
                            color: const Color(0xff00D589),
                            text: Strings.download,
                            data: state.byteOut,
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          CustomData(
                            icon: Appicon.upload,
                            color: const Color(0xffE63946),
                            text: Strings.upload,
                            data: state.byteIn,
                          )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Align(
                          child: Dash(
                              dashColor: AppColors.icon,
                              length: 270,
                              dashLength: 7,
                              dashGap: 5,
                              dashThickness: 2),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomData(
                            icon: Appicon.ping,
                            color: const Color(0xffFF9914),
                            text: 'IP Server',
                            data: state.currentServer?.ip ?? '',
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          CustomData(
                            icon: Appicon.times,
                            color: const Color(0xff008BF8),
                            text: 'Time',
                            data: state.duration,
                          )
                        ],
                      )
                    ],
                  ),
                  Positioned(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 18),
                      child: const Align(
                        child: Dash(
                            direction: Axis.vertical,
                            dashColor: AppColors.icon,
                            length: 110,
                            dashLength: 7,
                            dashGap: 5,
                            dashThickness: 2),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
   @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _navigateToSelectLocation() {
    AutoRouter.of(context).push(const ServerRoute());
  }

  void _handleConnectButtonPressed() {
    context.read<AppCubit>().toggle();
  }
}


