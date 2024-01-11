import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:openvpn/presentations/page/main/setting_page/history_page.dart';

import 'package:openvpn/presentations/page/main/setting_page/currentpage.dart';
import 'package:openvpn/presentations/page/main/setting_page/privacy_page.dart';
import 'package:openvpn/presentations/page/main/setting_page/terms_page.dart';

import 'package:openvpn/presentations/widget/impl/Cutomratting.dart';
import 'package:openvpn/presentations/widget/impl/custompre.dart';

import 'package:openvpn/resources/colors.dart';
import 'package:openvpn/resources/icondata.dart';
import 'package:openvpn/resources/theme.dart';
import 'package:openvpn/utils/config.dart';
import 'package:share_plus/share_plus.dart';


class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final List<Settings> setting = [
      Settings(
        text: 'Current IP',
        icon: Icons.location_on_outlined,
        OnTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) => const CurrentPage()));
        }
      ),
        Settings(
        text: 'History page',
        icon: Icons.history,
        OnTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryPage()));
        }
      ),
      Settings(
       text: 'Share app',
        icon: Appicon.link,
        OnTap: (){
          Share.share(Config.storeAppUrl);
        }
      ),
      Settings(
        text: 'Feedback',
        icon: Appicon.feedback,
        OnTap: (){
         showDialog(context: context, builder: (BuildContext)  =>const RatingDialog());
        }
      ),
      Settings(
       text: 'Terms',
        icon: Appicon.tems,
        OnTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsPage()));
        }
      ),
      Settings(
       text: 'Security',
        icon: Appicon.seciurity,
        OnTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPage()));
        }
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white,),),
        title:   Text('Menu', style: CustomTheme.textTheme.labelLarge?.copyWith(
          fontSize: 20
        ),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            
            child: GridView.builder(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: ((context, i) {
                return CSsetting(setting[i]);
              }),
              itemCount: setting.length,
            ),
          ),
          const CustomPre()
        ],
      ),
    );
//       body: Column(
//         children: [
//           SettingListTile(title: 'Go VIP', ispre: true ,svgWidget: Assets.icons.icPower.svg(), onPressed: (){
//             Navigator.push(context, MaterialPageRoute(builder: (_)=>  PremiumPage()));
//           },),
//           SettingListTile(title: 'Recent'  ,svgWidget: Assets.icons.icPower.svg(), onPressed: (){
//             Navigator.push(context, MaterialPageRoute(builder: (_)=>  PremiumPage()));
//           },),
//           SettingListTile(title: 'Go VIP', ispre: true ,svgWidget: Assets.icons.icPower.svg(), onPressed: (){
//             Navigator.push(context, MaterialPageRoute(builder: (_)=>  PremiumPage()));
//           },),
//           SettingListTile(title: 'Go VIP', ispre: true ,svgWidget: Assets.icons.icPower.svg(), onPressed: (){
//             Navigator.push(context, MaterialPageRoute(builder: (_)=>  PremiumPage()));
//           },)
//         ],

//       ),
//     );
//   }

// }

  }
}
CSsetting( Settings settings){
return InkWell(
  onTap:settings.OnTap,
  child: Container(
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10)),color: Color(0xff131313),
    ),
    
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(settings.icon, color: Colors.white,),
        Text(settings.text, style: CustomTheme.textTheme.labelLarge?.copyWith(),),
      ],
    ),
  ),
);
}
class Settings {
  late Function() OnTap;
  late IconData icon;
  late String text;
  Settings({required this.OnTap, required this.icon, required this.text});
}
class SettingListTile extends StatelessWidget {
  final Widget svgWidget;
  final String title;
  final VoidCallback? onPressed;
  final Color? color;
  final bool? ispre;

  const SettingListTile({
    super.key,
    required this.svgWidget,
    required this.title,
    this.onPressed,
    this.color, this.ispre,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8, left: 1, right: 1),
      decoration: BoxDecoration(
        color: Colors.blue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1, // Độ rộng mà drop shadow lan ra
            blurRadius: 3, // Độ mờ của drop shadow
            offset: const Offset(0, 3), // Vị trí của drop shadow
          )
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: ListTile(
        onTap: onPressed,
        leading:ispre??false? Image.asset('assets/images/crown.png') : svgWidget,
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
        trailing: const InkWell(
            child: Icon(
          Icons.arrow_forward,
          color: AppColors.colorBlue,
        )),
      ),
    );
    }
}