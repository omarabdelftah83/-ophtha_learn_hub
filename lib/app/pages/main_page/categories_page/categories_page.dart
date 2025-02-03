import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:webinar/app/contact_utiles/contact_utiles.dart';
import 'package:webinar/app/pages/main_page/categories_page/filter_category_page/filter_category_page.dart';
import 'package:webinar/app/pages/main_page/home_page/notification_page.dart';
import 'package:webinar/app/providers/app_language_provider.dart';
import 'package:webinar/app/providers/drawer_provider.dart';
import 'package:webinar/app/services/guest_service/categories_service.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/shimmer_component.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/config/colors.dart';
import 'package:webinar/config/styles.dart';
import '../../../../common/utils/object_instance.dart';
import '../../../models/category_model.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  bool isLoading = true;
  List<CategoryModel> trendCategories = [];
  List<CategoryModel> categories = [];

  @override
  void initState() {
    super.initState();

    Future.wait([getCategoriesData(), getTrendCategoriessData()]).then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future getCategoriesData() async {
    categories = await CategoriesService.categories();
  }

  Future getTrendCategoriessData() async {
    trendCategories = await CategoriesService.trendCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppLanguageProvider>(
        builder: (context, appLanguageProvider, _) {
      return directionality(child:
          Consumer<DrawerProvider>(builder: (context, drawerProvider, _) {
        return ClipRRect(
          borderRadius:
              borderRadius(radius: drawerProvider.isOpenDrawer ? 20 : 0),
          child: Scaffold(
            backgroundColor: greyFA,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.deepPurpleAccent,
                              Colors.purple.withOpacity(0.7),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(65),
                            bottomRight: Radius.circular(65),
                          ),
                        ),
                        height: 70,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 20),

                      const Center(
                          child: Text(
                        'من فضلك اكتب التخصص الدي ترغب دراسته',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                      // SizedBox(
                      //   width: getSize().width,
                      //   child: SingleChildScrollView(
                      //     scrollDirection: Axis.horizontal,
                      //     physics: const BouncingScrollPhysics(),
                      //     child: Row(
                      //       children: List.generate(
                      //           isLoading ? 3 : trendCategories.length,
                      //           (index) {
                      //         return isLoading
                      //             ? horizontalCategoryItemShimmer()
                      //             : horizontalCategoryItem(
                      //                 trendCategories[index].color ??
                      //                     mainColor(),
                      //                 trendCategories[index].icon ?? '',
                      //                 trendCategories[index].title ?? '',
                      //                 trendCategories[index]
                      //                         .webinarsCount
                      //                         ?.toString() ??
                      //                     '0', () {
                      //                 nextRoute(FilterCategoryPage.pageName,
                      //                     arguments: trendCategories[index]);
                      //               });
                      //       }),
                      //     ),
                      //   ),
                      // ),
                      space(14),
                      // categories
                      Container(
                        width: getSize().width,
                        margin: padding(),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: borderRadius(),
                        ),
                        child: Column(
                          children: [
                            ...List.generate(isLoading ? 8 : categories.length,
                                (index) {
                              return isLoading
                                  ? categoryItemShimmer()
                                  : Container(
                                      width: getSize().width,
                                      padding: padding(),
                                      child: Column(
                                        children: [
                                          //     space(16),

                                          buildStageButton(
                                              categories[index].title ?? '',
                                              onPressed: () {
                                            if ((categories[index]
                                                    .subCategories
                                                    ?.isEmpty ??
                                                false)) {
                                              nextRoute(
                                                  FilterCategoryPage.pageName,
                                                  arguments: categories[index]);
                                            } else {
                                              setState(() {
                                                categories[index].isOpen =
                                                    !categories[index].isOpen;
                                              });
                                            }
                                          }),

                                          AnimatedCrossFade(
                                              firstChild: Stack(
                                                children: [
                                                  // vertical dash
                                                  PositionedDirectional(
                                                    start: 15,
                                                    top: 0,
                                                    bottom: 35,
                                                    child: CustomPaint(
                                                      size: const Size(
                                                          .5, double.infinity),
                                                      painter:
                                                          DashedLineVerticalPainter(),
                                                      child: const SizedBox(),
                                                    ),
                                                  ),

                                                  // sub category
                                                  SizedBox(
                                                    child: Column(
                                                      children: List.generate(
                                                          categories[index]
                                                                  .subCategories
                                                                  ?.length ??
                                                              0, (i) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            nextRoute(
                                                                FilterCategoryPage
                                                                    .pageName,
                                                                arguments: categories[
                                                                        index]
                                                                    .subCategories![i]);
                                                          },
                                                          behavior:
                                                              HitTestBehavior
                                                                  .opaque,
                                                          child: Column(
                                                            children: [
                                                              space(15),

                                                              // sub categories item
                                                              Padding(
                                                                padding: padding(
                                                                    horizontal:
                                                                        10),
                                                                child: Row(
                                                                  children: [
                                                                    // circle
                                                                    Container(
                                                                      width: 10,
                                                                      height:
                                                                          10,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          border: Border.all(
                                                                              color:
                                                                                  greyE7,
                                                                              width:
                                                                                  1),
                                                                          shape:
                                                                              BoxShape.circle),
                                                                    ),

                                                                    space(0,
                                                                        width:
                                                                            22),

                                                                    // sub category details
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          categories[index].subCategories?[i].title ??
                                                                              '',
                                                                          style:
                                                                              style14Bold(),
                                                                          maxLines:
                                                                              1,
                                                                        ),
                                                                        Text(
                                                                          categories[index].subCategories?[i].webinarsCount == 0
                                                                              ? appText.noCourse
                                                                              : '${categories[index].subCategories?[i].webinarsCount} ${appText.courses}',
                                                                          style:
                                                                              style12Regular().copyWith(color: greyA5),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),

                                                              space(15),
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              secondChild: SizedBox(
                                                width: getSize().width,
                                              ),
                                              crossFadeState: categories[index]
                                                      .isOpen
                                                  ? CrossFadeState.showFirst
                                                  : CrossFadeState.showSecond,
                                              duration: const Duration(
                                                  milliseconds: 300)),

                                          space(15),

                                          Container(
                                            width: getSize().width,
                                            height: 1,
                                            decoration:
                                                BoxDecoration(color: greyF8),
                                          )
                                        ],
                                      ),
                                    );
                            })
                          ],
                        ),
                      ),

                      space(120),
                    ],
                  ),
                  Positioned(
                    top: 20,
                    right: 5,
                    child: Row(
                      children: [

                         IconButton(
                          onPressed: () {
                            drawerController.showDrawer();

                          },
                          icon: const Icon(
                            Icons.grid_view_rounded,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),



                        const SizedBox(
                          width: 5,
                        ),

                        ClipOval(
                          child: Image.asset(
                            'assets/image/png/anmka.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Positioned(
                    top: 15,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        ' MENTAL SKILLS  \n  ❤ LEARN WITH LOVE  ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                   Positioned(
                    top: 20,
                    left: 10,
                    child: Row(
                      children: [

                        GestureDetector(
                          onTap: () {

                            ContactUtils.sendWhatsAppMessage("+201234567890", message: "مرحبًا! كيف يمكنني مساعدتك؟");
                          },
                          child: const FaIcon(
                            FontAwesomeIcons.whatsapp,
                            size: 40,
                            color: Colors.green,
                          ),
                        ),

                        const SizedBox(width: 5),
                        IconButton(

                          icon: const Icon(Icons.notifications,size: 40, color: Colors.white,),
                          onPressed: (){
                            nextRoute(NotificationPage.pageName, isClearBackRoutes: true);
                          }


                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }));
    });
  }

  Widget buildStageButton(String title, {required void Function()? onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      onPressed: onPressed,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade900, Colors.purple.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(minHeight: 60),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class DashedLineVerticalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 6, dashSpace = 5, startY = 0;
    final paint = Paint()
      ..color = Colors.grey.withOpacity(.5)
      ..strokeWidth = .4;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
