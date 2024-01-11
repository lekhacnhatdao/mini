import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:openvpn/presentations/bloc/app_cubit.dart';
import 'package:openvpn/presentations/bloc/app_state.dart';

import 'package:openvpn/presentations/page/main/server_page/server_page.dart';
import 'package:openvpn/presentations/route/app_router.gr.dart';
import 'package:openvpn/presentations/widget/impl/app_thapgiac_text.dart';
import 'package:openvpn/presentations/widget/impl/custompre.dart';
import 'package:openvpn/presentations/widget/index.dart';
import 'package:openvpn/resources/colors.dart';

import 'package:openvpn/resources/icondata.dart';

class VpnPage extends StatefulWidget {
  const VpnPage({super.key});

  @override
  State<VpnPage> createState() => _VpnPageState();
}

class _VpnPageState extends State<VpnPage> {
  late TabController controller;
  late Timer? _timer = null;
  bool _dialogShown = false;
  Timer? _connectingTimer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maintenancePopup();
      context.read<AppCubit>().startBilling();
    });
    setState(() {});
  }

  Future<void> _maintenancePopup() async {
    await Future.delayed(const Duration(seconds: 7));
    if (!this.mounted) {
      return;
    }
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
                  context.read<AppCubit>().openVPN.disconnect();
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
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        if (state.isConnecting) {
          _connectingTimer ??= Timer(const Duration(seconds: 15), () {
            _showDisconnectDialog();
          });
        } else {
          _connectingTimer?.cancel();
          _connectingTimer = null;
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              const Divider(
                thickness: 1,
                color: Colors.blue,
              ),
              const SizedBox(
                height: 71,
              ),
              Align(
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return const ServerPage();
                      }));
                    },
                    child: Container(
                      height: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: const BoxDecoration(
                          color: Color(0xff1A1919),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Row(
                        children: [
                          Image.asset(
                            state.currentServer?.flag ??
                                'assets/images/Group51.png',
                            height: 32,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            state.currentServer?.country ?? 'Fastest Server',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          )
                        ],
                      ),
                    )),
              ),
              const SizedBox(
                height: 39,
              ),
              LoadingButtons(
                size: 80,
                icondata: Appicon.power,
                isLoading: state.isConnecting,
                icon: Icon(Appicon.menu),
                text: 'connecting',
                onPressed: state.isConnecting
                    ? () {
                       context.read<AppCubit>().openVPN.disconnect();
                    }
                    : () async {
                        await context.read<AppCubit>().toggle();
                      },
                changeUI: state.titleStatus == 'Not connected',
              ),
              const SizedBox(
                height: 46,
              ),
              Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color(0xff151515)),
                  margin: const EdgeInsets.symmetric(horizontal: 80),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      state.isConnecting
                          ? const Icon(
                              Icons.clear,
                              color: Colors.red,
                            )
                          : state.titleStatus == 'Not connected'
                              ? const Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.check,
                                  color: Color(0xff29BF12),
                                ),
                      Text(
                        state.isConnecting
                            ? ' Not connected to VPN'
                            : state.titleStatus == 'Not connected'
                                ? ' Not connected to VPN'
                                : 'Connected to VPN',
                        style: TextStyle(
                            color: state.isConnecting
                                ? Colors.red
                                : state.titleStatus == 'Not connected'
                                    ? Colors.red
                                    : const Color(0xff29BF12)),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 19,
              ),
              const CustomPre()
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 10),
              //   height: 377,
              //   decoration: const BoxDecoration(
              //       borderRadius: BorderRadius.all(Radius.circular(10)),
              //       color: Colors.black),
              //   child: Column(
              //     children: [
              //       SizedBox(height: 10,),
              //       const Text(
              //         'VPN connection',
              //         style: TextStyle(color: Colors.white),
              //       ),
              //       const SizedBox(height: 30),
              //       Expanded(
              //           child: Padding(
              //         padding: const EdgeInsets.fromLTRB(80, 0, 0, 0),
              //         child: GridView.builder(
              //           gridDelegate:
              //               const SliverGridDelegateWithMaxCrossAxisExtent(
              //                   maxCrossAxisExtent: 30,
              //                   mainAxisSpacing: 1,
              //                   childAspectRatio: 1,
              //                   crossAxisSpacing: 1),
              //           itemBuilder: (context, index) =>
              //               Center(child: BuildList(state.duration[index])),
              //           itemCount: state.duration.length,
              //         ),
              //       )),

              //       state.titleStatus == 'Not connected'
              //           ? const Text(
              //               "Your IP exposed to danger!",
              //               style: TextStyle(color: Color(0xffD62828)),
              //             )
              //           : state.isConnecting
              //               ? const Text(
              //                   "Your IP exposed to danger!",
              //                   style: TextStyle(color: Color(0xffD62828)),
              //                 )
              //               : const Text(
              //                   'Your IP is hidden, you are now very secure!',
              //                   style: TextStyle(color: Color(0xff119822)),
              //                 ),
              //                 SizedBox(height: 10,),
              //       const Dash(
              //           dashThickness: 2,
              //           dashLength: 10,
              //           dashGap: 6,
              //           length: 320,
              //           direction: Axis.horizontal,
              //           dashColor: Color(0xff2F2F2F)),
              //       const SizedBox(height: 10),
              //       Row(
              //         children: [
              //           const SizedBox(width: 8),
              //           const SizedBox(
              //             width: 8,
              //           ),
              //           Expanded(
              //  child: ClipRRect(
              //     borderRadius:
              //         const BorderRadius.all(Radius.circular(16)),
              //     child: Column(
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 40),
              //           child: AppLabelText(
              //             icon: Appicon.upload,
              //             text: Strings.download,
              //             coloricon: const Color(0xff08A045),
              //             size: 10,
              //             color: AppColors.textSecondary,
              //           ),
              //         ),
              //         const SizedBox(height: 8),
              //         AppTitleText(
              //             text: state.byteOut,
              //             size: 28,
              //             color: Colors.white)
              //       ],
              //     ),
              //   ),
              // ),
              //           const Dash(
              //               dashThickness: 2,
              //               dashLength: 10,
              //               length: 70,
              //               dashGap: 6,
              //               direction: Axis.vertical,
              //               dashColor: Color(0xff2F2F2F)),
              //           const SizedBox(width: 8),
              //           Expanded(
              //             child: ClipRRect(
              //               borderRadius:
              //                   const BorderRadius.all(Radius.circular(16)),
              //               child: Container(
              //                 child: Column(
              //                   children: [
              //                     // Padding(
              //                     //   padding: const EdgeInsets.symmetric(
              //                     //       horizontal: 40),
              //                     //   child: AppLabelText(
              //                     //     icon: Appicon.download,
              //                     //     coloricon: const Color(0xffF6AA1C),
              //                     //     text: Strings.upload,
              //                     //     size: 10,
              //                     //     color: AppColors.textSecondary,
              //                     //   ),
              //                     // ),
              //                     const SizedBox(height: 8),
              //                     AppTitleText(
              //                       text: state.byteIn,
              //                       size: 28,
              //                       color: Colors.white,
              //                     )
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           ),
              //           const SizedBox(width: 8),
              //         ],
              //       ),
              //       const Spacer(),
              //       const Spacer(),
              //       const SizedBox(height: 32),
              //     ],
              //   ),
              // ),
              ,
              const SizedBox(
                height: 150,
              ),
            ],
          ),
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  Widget BuildList(String d) {
    bool flag = false;
    if (d == ':') {
      flag = true;
    }
    return Row(
      children: [
        CustomPaint(painter: MyPainter()),
        const SizedBox(),
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: flag ? Colors.transparent : Colors.black,
          ),
          child: Text(
            d,
            style: const TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ],
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

  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
