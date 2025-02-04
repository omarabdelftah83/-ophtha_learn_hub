import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webinar/app/models/currency_model.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/common/data/api_public_data.dart';
import 'package:webinar/common/data/app_data.dart';
import 'package:webinar/common/data/app_language.dart';
import 'package:webinar/common/utils/currency_utils.dart';
import 'package:webinar/locator.dart';

import '../../../common/common.dart';
import '../../../common/enums/page_name_enum.dart';
import '../../../common/utils/app_text.dart';
import '../../../config/assets.dart';
import '../../../config/colors.dart';
import '../../../config/styles.dart';
import '../../providers/app_language_provider.dart';


class MainWidget{

  
  static showLanguageDialog() async {
    
    return await showDialog(
      context: navigatorKey.currentContext!, 
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: padding(horizontal: 25),
          child: directionality(
            child: Container(
              width: getSize().width,
              padding: padding(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: borderRadius(radius: 25)
              ),
              child: StatefulBuilder(
                builder: (context,state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
            
                      space(19),
            
                      Text(
                        appText.selectlanguage,
                        style: style16Bold(),
                      ),
          
                      space(16),
          
                      // country list
                      SizedBox(
                        width: getSize().width,
                        height: 100,
                        child: ListView.builder(
                          itemCount: locator<AppLanguage>().appLanguagesData.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
          
                                await locator<AppLanguage>().saveLanguage(locator<AppLanguage>().appLanguagesData[index].code!.toLowerCase());
                                locator<AppLanguageProvider>().changeState();

                                navigatorKey.currentState!.pop(locator<AppLanguage>().appLanguagesData[index]);
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                padding: padding(horizontal: 12),
                                margin: const EdgeInsets.only(bottom: 24),
                                width: getSize().height,
          
                                child: Row(
                                  children: [
          
                                    ClipRRect(
                                      borderRadius: borderRadius(radius: 50),
                                      child: Image.asset(
                                        locator<AppLanguage>().appLanguagesData[index].flagUri ?? '',
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
          
                                    space(0,width: 14),

                                    Expanded(
                                      child: Text(
                                        locator<AppLanguage>().appLanguagesData[index].name ?? '',
                                        style: style14Regular(),
                                      ),
                                    )
          
          
                                  ],
                                ),
                              ),
                            );
          
                          },
                        ),
                      ),
          
                      space(12),
          
                      button(
                        onTap: (){
                          backRoute();
                        }, 
                        width: getSize().width, 
                        height: 52, 
                        text: appText.cancel, 
                        bgColor: mainColor(),
                        textColor: Colors.white, 
                        borderColor: mainColor()
                      ),
          
                      space(11),
          
                    ],
                  );
                }
              ),
            ),
          ),
        );
      },
    );
  }

  static showCurrencyDialog() async {

    TextEditingController searchController = TextEditingController();
    FocusNode searchNode = FocusNode();

    List<CurrencyModel> searchList = PublicData.currencyListData.toList();

    return await showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: padding(horizontal: 25),
          child: directionality(
            child: StatefulBuilder(
              builder: (context,state) {
                return Container(
                  width: getSize().width,
                  padding: padding(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: borderRadius(radius: 25)
                  ),
                  child: StatefulBuilder(
                    builder: (context,state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          space(19),

                          Text(
                            appText.selectACurrency,
                            style: style16Bold(),
                          ),

                          space(16),

                          Center(
                            child: input(searchController, searchNode, appText.searchACurrency,iconPathLeft: AppAssets.searchSvg, isBorder: true, radius: 15,onChange: (text) {

                              if(text.trim().isEmpty){
                                searchList = PublicData.currencyListData.toList();
                              }else{
                                searchList = [];
                                PublicData.currencyListData.forEach((element) {
                                  if(element.currency?.toLowerCase().contains(text.trim().toLowerCase()) ?? false){
                                    searchList.add(element);
                                  }
                                });
                              }

                              state((){});

                            },),
                          ),

                          space(24),

                          // country list
                          SizedBox(
                            width: getSize().width,
                            height: 100,
                            child: ListView.builder(
                              itemCount: searchList.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {

                                    await AppData.saveCurrency(searchList[index].currency ?? '');
                                    CurrencyUtils.userCurrency = await AppData.getCurrency();


                                    locator<AppLanguageProvider>().changeState();

                                    navigatorKey.currentState!.pop(searchList[index]);
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    padding: padding(horizontal: 12),
                                    margin: const EdgeInsets.only(bottom: 24),
                                    width: getSize().height,

                                    child: Row(
                                      children: [

                                        Container(
                                          width: 25,
                                          height: 25,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffF8F8F8),
                                            borderRadius: borderRadius(radius: 5)
                                          ),
                                          child: Text(
                                            CurrencyUtils.getSymbol(searchList[index].currency ?? ''),
                                            style: style12Regular(),
                                          ),
                                        ),

                                        space(0,width: 14),

                                        Expanded(
                                          child: Text(
                                            searchList[index].currency ?? '',
                                            style: style14Regular(),
                                          ),
                                        )


                                      ],
                                    ),
                                  ),
                                );

                              },
                            ),
                          ),

                          space(25),

                          button(
                            onTap: (){
                              backRoute();
                            },
                            width: getSize().width,
                            height: 52,
                            text: appText.cancel,
                            bgColor: mainColor(),
                            textColor: Colors.white,
                            borderColor: mainColor()
                          ),

                          space(11),

                        ],
                      );
                    }
                  ),
                );
              }
            ),
          ),
        );
      },
    );
  }
  // static Future<CurrencyModel?> showCurrencyDialog() async {
  //   String currentCurrency = CurrencyUtils.userCurrency;
  //
  //   return await showDialog<CurrencyModel>(
  //     context: navigatorKey.currentContext!,
  //     builder: (context) {
  //       return Dialog(
  //         backgroundColor: Colors.transparent,
  //         insetPadding: padding(horizontal: 25),
  //         child: directionality(
  //           child: StatefulBuilder(
  //             builder: (context, state) {
  //               return Container(
  //                 width: getSize().width,
  //                 padding: padding(horizontal: 12),
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: borderRadius(radius: 25),
  //                 ),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     space(24),
  //
  //                     // عرض العملة الحالية فقط
  //                     GestureDetector(
  //                       onTap: () async {
  //                         // حفظ العملة المختارة
  //                         await AppData.saveCurrency(currentCurrency);
  //                         CurrencyUtils.userCurrency = await AppData.getCurrency();
  //
  //                         locator<AppLanguageProvider>().changeState();
  //
  //                         CurrencyModel selectedCurrency = CurrencyModel(
  //                           currency: currentCurrency,
  //                         );
  //
  //                         navigatorKey.currentState!.pop(selectedCurrency);
  //                       },
  //                       behavior: HitTestBehavior.opaque,
  //                       child: Container(
  //                         padding: padding(horizontal: 12),
  //                         margin: const EdgeInsets.only(bottom: 24),
  //                         width: getSize().height,
  //                         decoration: BoxDecoration(
  //                           color: mainColor(),
  //                           borderRadius: borderRadius(radius: 10),
  //                         ),
  //                         child: Row(
  //                           children: [
  //                             // رمز العملة
  //                             Container(
  //                               width: 25,
  //                               height: 25,
  //                               alignment: Alignment.center,
  //                               decoration: BoxDecoration(
  //                                 color: Colors.white.withOpacity(0.2),
  //                                 borderRadius: borderRadius(radius: 5),
  //                               ),
  //                               child: Text(
  //                                 CurrencyUtils.getSymbol(currentCurrency),
  //                                 style: style12Regular().copyWith(
  //                                   color: Colors.white,
  //                                   height: 1,
  //                                 ),
  //                               ),
  //                             ),
  //                             space(0, width: 14),
  //
  //                             // اسم العملة
  //                             Expanded(
  //                               child: Text(
  //                                 currentCurrency,
  //                                 style: style14Regular().copyWith(
  //                                   color: Colors.white,
  //                                   height: 1,
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //
  //                     space(25),
  //
  //                     // زر العودة
  //                     button(
  //                       onTap: () {
  //                         navigatorKey.currentState!.pop();
  //                       },
  //                       width: getSize().width,
  //                       height: 52,
  //                       text: appText.cancel,
  //                       bgColor: mainColor(),
  //                       textColor: Colors.white,
  //                       borderColor: mainColor(),
  //                     ),
  //
  //                     space(11),
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  static showExitDialog() async {

    return await showDialog(
      context: navigatorKey.currentContext!, 
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: padding(horizontal: 25),
          child: directionality(
            child: StatefulBuilder(
              builder: (context,state) {
                return Container(
                  width: getSize().width,
                  padding: padding(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: borderRadius(radius: 25)
                  ),
                  child: StatefulBuilder(
                    builder: (context,state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                
                          space(22),
                
                          Text(
                            appText.exit,
                            style: style16Bold(),
                          ),
                          
                          space(16),

                          Text(
                            appText.exitDesc,
                            style: style16Regular().copyWith(color: grey5E),
                          ),
                          
                          space(30),
          
                          Row(
                            children: [

                              Expanded(
                                child: button(
                                  onTap: (){
                                    exit(0);
                                  }, 
                                  width: getSize().width, 
                                  height: 52, 
                                  text: appText.yes, 
                                  bgColor: mainColor(),
                                  textColor: Colors.white, 
                                  borderColor: mainColor()
                                )
                              ),

                              Expanded(
                                child: button(
                                  onTap: (){
                                    backRoute();
                                  }, 
                                  width: getSize().width, 
                                  height: 52, 
                                  text: appText.cancel, 
                                  bgColor: Colors.transparent, 
                                  textColor: Colors.grey, 
                                  borderColor: Colors.transparent
                                )
                              ),
                              
                            ],
                          ),
          
                          space(11),
          
                        ],
                      );
                    }
                  ),
                );
              }
            ),
          ),
        );
      },
    );
  }


  static Widget menuButton(String iconPath,bool isBadegBadge,Color iconColor,Color bgColor,Function onTap){
    return GestureDetector(
      onTap: (){
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40,
        height: 40,

        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius(radius: 15),
        ),


        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(iconPath,colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),),
            ),

            if(isBadegBadge)...{

              Positioned(
                top: 11,
                right: 7,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: red49
                  ),
                )
              )
              
            }

          ],
        ),
      ),
    );

  }

  static Widget navItem(PageNames thisPage, PageNames selectedPage, String name, String icon, Function onTap) {
    return SizedBox(
      width: getSize().width * .18,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(
                thisPage == selectedPage ? navBarIconColor:  Colors.greenAccent ,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: style10RegularKufam().copyWith(
                color: thisPage == selectedPage ? navBarIconColor:  Colors.greenAccent ,
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }  static Widget homeNavItem(PageNames thisPage, PageNames selectedPage,Function onTap){
    return SizedBox(
      width: getSize().width * .18,
      child: GestureDetector(
        onTap: (){
          onTap();
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [


            Stack(
              children: [

                Center(child: SvgPicture.asset(AppAssets.homeNavSvg,
                  colorFilter:  ColorFilter.mode(SecondColor(), BlendMode.srcIn),)),

                Positioned(
                  bottom: 0,
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Center(child: SvgPicture.asset(AppAssets.homeSvg,
                      colorFilter:  ColorFilter.mode(navBarHomeIconColor, BlendMode.srcIn), width: 20))
                ),
              ],
            ),

            //space(10),

            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: 1,
              child: Text(
                appText.home,
                style: style10RegularKufam().copyWith(color: Colors.white),
              ),
            ),

            // space(8),
            //
            // AnimatedCrossFade(
            //   firstChild: SvgPicture.asset(AppAssets.navArrowSvg),
            //   secondChild: const SizedBox(height: 5,),
            //   crossFadeState: thisPage == selectedPage ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            //   duration: const Duration(milliseconds: 300),
            // )

          ],
        ),
      ),
    );

  }

}