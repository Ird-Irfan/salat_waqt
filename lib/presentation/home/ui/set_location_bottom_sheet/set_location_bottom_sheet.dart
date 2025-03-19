import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/common/widgets/custom_divider.dart';
import 'package:salat_waqt/presentation/home/presenter/bottom_sheet_presenter.dart';
import 'package:salat_waqt/presentation/home/presenter/home_presenter.dart';

class SetLocationBottomSheet extends StatelessWidget {
  const SetLocationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomSheetPresenter presenter = loadPresenter(
      BottomSheetPresenter(),
    );
    final HomePresenter homePresenter = locator<HomePresenter>();
    
    // Load countries when bottom sheet is opened
    homePresenter.loadCountries;
    
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Obx(() => Container(
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
              subtitle: homePresenter.showLocationName(),
              onTap: () {
                presenter.setAutomaticSelection(true);
                homePresenter.onUseCurrentLocationSelected();
              },
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
              onTap: () {
                presenter.setAutomaticSelection(false);
                homePresenter.onManualLocationSelected(isManualLocationSelected: true);
              },
            ),

            SizedBox(height: 16.px),

            // Country Dropdown - Only enabled when manual selection is active
            _buildCountryDropdown(
              context: context,
              presenter: presenter,
              homePresenter: homePresenter,
              enabled: !presenter.currentUiState.isAutomaticSelection,
            ),

            SizedBox(height: 16.px),

            // City Dropdown - Only enabled when manual selection is active and country is selected
            _buildCityDropdown(
              context: context,
              presenter: presenter,
              homePresenter: homePresenter,
              enabled: !presenter.currentUiState.isAutomaticSelection && 
                      homePresenter.currentUiState.selectedCountry != null &&
                      homePresenter.currentUiState.selectedCountry!.isNotEmpty,
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
                    if (!presenter.currentUiState.isAutomaticSelection) {
                      if (homePresenter.currentUiState.selectedCountry != null &&
                          homePresenter.currentUiState.selectedCity != null) {
                        // Use selected city/country to change location
                        final country = homePresenter.currentUiState.selectedCountry;
                        final city = homePresenter.currentUiState.selectedCity;
                        if (country != null && city != null) {
                          homePresenter.changeLocation('$city, $country');
                        }
                      }
                    }
                    homePresenter.onSaveLocationSelected();
                  },
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildSelectionOption({
    required BuildContext context,
    required BottomSheetPresenter presenter,
    required bool isAutomatic,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    final bool isSelected =
        isAutomatic
            ? presenter.currentUiState.isAutomaticSelection
            : !presenter.currentUiState.isAutomaticSelection;

    return InkWell(
      onTap: onTap ?? () {
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

  Widget _buildCountryDropdown({
    required BuildContext context,
    required BottomSheetPresenter presenter,
    required HomePresenter homePresenter,
    required bool enabled,
  }) {
    final countries = homePresenter.currentUiState.countries ?? [];
    
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: 'Select Country',
        hintStyle: TextStyle(
          color: context.color.cardTitleColor.withOpacityInt(0.6),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.px),
          borderSide: BorderSide(
            color: context.color.cardTitleColor.withOpacityInt(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.px),
          borderSide: BorderSide(
            color: context.color.cardTitleColor.withOpacityInt(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.px),
          borderSide: BorderSide(color: context.color.primaryColor500),
        ),
        filled: true,
        fillColor: context.color.cardGradientStart.withOpacityInt(0.5),
      ),
      dropdownColor: context.color.cardGradientEnd,
      style: TextStyle(color: context.color.cardTitleColor),
      value: homePresenter.currentUiState.selectedCountry?.isNotEmpty == true 
          ? homePresenter.currentUiState.selectedCountry 
          : null,
      items: countries.map((country) {
        return DropdownMenuItem<String>(
          value: country.name,
          child: Text(country.name),
        );
      }).toList(),
      onChanged: enabled ? (value) {
        if (value != null) {
          final selectedCountry = countries.firstWhere(
            (country) => country.name == value,
            orElse: () => countries.first,
          );
          homePresenter.onCountrySelected(country: selectedCountry);
        }
      } : null,
    );
  }

  Widget _buildCityDropdown({
    required BuildContext context,
    required BottomSheetPresenter presenter,
    required HomePresenter homePresenter,
    required bool enabled,
  }) {
    final cities = homePresenter.currentUiState.selectedCountryCities ?? [];
    
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: 'Select City',
        hintStyle: TextStyle(
          color: context.color.cardTitleColor.withOpacityInt(0.6),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.px),
          borderSide: BorderSide(
            color: context.color.cardTitleColor.withOpacityInt(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.px),
          borderSide: BorderSide(
            color: context.color.cardTitleColor.withOpacityInt(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.px),
          borderSide: BorderSide(color: context.color.primaryColor500),
        ),
        filled: true,
        fillColor: context.color.cardGradientStart.withOpacityInt(0.5),
      ),
      dropdownColor: context.color.cardGradientEnd,
      style: TextStyle(color: context.color.cardTitleColor),
      value: homePresenter.currentUiState.selectedCity?.isNotEmpty == true 
          ? homePresenter.currentUiState.selectedCity 
          : null,
      items: cities.map((city) {
        return DropdownMenuItem<String>(
          value: city.name,
          child: Text(city.name),
        );
      }).toList(),
      onChanged: enabled ? (value) {
        if (value != null) {
          final selectedCity = cities.firstWhere(
            (city) => city.name == value,
            orElse: () => cities.first,
          );
          homePresenter.onCitySelected(city: selectedCity);
        }
      } : null,
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
