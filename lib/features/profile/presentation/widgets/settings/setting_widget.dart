
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_proj/core/sharedWidgets/animations/bg_animation.dart';
import 'package:graduation_proj/core/utils/app_constants.dart';

import '../../../../../config/routes/app_router.dart' as Go;
import '../../../../../core/cahsing/get_storage_helper.dart';
import '../../../../../core/cahsing/secure_storage.dart';
import '../../../../../core/sharedWidgets/text_styles.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../data/models/setting_model.dart';

 



class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.hPad,
    required this.onTap,
    required this.btnScale,
  });

  final double                       hPad;
  final Function(VoidCallback?)      onTap;
  final Animation<double>            btnScale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Container(
        decoration: BoxDecoration(
          color:AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color:AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14, spreadRadius: -3,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: List.generate( settingItems.length, (i) {
            final item =settingItems[i];
            final isLast = i ==settingItems.length - 1;

            return _SettingTile(
              item:    item,
              isLast:  isLast,
              onTap:    item.isLogout?
              () async {
                print("object");
               await GetStorageHelper.clear();
               await SecureStorageHelper.clear();
                context.go(Go.AppRoutes.login);
              }:
                  () => onTap(null),
            );
          }),
        ),
      ),
    );
  }
}

class _SettingTile extends StatefulWidget {
  const _SettingTile({
    required this.item,
    required this.isLast,
    required this.onTap,
  });
  final SettingItem item;
  final bool         isLast;
  final VoidCallback onTap;

  @override
  State<_SettingTile> createState() => _SettingTileState();
}

class _SettingTileState extends State<_SettingTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isLogout = widget.item.isLogout;

    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp:   (_) {
            setState(() => _pressed = false);
            widget.onTap();
          },
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 130),
            curve: Curves.easeOut,
            color: _pressed ?AppColors.surfaceAlt : Colors.transparent,
            padding: EdgeInsets.symmetric(
              horizontal: Sp.sm, vertical: 15,
            ),
            child: Row(
              children: [

                // Icon 
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: isLogout
                        ?AppColors.textWarn.withOpacity(0.08)
                        :AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    widget.item.icon,
                    size: 17,
                    color: isLogout ?AppColors.textWarn :AppColors.textMid,
                  ),
                ),

                const SizedBox(width: 14),

                // Title 
                Expanded(
                  child: Text(
                    widget.item.title,
                    style: T.cardTitle.copyWith(
                      color: isLogout ?AppColors.textWarn :AppColors.textHigh,
                    ),
                  ),
                ),

                // Trailing widget or chevron 
                if (widget.item.trailing != null)
                  widget.item.trailing!
                else if (!isLogout)
                  const Icon(
                    Icons.chevron_right_rounded,
                    color:AppColors.textLow, size: 20,
                  ),
              ],
            ),
          ),
        ),

        // Hairline divider (not on last item) 
        if (!widget.isLast)
          Padding(
            padding: const EdgeInsets.only(left: 66),
            child: Container(height: 1, color:AppColors.divider),
          ),
      ],
    );
  }
}


// ───────────────────────────────────────────────────────────── 
//  TOGGLE CHIP  (notifications toggle — design state only) 
// ───────────────────────────────────────────────────────────── 
class  ToggleChip extends StatefulWidget {
  const ToggleChip({required this.active});
  final bool active;

  @override
  State<ToggleChip> createState() => _ToggleChipState();
}

class _ToggleChipState extends State<ToggleChip> {
  late bool _on;

  @override
  void initState() {
    super.initState();
    _on = widget.active;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _on = !_on);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        width: 44, height: 26,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: _on ?AppColors.ink :AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: _on ?AppColors.ink :AppColors.divider),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          alignment: _on ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20, height: 20,
            decoration: const BoxDecoration(
              color: Colors.white, shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
