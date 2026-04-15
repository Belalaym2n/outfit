
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/sharedWidgets/text_styles.dart';

class  CustomTextField extends StatefulWidget {
    CustomTextField({
    required this.label,
    required this.hint,
    this.validator,
      this.controller,
    this.isPassword  = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
  });

  final String          label;
  final String          hint;
    final String? Function(String?)? validator;
  final bool            isPassword;
  final TextInputType   keyboardType;
  TextEditingController ? controller;
  final TextInputAction textInputAction;

  @override
  State<CustomTextField> createState() => _AuthTextFieldState();
}
class _AuthTextFieldState extends State<CustomTextField> {
  final FocusNode _focus = FocusNode();
  bool _focused   = false;
  bool _obscure   = true;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() => _focused = _focus.hasFocus));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Floating label above field
        AnimatedDefaultTextStyle(
          duration:   Duration(milliseconds: 200),
          style: T.fieldLabel.copyWith(
            color: _focused ? AppColors.textHigh : AppColors.textMid,
            fontWeight: _focused ? FontWeight.w600 : FontWeight.w500,
          ),
          child: Text(widget.label),
        ),
        const SizedBox(height: 8),

        // Field container — animates border + shadow on focus
        AnimatedContainer(
          duration:   Duration(milliseconds: 220),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: _focused ? AppColors.dividerFoc : AppColors.divider,
              width: _focused ? 1.5 : 1.0,
            ),
            boxShadow: _focused
                ? [
              BoxShadow(
                color: AppColors.ink.withOpacity(0.08),
                blurRadius: 18,
                spreadRadius: -3,
                offset: const Offset(0, 5),
              ),
            ]
                : [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                spreadRadius: -2,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextFormField(
            controller:widget. controller??TextEditingController(),
            validator: widget.validator ?? (String? value) => null,
            focusNode:       _focus,
            obscureText:     widget.isPassword && _obscure,
            keyboardType:    widget.keyboardType,
            textInputAction: widget.textInputAction,
            style:           T.fieldText,
            cursorColor:     AppColors.ink,
            cursorWidth:     1.5,
            decoration: InputDecoration(
              hintText:         widget.hint,
              hintStyle:        T.fieldText.copyWith(color: AppColors.textLow),
              contentPadding:   const EdgeInsets.symmetric(
                horizontal: 16, vertical: 16,
              ),
              border:           InputBorder.none,
              suffixIcon: widget.isPassword
                  ? GestureDetector(
                onTap: () => setState(() => _obscure = !_obscure),
                child: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textLow,
                  size: 18,
                ),
              )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  //BELAL@gmail.com Aa123456@
}
