import 'dart:typed_data';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:salonmate_your_salon_240_a/asd/moti_ev.dart';
import '../asd/color_ev.dart';
import '../asd/mast_tol_prd.dart';

class AddEditRevicMasterModal extends StatefulWidget {
  final MastteModl mastte;
  final MmaasstteRevie? existingRevic;

  const AddEditRevicMasterModal({
    Key? key,
    required this.mastte,
    this.existingRevic,
  }) : super(key: key);

  @override
  State<AddEditRevicMasterModal> createState() =>
      _AddEditRevicMasterModalState();
}

class _AddEditRevicMasterModalState extends State<AddEditRevicMasterModal> {
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  DateTime? _selectedDate;
  List<Uint8List> _selectedPhotos = [];

  @override
  void initState() {
    super.initState();
    if (widget.existingRevic != null) {
      _reviewController.text = widget.existingRevic!.maasstteRevieDesc;
      _clientNameController.text =
          widget.existingRevic!.maasstteRevieClientName;
      _selectedDate = widget.existingRevic!.maasstteRevieDate;
      _selectedPhotos = List.from(widget.existingRevic!.maasstteReviePhotos);
    }
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty && _selectedPhotos.length + images.length <= 5) {
      for (var image in images) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedPhotos.add(bytes);
        });
      }
    } else if (_selectedPhotos.length + images.length > 5) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maximum 5 photos allowed')),
      );
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _selectedPhotos.removeAt(index);
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveRevic() {
    if (_reviewController.text.isEmpty ||
        _selectedDate == null ||
        _selectedPhotos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    final provider = Provider.of<MasttePrvdr>(context, listen: false);
    final review = MmaasstteRevie(
      maasstteRevieId: widget.existingRevic?.maasstteRevieId ??
          DateTime.now().millisecondsSinceEpoch,
      maasstteReviePhotos: _selectedPhotos,
      maasstteRevieDate: _selectedDate!,
      maasstteRevieDesc: _reviewController.text,
      maasstteRevieClientName: _clientNameController.text,
    );

    provider.addUpdateMmaasstteRevie(widget.mastte.maasstteId, review);
    Navigator.of(context).pop();
  }

  Future<void> _showDeleteConfirmation() async {
    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Delete Review'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
          ),
        ],
      ),
    );
    if (result == true) {
      final provider = Provider.of<MasttePrvdr>(context, listen: false);
      provider.deleteMmaasstteRevie(
          widget.mastte.maasstteId, widget.existingRevic!.maasstteRevieId);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: StatefulBuilder(builder: (context, setState) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.existingRevic != null
                              ? 'Edit Work & Review'
                              : 'Add Work & Review',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w300,
                            color: ColorEv.lightBlack,
                          ),
                        ),
                        const Spacer(),
                        if (widget.existingRevic != null)
                          IconButton(
                            icon: Icon(Icons.delete,
                                color: Colors.red, size: 24.r),
                            onPressed: _showDeleteConfirmation,
                          ),
                        IconButton(
                          icon: Icon(Icons.close, size: 24.r),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      height: 150.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: _selectedPhotos.isEmpty
                          ? EvMotiBut(
                              onPressed: _pickImages,
                              child: Container(
                                height: 150.h,
                                width: 150.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 40.r,
                                      color: ColorEv.blue,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Add Photos',
                                      style: TextStyle(
                                        color: ColorEv.blue,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    Text(
                                      'Up to 5',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.all(8.r),
                              child: Row(
                                children: [
                                  ...List.generate(
                                    _selectedPhotos.length,
                                    (index) => EvMotiBut(
                                      onPressed: () {
                                        showImageViewer(
                                          context,
                                          MemoryImage(_selectedPhotos[index]),
                                          useSafeArea: true,
                                          swipeDismissible: true,
                                          doubleTapZoomable: true,
                                        );
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 8.w),
                                            width: 120.w,
                                            height: 120.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              image: DecorationImage(
                                                image: MemoryImage(
                                                    _selectedPhotos[index]),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0.r,
                                            right: 0.r,
                                            child: GestureDetector(
                                              onTap: () => _removePhoto(index),
                                              child: Image.asset(
                                                  'assets/images/del.png'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (_selectedPhotos.length < 5)
                                    GestureDetector(
                                      onTap: _pickImages,
                                      child: Container(
                                        width: 120.w,
                                        height: 120.h,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        child: Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 30.r,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                    ),
                    SizedBox(height: 12.h),
                    GestureDetector(
                      onTap: _selectDate,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDate != null
                                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                  : 'Select Date',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: _selectedDate != null
                                    ? ColorEv.lightBlack
                                    : Colors.grey,
                              ),
                            ),
                            Icon(Icons.calendar_today,
                                color: ColorEv.blue, size: 20.r),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _reviewController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Review',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          contentPadding: EdgeInsets.all(16.r),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _clientNameController,
                        decoration: InputDecoration(
                          hintText: 'Client Name (optional)',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          contentPadding: EdgeInsets.all(16.r),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    GestureDetector(
                      onTap: _saveRevic,
                      child: Container(
                        height: 56.h,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3CC5EE), Color(0xFF5166FD)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Center(
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _clientNameController.dispose();
    super.dispose();
  }
}
