import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:webinar/app/contact_utiles/contact_utiles.dart';
import 'package:webinar/app/models/purchase_course_model.dart';
import 'package:webinar/app/pages/authentication_page/login_page.dart';
import 'package:webinar/app/pages/main_page/classes_page/course_overview_page.dart';
import 'package:webinar/app/providers/drawer_provider.dart';
import 'package:webinar/app/providers/user_provider.dart';
import 'package:webinar/app/services/user_service/user_service.dart';
import 'package:webinar/app/widgets/main_widget/classes_widget/classes_widget.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/common/data/app_data.dart';
import 'package:webinar/common/shimmer_component.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/common/utils/object_instance.dart';
import 'package:webinar/config/assets.dart';
import 'package:webinar/config/colors.dart';
import 'package:webinar/locator.dart';

import '../../../models/course_model.dart';
import '../../../providers/app_language_provider.dart';
import '../home_page/notification_page.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({super.key});

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> with TickerProviderStateMixin{

  late TabController tabController;

  bool isLoading = false;

  List<CourseModel> myClasses = [];
  List<PurchaseCourseModel> purchases = [];
  List<CourseModel> organizations = [];
  List<CourseModel> invitations = [];

  bool hasLogin = false;

  @override
  void initState() {
    super.initState();

    AppData.getAccessToken().then((value) {
      hasLogin = value.isNotEmpty;
      setState(() {});
    });
    
    tabController = TabController(
      length: locator<UserProvider>().profile?.roleName == 'user' 
        ? locator<UserProvider>().profile?.organId == null ? 1 : 2 
        : locator<UserProvider>().profile?.organId == null ? 3 : 4, 
      vsync: this
    );
    getData();
  }


  getData() async {

    setState(() {
      isLoading = true;
    });

    if(locator<UserProvider>().profile?.roleName != 'user'){
      var data = await UserService.getTeacherClassess();

      myClasses = data.$1;
      purchases = data.$2;
      organizations = data.$3;
      invitations = data.$4;
    }else{

      purchases = await UserService.getPurchaseCourse();
      organizations = await UserService.getOrganizationCourse();
    }

    setState(() {
      isLoading = false;
    });

  }


  @override
  Widget build(BuildContext context) {

    return Consumer<AppLanguageProvider>(
      builder: (context, provider, _) {
        
        return directionality(
          child: Consumer<DrawerProvider>(
            builder: (context, drawerProvider, _) {

              return Scaffold(
                body: !hasLogin
              ? Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
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
                        emptyState(AppAssets.loginEmptyStateSvg, appText.login, appText.loginDesc, isBottomPadding: false),

                       space(16,width: getSize().width),

                        button(
                          onTap: (){
                            nextRoute(LoginPage.pageName, isClearBackRoutes: true);
                          },
                          width: getSize().width * .65,
                          height: 52,
                          text: appText.login,
                          bgColor: mainColor(),
                          textColor: Colors.white,
                          raduis: 16
                        ),

                        space(getSize().height * .15),
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
              )
              : NestedScrollView(
                  physics: const BouncingScrollPhysics(),
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        pinned: true,
                        centerTitle: true,
                        automaticallyImplyLeading: false,
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        shadowColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(.2),
                        elevation: 10,
                        titleSpacing: 0,

                        title: tabBar((i){}, tabController, [

                          Tab(
                            text: appText.purchased,
                            height: 32,
                          ),

                          if(locator<UserProvider>().profile?.roleName != 'user')...{
                            Tab(
                              text: appText.myClassess,
                              height: 32,
                            ),
                          },

                          if(locator<UserProvider>().profile?.organId != null)...{

                            Tab(
                              text: appText.organization,
                              height: 32,
                            ),
                          },

                          if(locator<UserProvider>().profile?.roleName != 'user')...{
                            Tab(
                              text: appText.invited,
                              height: 32,
                            ),
                          },

                        ]),
                      )
                    ];
                  },
                  body: TabBarView(
                    physics: const BouncingScrollPhysics(),
                    controller: tabController,

                    children: [

                      // purchased
                      !isLoading && purchases.isEmpty
                    ? Center(child: emptyState(AppAssets.noCourseEmptyStateSvg, appText.noCourses, appText.noCourseClassesDesc),)
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: padding(),

                        child: Column(
                          children: [

                            ...List.generate( isLoading ? 3 : purchases.length, (index) {

                              return isLoading
                            ? classesCourseItemShimmer()
                            : ClassessWidget.classesItem(
                                purchases[index].webinar == null
                                  ? purchases[index].bundle ?? CourseModel()
                                  : purchases[index].webinar ?? CourseModel(),

                                expired: purchases[index].expired ?? false,
                                expiredDate: (purchases[index].expiredAt ?? 0)
                              );
                            }),

                            space(110),

                          ],
                        ),
                      ),


                      // myClasses
                      if(locator<UserProvider>().profile?.roleName != 'user')...{
                        !isLoading && myClasses.isEmpty
                      ? Center(child: emptyState(AppAssets.noCourseEmptyStateSvg, appText.noCourses, appText.noCourseClassesDesc),)
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: padding(),

                          child: Column(
                            children: [

                              ...List.generate(isLoading ? 3 : myClasses.length, (index) {
                                return isLoading
                              ? classesCourseItemShimmer()
                              : ClassessWidget.classesItem(myClasses[index], onTap: (){
                                  nextRoute(
                                    CourseOverviewPage.pageName,
                                    arguments: [
                                      myClasses[index].id,
                                      myClasses[index].type == 'bundle',
                                      myClasses[index].isPrivate == 1
                                    ]
                                  );
                                });
                              }),

                              space(110),

                            ],
                          ),
                        ),
                      },


                      if(locator<UserProvider>().profile?.organId != null)...{
                      // organizations
                      !isLoading && organizations.isEmpty
                    ? Center(child: emptyState(AppAssets.noCourseEmptyStateSvg, appText.noCourses, appText.noCourseClassesDesc),)
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: padding(),

                        child: Column(
                          children: [

                            ...List.generate(isLoading ? 3 : organizations.length, (index) {
                              return isLoading
                                ? classesCourseItemShimmer()
                                : ClassessWidget.classesItem(organizations[index], onTap: (){
                                    nextRoute(
                                      CourseOverviewPage.pageName,
                                      arguments: [
                                        organizations[index].id,
                                        organizations[index].type == 'bundle',
                                        organizations[index].isPrivate == 1
                                      ]
                                    );

                                  });
                            }),

                            space(110),

                          ],
                        ),
                      ),

                      },

                      if(locator<UserProvider>().profile?.roleName != 'user')...{

                        // invitations
                        !isLoading && invitations.isEmpty
                      ? Center(child: emptyState(AppAssets.noCourseEmptyStateSvg, appText.noCourses, appText.noCourseClassesDesc),)
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: padding(),

                          child: Column(
                            children: [

                              ...List.generate(isLoading ? 3 : invitations.length, (index) {
                                return isLoading
                                ? classesCourseItemShimmer()
                                : ClassessWidget.classesItem(invitations[index]);
                              }),

                              space(110),

                            ],
                          ),
                        ),
                      },

                    ]
                  )

                ),

              );
            }
          )
        );
      }
    );
  }
}