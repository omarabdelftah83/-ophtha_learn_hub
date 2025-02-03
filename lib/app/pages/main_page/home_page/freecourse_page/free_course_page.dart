

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/common.dart';
import '../../../../../common/components.dart';
import '../../../../../common/shimmer_component.dart';
import '../../../../../common/utils/app_text.dart';
import '../../../../../common/utils/object_instance.dart';
import '../../../../../config/assets.dart';
import '../../../../../locator.dart';
import '../../../../models/course_model.dart';
import '../../../../providers/app_language_provider.dart';
import '../../../../providers/providers_provider.dart';
import '../../../../services/guest_service/course_service.dart';
import '../../providers_page/providers_filter.dart';

class FreeCoursePage extends StatefulWidget {

  const FreeCoursePage({super.key});

  @override
  State<FreeCoursePage> createState() => _FreeCoursePageState();
}

class _FreeCoursePageState extends State<FreeCoursePage> with SingleTickerProviderStateMixin{

  bool isLoadingFreeListData=false;
  List<CourseModel> freeListData = [];


  bool isLoading = true;

  @override
  void initState() {
    super.initState();


    locator<ProvidersProvider>().clearFilter();

    CourseService.getAll(offset: 0, free: true).then((value) {
      setState(() {
        isLoadingFreeListData = false;
        freeListData = value;
      });
    });

  }


  @override
  Widget build(BuildContext context) {
    return Consumer<AppLanguageProvider>(
        builder: (context,appLanguageProvider,_) {
          return directionality(
            child: Scaffold(
              appBar: appbar(
                  title: appText.freeCourse,
                  rightIcon: AppAssets.filterSvg,
                  leftIcon: AppAssets.menuSvg,
                  onTapLeftIcon: (){
                    drawerController.showDrawer();
                  },
                  onTapRightIcon: () async {
                    bool? res = await baseBottomSheet(child: const ProvidersFilter());
                  },
                  rightWidth: 22
              ),

              body: NestedScrollView(
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

                      )
                    ];
                  },
                  body: Column(
                    children: [
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
                  )
              ),
            ),
          );
        }
    );
  }


  Widget instructorsPage(){
    return Column(
      children: [

      ],
    );
  }
}