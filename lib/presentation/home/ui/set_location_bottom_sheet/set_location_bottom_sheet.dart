import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/common/widgets/custom_divider.dart';
import 'package:salat_waqt/presentation/home/presenter/bottom_sheet_presenter.dart';

class SetLocationBottomSheet extends StatelessWidget {
  const SetLocationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomSheetPresenter presenter = loadPresenter(
      BottomSheetPresenter(),
    );
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.93, 1.20),
            radius: 0.72,
            colors: [
              context.color.cardGradientStart,
              context.color.cardGradientEnd,
            ],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.px),
            topRight: Radius.circular(16.px),
          ),
        ),
        padding: EdgeInsets.all(24.px),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set Your Location',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 18.px,
                color: context.color.cardTitleColor,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 8.px),
            CustomDivider(),
            SizedBox(height: 16.px),

            // Option 1: Automatic Selection
            _buildSelectionOption(
              context: context,
              presenter: presenter,
              isAutomatic: true,
              title: 'Automatic Selection',
              subtitle: 'Dhaka, Bangladesh',
            ),

            SizedBox(height: 16.px),
            CustomDivider(),
            SizedBox(height: 16.px),

            // Option 2: Manual Selection
            _buildSelectionOption(
              context: context,
              presenter: presenter,
              isAutomatic: false,
              title: 'Enter Manually',
            ),

            SizedBox(height: 16.px),

            // Country Dropdown - Only enabled when manual selection is active
            _buildDropdown(
              context: context,
              presenter: presenter,
              hintText: 'Select Country',
              items: const [
                DropdownMenuItem(
                  value: 'Bangladesh',
                  child: Text('Bangladesh'),
                ),
                DropdownMenuItem(value: 'India', child: Text('India')),
              ],
              onChanged: (value) {
                presenter.selectOption(value ?? '');
              },
              enabled: !presenter.currentUiState.isAutomaticSelection,
            ),

            SizedBox(height: 16.px),

            // City Dropdown - Only enabled when manual selection is active
            _buildDropdown(
              context: context,
              presenter: presenter,
              hintText: 'Select City',
              items: const [
                DropdownMenuItem(value: 'Dhaka', child: Text('Dhaka')),
                DropdownMenuItem(
                  value: 'Chittagong',
                  child: Text('Chittagong'),
                ),
              ],
              onChanged: (value) {
                presenter.selectOption(value ?? '');
              },
              enabled: !presenter.currentUiState.isAutomaticSelection,
            ),

            // Buttons
            SizedBox(height: 24.px),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildButton(
                  context: context,
                  text: 'Cancel',
                  isCancel: true,
                  onPressed: () {
                    Get.back();
                  },
                ),
                SizedBox(width: 12.px),
                _buildButton(
                  context: context,
                  text: 'Confirm',
                  isCancel: false,
                  onPressed: () {
                    presenter.setAutomaticSelection(
                      !presenter.currentUiState.isAutomaticSelection,
                    );
                    Get.back();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionOption({
    required BuildContext context,
    required BottomSheetPresenter presenter,
    required bool isAutomatic,
    required String title,
    String? subtitle,
  }) {
    final bool isSelected =
        isAutomatic
            ? presenter.currentUiState.isAutomaticSelection
            : !presenter.currentUiState.isAutomaticSelection;

    return InkWell(
      onTap: () {
        presenter.setAutomaticSelection(isAutomatic);
      },
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.check_circle : Icons.circle_outlined,
            color: context.color.primaryColor500,
            size: 24.px,
          ),
          SizedBox(width: 12.px),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: context.color.cardTitleColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (subtitle != null) ...[
                SizedBox(height: 2.px),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
              ],
            ],
          ),
          if (isAutomatic) ...[
            const Spacer(),
            Icon(Icons.my_location, color: Colors.grey, size: 20.px),
          ],
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required BuildContext context,
    required BottomSheetPresenter presenter,
    required String hintText,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
    required bool enabled,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: context.color.cardTitleColor.withOpacity(0.6),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.px),
          borderSide: BorderSide(
            color: context.color.cardTitleColor.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.px),
          borderSide: BorderSide(
            color: context.color.cardTitleColor.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.px),
          borderSide: BorderSide(color: context.color.primaryColor500),
        ),
        filled: true,
        fillColor: context.color.cardGradientStart.withOpacity(0.5),
      ),
      dropdownColor: context.color.cardGradientEnd,
      style: TextStyle(color: context.color.cardTitleColor),
      items: items,
      onChanged: enabled ? onChanged : null,
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String text,
    required bool isCancel,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isCancel ? Colors.grey[300] : context.color.primaryColor500,
          foregroundColor: isCancel ? Colors.black : Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12.px),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.px),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.px),
        ),
      ),
    );
  }
}
