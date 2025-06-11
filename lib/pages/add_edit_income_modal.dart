import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../asd/color_ev.dart';
import '../asd/moti_ev.dart';
import '../model/income_entry.dart';
import '../provider/income_provider.dart';
import '../widget/remind_field.dart';
import 'master_picker_modal.dart';

class AddEditIncomeModal extends StatefulWidget {
  final DateTime selectedDate;
  final IncomeEntry? existing;

  const AddEditIncomeModal({
    super.key,
    required this.selectedDate,
    this.existing,
  });

  @override
  State<AddEditIncomeModal> createState() => _AddEditIncomeModalState();
}

class _AddEditIncomeModalState extends State<AddEditIncomeModal> {
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _masterController = TextEditingController();

  String? _selectedMaster;
  bool _hasChanges = false;

  late final String _initialService;
  late final String _initialAmount;
  late final String _initialMaster;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      _selectedMaster = widget.existing!.masterName;
      _serviceController.text = widget.existing!.service;
      _amountController.text = widget.existing!.amount.toStringAsFixed(2);
      _masterController.text = widget.existing!.masterName;

      _initialService = widget.existing!.service;
      _initialAmount = widget.existing!.amount.toStringAsFixed(2);
      _initialMaster = widget.existing!.masterName;
    } else {
      _initialService = '';
      _initialAmount = '';
      _initialMaster = '';
    }

    _serviceController.addListener(_trackChanges);
    _amountController.addListener(_trackChanges);
  }

  void _trackChanges() {
    if (widget.existing == null) {
      setState(() => _hasChanges = true);
      return;
    }

    final changed = _serviceController.text != _initialService ||
        _amountController.text != _initialAmount ||
        _selectedMaster != _initialMaster;
    if (_hasChanges != changed) {
      setState(() => _hasChanges = changed);
    }
  }

  @override
  void dispose() {
    _serviceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isValid = _selectedMaster != null &&
        _serviceController.text.isNotEmpty &&
        _amountController.text.isNotEmpty &&
        double.tryParse(_amountController.text) != null &&
        (widget.existing == null || _hasChanges);

    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: mediaQuery.size.height * 0.8,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                top: 16.h,
                bottom: bottomInset + 24.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.w,
                    height: 4.h,
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3D3D3D).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        widget.existing != null ? 'Edit Income' : 'Add Income',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w300,
                          color: ColorEv.lightBlack,
                        ),
                      ),
                      const Spacer(),
                      if (widget.existing != null)
                        EvMotiBut(
                          onPressed: _confirmDelete,
                          child: Container(
                            height: 40.h,
                            width: 40.h,
                            margin: EdgeInsets.only(right: 8.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10.r,
                                  offset: Offset(0, 2.r),
                                ),
                              ],
                            ),
                            child: Icon(
                              CupertinoIcons.delete,
                              size: 20.r,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      EvMotiBut(
                        onPressed: _confirmClose,
                        child: Container(
                          height: 40.h,
                          width: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10.r,
                                offset: Offset(0, 2.r),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.close,
                            size: 20.r,
                            color: const Color(0xFF5A5454),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  RemindField(
                    controller: _masterController,
                    placeholder: 'Select Master',
                    onTap: _openMasterPicker,
                    suffix:
                        const Icon(Icons.chevron_right, color: ColorEv.blue),
                  ),
                  SizedBox(height: 12.h),
                  RemindField(
                    controller: _serviceController,
                    placeholder: 'Service Type',
                    useGradient: false,
                  ),
                  SizedBox(height: 12.h),
                  RemindField(
                    controller: _amountController,
                    placeholder: 'Amount Earned',
                    useGradient: false,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    suffix: SvgPicture.asset(
                      'assets/icons/dollar.svg',
                      width: 20.w,
                      height: 20.w,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  EvMotiBut(
                    onPressed: isValid
                        ? () {
                            final newEntry = IncomeEntry(
                              id: widget.existing?.id ??
                                  DateTime.now().millisecondsSinceEpoch,
                              masterName: _selectedMaster!,
                              service: _serviceController.text,
                              amount: double.parse(_amountController.text),
                              date: widget.selectedDate,
                            );
                            context
                                .read<IncomeProvider>()
                                .addOrUpdate(newEntry);
                            Navigator.pop(context);
                          }
                        : null,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        gradient: isValid
                            ? const LinearGradient(
                                colors: [Color(0xFF3CC5EE), Color(0xFF5166FD)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              )
                            : LinearGradient(
                                colors: [
                                  const Color(0xFF3CC5EE).withOpacity(0.3),
                                  const Color(0xFF5166FD).withOpacity(0.3),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Center(
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: isValid ? Colors.white : Colors.white54,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
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

  void _confirmClose() {
    if (!_hasChanges) {
      Navigator.pop(context);
      return;
    }
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Careful! Unsaved Info'),
        content: const Text(
            'We noticed you didn’t save your changes. Close without saving?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Stay'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Close'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _confirmDelete() {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Delete Forever?'),
        content: const Text(
            'This item will be gone for good.\nDo you want to continue?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Delete'),
            onPressed: () {
              final provider = context.read<IncomeProvider>();
              provider.delete(widget.existing!.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _openMasterPicker() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: MasterPickerModal(
          onSelected: (name) {
            setState(() {
              _selectedMaster = name;
              _masterController.text = name;
              _trackChanges();
            });
          },
        ),
      ),
    );
  }
}
