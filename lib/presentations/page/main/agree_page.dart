import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';


import 'package:openvpn/presentations/page/main/setting_page/privacy_page.dart';
import 'package:openvpn/presentations/route/app_router.gr.dart';

import 'package:openvpn/resources/colors.dart';

import '../../../data/local/app_db.dart';

class AgreePage extends StatefulWidget {
  const AgreePage({super.key});

  @override
  State<AgreePage> createState() => _AgreePageState();
}

class _AgreePageState extends State<AgreePage> {
bool New = true;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(backgroundColor: Colors.black,
       
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: 
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: screenHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
               
                children: [
                  SizedBox(height: screenHeight * 0.1),
                  const PrivacyPolicyItem(
                    'Privacy and security',
                    'Keep your devices  updated with the latest security patches.'
                    'Safeguard your privacy, stay secure, and steer clear of data loss.',
                  ),

                  SizedBox(height: screenHeight * 0.1,),
                  Image.asset('assets/images/Group41.png'),
                  SizedBox(height: screenHeight * 0.09),
          
                  GestureDetector(
                    onTap: (){
                      
                      
                        AppDatabase().setAgreePrivacyStatus(true);
                       AutoRouter.of(context).replace(const MainRoute());
                      
                    },
                    child:  Container(
                      height: 50,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: AppColors.icon
                      ),
                        child: const Align(child: Text("Accept and continue", style: TextStyle(color: AppColors.primary),)) ,
                     
                     ),
                  ),
                  SizedBox(height: screenHeight * 0.15),
                ],
              ),
            ),
          ),
        
      
    );
  }
}