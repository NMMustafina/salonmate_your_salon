import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../asd/color_ev.dart';
import '../asd/mast_tol_prd.dart';
import '../asd/moti_ev.dart';
import 'add_edit_master_modal.dart';
import 'add_edit_revic_master_modal.dart';

class MasstePageDetail extends StatefulWidget {
  final MastteModl mastte;

  const MasstePageDetail({
    super.key,
    required this.mastte,
  });

  @override
  State<MasstePageDetail> createState() => _MasstePageDetailState();
}

class _MasstePageDetailState extends State<MasstePageDetail> {
  @override
  Widget build(BuildContext context) {
    final prov = context.watch<MasttePrvdr>();
    final mastte = prov.mastteList.firstWhereOrNull(
        (element) => element.maasstteId == widget.mastte.maasstteId);
    if (mastte == null) {
      return Scaffold(backgroundColor: Colors.white, appBar: AppBar());
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: EvMotiBut(
          onPressed: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.only(left: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          ),
        ),
        title: Text(
          'Master Profile',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w300,
            color: ColorEv.lightBlack,
          ),
        ),
        centerTitle: true,
        actions: [
          EvMotiBut(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                builder: (context) =>
                    AddEditMasterModal(existingMaster: mastte),
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 8.w),
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.edit, size: 20.r, color: ColorEv.lightBlack),
            ),
          ),
          EvMotiBut(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                builder: (context) => AddEditRevicMasterModal(mastte: mastte),
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 16.w),
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.add, size: 20.r, color: ColorEv.lightBlack),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 92.h,
                      width: 92.h,
                      decoration: BoxDecoration(
                        color: ColorEv.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: mastte.maassttePhoto != null
                          ? ClipOval(
                              child: Image.memory(
                                mastte.maassttePhoto!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.person,
                              color: ColorEv.black.withOpacity(0.3),
                            ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mastte.maasstteName,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w300,
                              color: ColorEv.lightBlack,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            mastte.maasstteSpecial,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorEv.blue,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            mastte.maasstteExperi,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w300,
                              color: ColorEv.lightBlack.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  mastte.maasstteDesc,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w300,
                    color: ColorEv.lightBlack,
                  ),
                ),
                SizedBox(height: 24.h),
                if (mastte.mmaasstteRevieList.isNotEmpty)
                  Text(
                    'Client Reviews:',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorEv.lightBlack,
                    ),
                  ),
                SizedBox(height: 8.h),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.h,
                  ),
                  itemCount: mastte.mmaasstteRevieList.length,
                  itemBuilder: (context, index) {
                    final review = mastte.mmaasstteRevieList[index];
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.9,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.r),
                              topRight: Radius.circular(20.r),
                            ),
                          ),
                          builder: (context) => AddEditRevicMasterModal(
                            existingRevic: review,
                            mastte: mastte,
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                MemoryImage(review.maasstteReviePhotos.first),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
