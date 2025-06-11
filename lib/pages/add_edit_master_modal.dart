import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../asd/mast_tol_prd.dart';
import '../asd/color_ev.dart';
import 'package:image_picker/image_picker.dart';

class AddEditMasterModal extends StatefulWidget {
  final MastteModl? existingMaster;

  const AddEditMasterModal({Key? key, this.existingMaster}) : super(key: key);

  @override
  State<AddEditMasterModal> createState() => _AddEditMasterModalState();
}

class _AddEditMasterModalState extends State<AddEditMasterModal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Uint8List? _selectedImage;
  bool _isEditing = false;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingMaster != null) {
      _isEditing = true;
      _nameController.text = widget.existingMaster!.maasstteName;
      _specializationController.text = widget.existingMaster!.maasstteSpecial;
      _experienceController.text = widget.existingMaster!.maasstteExperi;
      _descriptionController.text = widget.existingMaster!.maasstteDesc;
      _selectedImage = widget.existingMaster!.maassttePhoto;
    }

    // Add listeners to track changes
    _nameController.addListener(_onFieldChanged);
    _specializationController.addListener(_onFieldChanged);
    _experienceController.addListener(_onFieldChanged);
    _descriptionController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    setState(() {
      _hasUnsavedChanges = true;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _selectedImage = bytes;
        _hasUnsavedChanges = true;
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          'Careful! Unsaved Info',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: ColorEv.lightBlack,
          ),
        ),
        content: Text(
          'We noticed you didn\'t save your changes. Close without saving?',
          style: TextStyle(
            fontSize: 14.sp,
            color: ColorEv.lightBlack.withOpacity(0.8),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Stay',
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorEv.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Close',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void _saveMaster() {
    if (_nameController.text.isEmpty ||
        _specializationController.text.isEmpty ||
        _experienceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in all required fields',
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
      );
      return;
    }

    final provider = Provider.of<MasttePrvdr>(context, listen: false);
    final master = MastteModl(
      maasstteId: widget.existingMaster?.maasstteId ??
          DateTime.now().millisecondsSinceEpoch,
      maassttePhoto: _selectedImage,
      maasstteName: _nameController.text,
      maasstteSpecial: _specializationController.text,
      maasstteExperi: _experienceController.text,
      maasstteDesc: _descriptionController.text,
      mmaasstteRevieList: widget.existingMaster?.mmaasstteRevieList ?? [],
    );

    provider.addUpdateMastte(master);
    Navigator.of(context).pop();
  }

  Future<void> _showDeleteConfirmation() async {
    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          'Delete Forever?',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: ColorEv.lightBlack,
          ),
        ),
        content: Text(
          'This item will be gone for good.\nDo you want to continue?',
          style: TextStyle(
            fontSize: 14.sp,
            color: ColorEv.lightBlack.withOpacity(0.8),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorEv.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Delete',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );

    if (result == true && widget.existingMaster != null) {
      if (!mounted) return;
      final provider = Provider.of<MasttePrvdr>(context, listen: false);
      provider.deleteMastte(widget.existingMaster!.maasstteId);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            forceMaterialTransparency: true,
            centerTitle: false,
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              _isEditing ? 'Edit Artist' : 'Add Artist',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w300,
                color: ColorEv.lightBlack,
              ),
            ),
            automaticallyImplyLeading: false,
            actions: [
              if (_isEditing)
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: 24.r),
                  onPressed: _showDeleteConfirmation,
                ),
              IconButton(
                icon: Icon(Icons.close, size: 24.r),
                onPressed: () => _onWillPop().then((canPop) {
                  if (canPop) Navigator.of(context).pop();
                }),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 150.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child: Image.memory(_selectedImage!,
                                    fit: BoxFit.cover),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.photo_outlined,
                                    size: 32.r,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Add Photo',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Name field
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
                      controller: _nameController,
                      style:
                          TextStyle(fontSize: 16.sp, color: ColorEv.lightBlack),
                      decoration: InputDecoration(
                        hintText: 'Name',
                        hintStyle: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[400],
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 12.h),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

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
                      controller: _specializationController,
                      style:
                          TextStyle(fontSize: 16.sp, color: ColorEv.lightBlack),
                      decoration: InputDecoration(
                        hintText: 'Specialization',
                        hintStyle: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[400],
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 12.h),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Experience field
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
                      controller: _experienceController,
                      style:
                          TextStyle(fontSize: 16.sp, color: ColorEv.lightBlack),
                      decoration: InputDecoration(
                        hintText: 'Experience',
                        hintStyle: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[400],
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 12.h),
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Description field
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
                      controller: _descriptionController,
                      style:
                          TextStyle(fontSize: 16.sp, color: ColorEv.lightBlack),
                      decoration: InputDecoration(
                        hintText: 'Description (optional)',
                        hintStyle: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[400],
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 12.h),
                        border: InputBorder.none,
                      ),
                      minLines: 3,
                      maxLines: 5,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  GestureDetector(
                    onTap: _saveMaster,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
