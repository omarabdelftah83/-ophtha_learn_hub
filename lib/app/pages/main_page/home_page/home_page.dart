import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:webinar/app/contact_utiles/contact_utiles.dart';
import 'package:webinar/app/pages/main_page/categories_page/filter_category_page/filter_category_page.dart';
import 'package:webinar/app/pages/main_page/home_page/notification_page.dart';
import 'package:webinar/app/providers/drawer_provider.dart';
import 'package:webinar/app/services/guest_service/course_service.dart';
import 'package:webinar/app/services/user_service/user_service.dart';
import 'package:webinar/app/widgets/main_widget/home_widget/home_widget.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/data/app_data.dart';
import 'package:webinar/common/shimmer_component.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/common/utils/object_instance.dart';
import 'package:webinar/config/assets.dart';
import 'package:webinar/config/colors.dart';
import 'package:webinar/config/styles.dart';
import '../../../../locator.dart';
import '../../../models/course_model.dart';
import '../../../providers/app_language_provider.dart';
import '../../../../common/components.dart';
import '../../../providers/filter_course_provider.dart';

import 'package:carousel_slider/carousel_slider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{

  String token = '';
  String name = '';

  TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();

  late AnimationController appBarController;
  late Animation<double> appBarAnimation;

  double appBarHeight = 230;

  ScrollController scrollController = ScrollController();

  PageController sliderPageController = PageController();
  int currentSliderIndex = 0;
  
  PageController adSliderPageController = PageController();
  int currentAdSliderIndex = 0;

  
  
  bool isLoadingFeaturedListData=false;
  List<CourseModel> featuredListData = [];

  bool isLoadingNewsetListData=false;
  List<CourseModel> newsetListData = [];
  
  bool isLoadingBestRatedListData=false;
  List<CourseModel> bestRatedListData = [];
  
  bool isLoadingBestSellingListData=false;
  List<CourseModel> bestSellingListData = [];
  
  bool isLoadingDiscountListData=false;
  List<CourseModel> discountListData = [];
  
  bool isLoadingFreeListData=false;
  List<CourseModel> freeListData = [];
  
  bool isLoadingBundleData=false;
  List<CourseModel> bundleData = [];


  @override
  void initState() {
    super.initState();

    getToken();

    appBarController = AnimationController(vsync: this,duration: const Duration(milliseconds: 200));
    appBarAnimation = Tween<double>(
      begin: 150 + MediaQuery.of(navigatorKey.currentContext!).viewPadding.top, 
      end: 80 + MediaQuery.of(navigatorKey.currentContext!).viewPadding.top, 
    ).animate(appBarController);

    scrollController.addListener(() {

      if(scrollController.position.pixels > 100){

        if(!appBarController.isAnimating){
          if(appBarController.status == AnimationStatus.dismissed){
            appBarController.forward();
          }
        }
      }else if(scrollController.position.pixels < 50){
        
        if(!appBarController.isAnimating){
          if(appBarController.status == AnimationStatus.completed){
            appBarController.reverse();
          }
        }

      }
    });


    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      if(ModalRoute.of(context)!.settings.arguments != null){ 
        if(AppData.canShowFinalizeSheet){
          
          AppData.canShowFinalizeSheet = false;

          // finalize signup
          HomeWidget.showFinalizeRegister( (ModalRoute.of(context)!.settings.arguments as int) ).then((value) {
            if(value){
              getToken();
            }
          });

        }
      }

    });

    getData();
  }


  getData(){

    isLoadingFeaturedListData = true;
    isLoadingNewsetListData = true;
    isLoadingBundleData=true;
    isLoadingBestRatedListData=true;
    isLoadingBestSellingListData=true;
    isLoadingDiscountListData=true;
    isLoadingFreeListData=true;
    
    CourseService.featuredCourse().then((value) {
      setState(() {
        isLoadingFeaturedListData = false;
        featuredListData = value;
      });
    });

    CourseService.getAll(offset: 0, bundle: true).then((value) {
      setState(() {
        isLoadingBundleData=false;
        bundleData = value;
      });
    });

    CourseService.getAll(offset: 0, sort: 'newest').then((value) {
      setState(() {
        isLoadingNewsetListData=false;
        newsetListData = value;
      });
    });

    CourseService.getAll(offset: 0, sort: 'best_rates').then((value) {
      setState(() {
        isLoadingBestRatedListData = false;
        bestRatedListData = value;
      });
    });

    
    CourseService.getAll(offset: 0, sort: 'bestsellers').then((value) {
      setState(() {
        isLoadingBestSellingListData = false;
        bestSellingListData = value;
      });
    });
    
    CourseService.getAll(offset: 0, discount: true).then((value) {
      setState(() {
        isLoadingDiscountListData = false;
        discountListData = value;
      });
    });
    
    CourseService.getAll(offset: 0, free: true).then((value) {
      setState(() {
        isLoadingFreeListData = false;
        freeListData = value;
      });
    });
  }


  getToken()async{

    AppData.getAccessToken().then((value) {
      setState(() {
        token = value;
      });

      if(token.isNotEmpty){
        
        // get profile and save naem
        UserService.getProfile().then((value) async {
          if(value != null){            
            await AppData.saveName(value.fullName ?? '');
            getUserName();
          }
        });
        
      }
    });
    
    getUserName();
    
  }

  getUserName(){

    AppData.getName().then((value) {
      setState(() {
        name = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
   
    return Consumer<AppLanguageProvider>(
      builder: (context, languageProvider, _) {
        
        return directionality(
          child: Consumer<DrawerProvider>(
            builder: (context, drawerProvider, _) {
              
              return ClipRRect(
                borderRadius: borderRadius(radius:  drawerProvider.isOpenDrawer ? 20 : 0),
                child: Scaffold(
                  body: Stack(
                    children: [
                      Column(
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

                          // app bar
                          //  HomeWidget.homeAppBar(appBarController, appBarAnimation, token, searchController, searchNode, name),
                          // body
                          Expanded(
                            child: CustomScrollView(
                              controller: scrollController,
                              physics: const BouncingScrollPhysics(),
                              slivers: [
                                SliverToBoxAdapter(
                                  child: Column(
                                    children: [



                                      // Newest Classes
                                      Column(
                                        children: [
                                          HomeWidget.titleAndMore(appText.newestClasses, onTapViewAll: (){
                                            locator<FilterCourseProvider>().clearFilter();
                                            locator<FilterCourseProvider>().sort = 'newest';
                                            nextRoute(FilterCategoryPage.pageName);
                                          }),
                                          newsetListData.isEmpty && !isLoadingNewsetListData
                                              ? SizedBox()
                                              : CarouselSlider.builder(
                                            options: CarouselOptions(
                                              height: 200,
                                              autoPlay: true, // تشغيل الحركة التلقائية
                                              autoPlayInterval: const Duration(seconds: 3), // مدة التوقف عند كل عنصر
                                              enlargeCenterPage: false, // منع تكبير العنصر في المنتصف
                                              viewportFraction: 0.4, // التحكم في عدد العناصر الظاهرة جنب بعضها
                                              enableInfiniteScroll: true, // جعل السلايدر يتحرك بلا نهاية
                                              scrollPhysics: const BouncingScrollPhysics(), // منع التمرير اليدوي
                                            ),
                                            itemCount: isLoadingNewsetListData ? 3 : newsetListData.length,
                                            itemBuilder: (context, index, realIndex) {
                                              if (isLoadingNewsetListData) {
                                                return courseItemShimmer(); // عرض تأثير التحميل عند عدم توفر البيانات
                                              } else {
                                                return courseItem(newsetListData[index]); // عرض الكورسات عند توفر البيانات
                                              }
                                            },
                                          ),


                                          // SizedBox(
                                          //   width: getSize().width,
                                          //   child: SingleChildScrollView(
                                          //     physics: const BouncingScrollPhysics(),
                                          //     padding: padding(),
                                          //     scrollDirection: Axis.horizontal,
                                          //     child: Row(
                                          //       children: List.generate( isLoadingNewsetListData ? 3 : newsetListData.length, (index) {
                                          //
                                          //         return isLoadingNewsetListData
                                          //           ? courseItemShimmer()
                                          //           : courseItem(
                                          //               newsetListData[index],
                                          //             );
                                          //       }),
                                          //     ),
                                          //   ),
                                          // )

                                        ],
                                      ),






                                      // Bundle
                                      Column(
                                        children: [
                                          HomeWidget.titleAndMore(appText.latestBundles, onTapViewAll: (){
                                            locator<FilterCourseProvider>().clearFilter();
                                            locator<FilterCourseProvider>().bundleCourse = true;
                                            nextRoute(FilterCategoryPage.pageName);
                                          }),

                                          SizedBox(
                                            width: getSize().width,
                                            child: SingleChildScrollView(
                                              physics: const BouncingScrollPhysics(),
                                              padding: padding(),
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: List.generate( isLoadingBundleData ? 3 : bundleData.length, (index) {
                                                  return isLoadingBundleData
                                                    ? courseItemShimmer()
                                                    : courseItem(
                                                        bundleData[index]
                                                      );
                                                }),
                                              ),
                                            ),
                                          )

                                        ],
                                      ),


                                      // Best Rated
                                      Column(
                                        children: [

                                          HomeWidget.titleAndMore(appText.bestRated, onTapViewAll: (){
                                            locator<FilterCourseProvider>().clearFilter();
                                            locator<FilterCourseProvider>().sort = 'best_rates';
                                            nextRoute(FilterCategoryPage.pageName);
                                          }),

                                          SizedBox(
                                            width: getSize().width,
                                            child: SingleChildScrollView(
                                              physics: const BouncingScrollPhysics(),
                                              padding: padding(),
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: List.generate( isLoadingBestRatedListData ? 3 : bestRatedListData.length, (index) {
                                                  return isLoadingBestRatedListData
                                                    ? courseItemShimmer()
                                                    : courseItem(
                                                        bestRatedListData[index]
                                                      );
                                                }),
                                              ),
                                            ),
                                          )

                                        ],
                                      ),


                                      /* Image Slider

                                      // Image Slider
                                      Column(
                                        children: [
                                          // slider
                                          SizedBox(
                                            width: getSize().width,
                                            height: 200,
                                            child: PageView.builder(
                                              itemCount: 3,
                                              controller: adSliderPageController,
                                              onPageChanged: (value) {
                                                setState(() {
                                                  currentAdSliderIndex = value;
                                                });
                                              },
                                              physics: const BouncingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return HomeWidget.sliderItem('https://anthropologyandculture.com/wp-content/uploads/2021/03/61632315.jpg',(){

                                                });
                                              },
                                            ),
                                          ),

                                          space(16),

                                          // indecator
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              ...List.generate(3, (index) {
                                                return AnimatedContainer(
                                                  duration: const Duration(milliseconds: 300),
                                                  width: currentAdSliderIndex == index ? 16 : 7,
                                                  height: 7,
                                                  margin: padding(horizontal: 2),
                                                  decoration: BoxDecoration(
                                                    color: green77(),
                                                    borderRadius: borderRadius()
                                                  ),
                                                );

                                              }),
                                            ],
                                          ),

                                        ],
                                      ),
                                      */


                                      space(22),

                                      // by spending points
                                      Container(
                                        padding: padding(horizontal: 16),
                                        margin: padding(),
                                        width: getSize().width,
                                        height: 165,

                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: borderRadius(),
                                        ),

                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [

                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [

                                                Text(
                                                  appText.freeCourses,
                                                  style: style20Bold(),
                                                ),

                                                space(4),

                                                Text(
                                                  appText.bySpendingPoints,
                                                  style: style12Regular().copyWith(color: greyB2),
                                                ),

                                                space(8),

                                                button(
                                                  onTap: (){
                                                    locator<FilterCourseProvider>().clearFilter();
                                                    locator<FilterCourseProvider>().rewardCourse = true;
                                                    nextRoute(FilterCategoryPage.pageName);
                                                  },
                                                  width: 75,
                                                  height: 32,
                                                  text: appText.view,
                                                  bgColor: mainColor(),
                                                  textColor: Colors.white,
                                                  raduis: 10
                                                )

                                              ],
                                            ),



                                            SvgPicture.asset(AppAssets.pointsMedalSvg)


                                          ],
                                        ),
                                      ),

                                      space(10),


                                      // Best Selling
                                      Column(
                                        children: [
                                          HomeWidget.titleAndMore(appText.bestSelling, onTapViewAll: (){
                                            locator<FilterCourseProvider>().clearFilter();
                                            locator<FilterCourseProvider>().sort = 'bestsellers';
                                            nextRoute(FilterCategoryPage.pageName);
                                          }),

                                          SizedBox(
                                            width: getSize().width,
                                            child: SingleChildScrollView(
                                              physics: const BouncingScrollPhysics(),
                                              padding: padding(),
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: List.generate( isLoadingBestSellingListData ? 3 : bestSellingListData.length, (index) {
                                                  return isLoadingBestSellingListData
                                                    ? courseItemShimmer()
                                                    : courseItem(
                                                        bestSellingListData[index]
                                                      );
                                                }),
                                              ),
                                            ),
                                          )

                                        ],
                                      ),



                                      if(isLoadingDiscountListData || discountListData.isNotEmpty)...{

                                        // Discounted Classes
                                        Column(
                                          children: [
                                            HomeWidget.titleAndMore(appText.discountedClasses, onTapViewAll: (){
                                              locator<FilterCourseProvider>().clearFilter();
                                              locator<FilterCourseProvider>().discount = true;
                                              nextRoute(FilterCategoryPage.pageName);
                                            }),

                                            SizedBox(
                                              width: getSize().width,
                                              child: SingleChildScrollView(
                                                physics: const BouncingScrollPhysics(),
                                                padding: padding(),
                                                scrollDirection: Axis.horizontal,
                                                child: Row(
                                                  children: List.generate( isLoadingDiscountListData ? 3 : discountListData.length, (index) {
                                                    return isLoadingDiscountListData
                                                      ? courseItemShimmer()
                                                      : courseItem(
                                                          discountListData[index],
                                                        );
                                                  }),
                                                ),
                                              ),
                                            )

                                          ],
                                        ),
                                      },

                                      // Free Classes
                                      Column(
                                        children: [
                                          HomeWidget.titleAndMore(appText.freeClasses, onTapViewAll: (){
                                            locator<FilterCourseProvider>().clearFilter();
                                            locator<FilterCourseProvider>().free = true;
                                            nextRoute(FilterCategoryPage.pageName);
                                          }),

                                          SizedBox(
                                            width: getSize().width,
                                            child: SingleChildScrollView(
                                              physics: const BouncingScrollPhysics(),
                                              padding: padding(),
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: List.generate( isLoadingFreeListData ? 3 : freeListData.length, (index) {
                                                  return isLoadingFreeListData
                                                    ? courseItemShimmer()
                                                    : courseItem(
                                                        freeListData[index]
                                                      );
                                                }),
                                              ),
                                            ),
                                          )

                                        ],
                                      ),



                                      space(150),

                                    ],
                                  ),

                                )
                              ],
                            )
                          )

                        ],
                      ),
                      Positioned(
                        top: 20,
                        right: 5,
                        child: Row(
                          children: [

                            IconButton(
                              onPressed: () {
                                if (mounted) {
                                  drawerController.showDrawer();
                                }
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
                            SizedBox(width: 5),
                            IconButton(

                                icon: Icon(Icons.notifications,size: 40, color: Colors.white,),
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
              );
            }
          )
        );
      }
    );
  }


}