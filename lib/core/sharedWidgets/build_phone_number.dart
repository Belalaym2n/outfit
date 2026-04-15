// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//  import 'package:graduation_proj/generated/locale_keys.g.dart';
//  import '../utils/app_colors.dart';
// import '../utils/app_constants.dart';
//
// class ProfessionalPhoneInput extends StatefulWidget {
//   final TextEditingController controller;
//   final String? Function(String?)? validator;
//
//   const ProfessionalPhoneInput({
//     super.key,
//     required this.controller,
//     this.validator,
//   });
//
//   @override
//   State<ProfessionalPhoneInput> createState() => ProfessionalPhoneInputState();
// }
//
// class ProfessionalPhoneInputState extends State<ProfessionalPhoneInput> {
//   bool _isFocused = false;
//   String? _errorText;
//
//   static Country _selectedCountry = Country(
//     nameEn: 'Egypt',
//     nameAr: 'مصر',
//     dialCode: '+20',
//     code: 'EG',
//     flag: '🇪🇬',
//   );
//
//
//   String getFullPhoneNumber() {
//     return '${_selectedCountry.dialCode}${widget.controller.text.trim()}';
//   }
//
//   String getNormalizedPhoneNumber() {
//     String local = widget.controller.text.trim();
//
//     // Remove all spaces and dashes
//     local = local.replaceAll(' ', '').replaceAll('-', '').replaceAll('(', '').replaceAll(')', '');
//
//     // Remove leading zeros (common in many countries)
//     while (local.startsWith('0') && local.length > 1) {
//       local = local.substring(1);
//     }
//
//     return '${_selectedCountry.dialCode}$local';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Focus(
//           onFocusChange: (focus) {
//             setState(() => _isFocused = focus);
//           },
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOutCubic,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: _isFocused
//                     ? AppColors.primaryColor.withOpacity(0.8)
//                     : (_errorText != null
//                     ? Colors.redAccent
//                     : Colors.grey.shade300),
//                 width: 1.6,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: _isFocused
//                       ? AppColors.primaryColor.withOpacity(0.25)
//                       : Colors.black12,
//                   blurRadius: _isFocused ? 18 : 6,
//                   offset: Offset(0, _isFocused ? 6 : 3),
//                 ),
//               ],
//             ),
//             child: _build_text_form_field(),
//           ),
//         ),
//         _build_error()
//       ],
//     );
//   }
//
//   Widget _build_text_form_field() {
//     return TextFormField(
//       controller: widget.controller,
//       keyboardType: TextInputType.phone,
//       inputFormatters: [
//         FilteringTextInputFormatter.digitsOnly,
//         LengthLimitingTextInputFormatter(15),
//       ],
//       validator: (value) {
//         final result = widget.validator?.call(value);
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (mounted) {
//             setState(() => _errorText = result);
//           }
//         });
//         return result;
//       },
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       onChanged: (value) {
//         final result = widget.validator?.call(value);
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (mounted) {
//             setState(() => _errorText = result);
//           }
//         });
//       },
//       style: TextStyle(
//         color: AppColors.textPrimary,
//         fontWeight: FontWeight.w600,
//         fontSize: AppConstants.w * 0.04,
//       ),
//       decoration: InputDecoration(
//         errorText: null,
//         errorStyle: const TextStyle(fontSize: 0),
//         border: InputBorder.none,
//         labelText: LocaleKeys.register_enterYourPhone.tr(),
//         labelStyle: TextStyle(
//           color: _isFocused
//               ? AppColors.primaryColor
//               : AppColors.textSecondary,
//           fontWeight: FontWeight.w700,
//           fontSize: AppConstants.w * 0.035,
//         ),
//         hintText: '',
//         hintStyle: TextStyle(
//           color: Colors.grey[400],
//           fontSize: AppConstants.w * 0.035,
//         ),
//         prefixIcon: _buildCountrySelector(),
//         contentPadding: EdgeInsets.symmetric(
//           vertical: AppConstants.h * 0.02,
//           horizontal: AppConstants.w * 0.04,
//         ),
//       ),
//     );
//   }
//
//   Widget _build_error() {
//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 250),
//       switchInCurve: Curves.easeOutBack,
//       switchOutCurve: Curves.easeIn,
//       child: _errorText == null
//           ? SizedBox(height: AppConstants.h * 0.01)
//           : _buildErrorWidget(_errorText!),
//     );
//   }
//
//   Widget _buildCountrySelector() {
//     return GestureDetector(
//       onTap: _showCountryPicker,
//       child: Container(
//         margin: const EdgeInsets.only(left: 8, right: 4),
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         decoration: BoxDecoration(
//           color: _isFocused
//               ? AppColors.primaryColor.withOpacity(0.1)
//               : Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               _selectedCountry.flag,
//               style: const TextStyle(fontSize: 24),
//             ),
//             const SizedBox(width: 4),
//             Text(
//               _selectedCountry.dialCode,
//               style: TextStyle(
//                 color: _isFocused
//                     ? AppColors.primaryColor
//                     : AppColors.textPrimary,
//                 fontWeight: FontWeight.w700,
//                 fontSize: AppConstants.w * 0.035,
//               ),
//             ),
//             const SizedBox(width: 2),
//             Icon(
//               Icons.arrow_drop_down_rounded,
//               color: _isFocused ? AppColors.primaryColor : Colors.grey[600],
//               size: 20,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showCountryPicker() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => _CountryPickerSheet(
//         countries: StaticList.countries,
//         selectedCountry: _selectedCountry,
//         onCountrySelected: (country) {
//           setState(() {
//             _selectedCountry = country;
//           });
//         },
//       ),
//     );
//   }
//
//   Widget _buildErrorWidget(String error) {
//     return Padding(
//       padding: EdgeInsets.only(top: AppConstants.h * 0.008),
//       child: Container(
//         key: ValueKey(error),
//         padding: EdgeInsets.symmetric(
//           horizontal: AppConstants.w * 0.04,
//           vertical: AppConstants.h * 0.008,
//         ),
//         decoration: BoxDecoration(
//           color: Colors.redAccent.withOpacity(0.12),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.redAccent, width: 1),
//         ),
//         child: Text(
//           error,
//           style: TextStyle(
//             color: Colors.redAccent,
//             fontWeight: FontWeight.w600,
//             fontSize: AppConstants.w * 0.032,
//           ),
//         ),
//       ),
//     );
//   }
//
// }
//
// class _CountryPickerSheet extends StatefulWidget {
//   final List<Country> countries;
//   final Country selectedCountry;
//   final Function(Country) onCountrySelected;
//
//   const _CountryPickerSheet({
//     required this.countries,
//     required this.selectedCountry,
//     required this.onCountrySelected,
//   });
//
//   @override
//   State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
// }
//
// class _CountryPickerSheetState extends State<_CountryPickerSheet> {
//   late List<Country> _filteredCountries;
//   final TextEditingController _searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _filteredCountries = widget.countries;
//   }
//
//   void _filterCountries(String query) {
//     setState(() {
//       _filteredCountries = widget.countries
//           .where((country) =>
//       country.nameAr.toLowerCase().contains(query.toLowerCase()) ||
//           country.dialCode.contains(query))
//           .toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.75,
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: AppColors.primaryColor.withOpacity(0.05),
//               borderRadius:
//               const BorderRadius.vertical(top: Radius.circular(24)),
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                 LocaleKeys.Login_selectCountry.tr(),
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 TextField(
//                   controller: _searchController,
//                   onChanged: _filterCountries,
//                   decoration: InputDecoration(
//                     hintText: LocaleKeys.Login_searchCountry.tr(),
//                     prefixIcon: const Icon(Icons.search),
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(vertical: 12),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               itemCount: _filteredCountries.length,
//               itemBuilder: (context, index) {
//                 final country = _filteredCountries[index];
//                 final isSelected = country.code == widget.selectedCountry.code;
//
//                 return ListTile(
//                   leading: Text(
//                     country.flag,
//                     style: const TextStyle(fontSize: 28),
//                   ),
//                   title: Text(
//                     context.locale.toString()=='ar'?
//
//                     country.nameAr:country.nameEn,
//                     style: TextStyle(
//                       fontWeight:
//                       isSelected ? FontWeight.bold : FontWeight.w500,
//                       color: isSelected
//                           ? AppColors.primaryColor
//                           : AppColors.textPrimary,
//                     ),
//                   ),
//                   trailing: Text(
//                     country.dialCode,
//                     style: TextStyle(
//                       color: isSelected
//                           ? AppColors.primaryColor
//                           : Colors.grey[600],
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   selected: isSelected,
//                   selectedTileColor: AppColors.primaryColor.withOpacity(0.1),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   onTap: () {
//                     widget.onCountrySelected(country);
//                     Navigator.pop(context);
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
// }