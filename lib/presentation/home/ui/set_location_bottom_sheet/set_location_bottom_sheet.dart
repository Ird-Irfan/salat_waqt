import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/common/widgets/custom_divider.dart';
import 'package:salat_waqt/presentation/home/presenter/bottom_sheet_presenter.dart';
import 'package:salat_waqt/presentation/home/presenter/home_presenter.dart';

class SetLocationBottomSheet extends StatefulWidget {
  const SetLocationBottomSheet({super.key});

  @override
  State<SetLocationBottomSheet> createState() => _SetLocationBottomSheetState();
}

class _SetLocationBottomSheetState extends State<SetLocationBottomSheet> {
  late final BottomSheetPresenter presenter;
  late final HomePresenter homePresenter;

  @override
  void initState() {
    super.initState();
    presenter = loadPresenter(BottomSheetPresenter());
    homePresenter = locator<HomePresenter>();

    // Load countries when bottom sheet is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homePresenter.loadCountries;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Obx(
        () => Container(
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
          padding: EdgeInsets.all(20.px),
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
                  homePresenter.onManualLocationSelected(
                    isManualLocationSelected: true,
                  );
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
                enabled:
                    !presenter.currentUiState.isAutomaticSelection &&
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
                        if (homePresenter.currentUiState.selectedCountry !=
                                null &&
                            homePresenter.currentUiState.selectedCity != null) {
                          // Use selected city/country to change location
                          final country =
                              homePresenter.currentUiState.selectedCountry;
                          final city =
                              homePresenter.currentUiState.selectedCity;
                          if (country != null && city != null) {
                            homePresenter.changeLocation('$city, $country');
                          }
                        }
                      }
                      if (presenter.currentUiState.isAutomaticSelection) {
                        homePresenter.onUseCurrentLocationSelected();
                      }
                      if (homePresenter.currentUiState.isManualLocationSelected == true) {
                        homePresenter.onSaveLocationSelected();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
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
    VoidCallback? onTap,
  }) {
    final bool isSelected =
        isAutomatic
            ? presenter.currentUiState.isAutomaticSelection
            : !presenter.currentUiState.isAutomaticSelection;

    return InkWell(
      onTap:
          onTap ??
          () {
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
    final selectedCountry = homePresenter.currentUiState.selectedCountry;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          child: InkWell(
            onTap:
                enabled
                    ? () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder:
                            (context) => Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              decoration: BoxDecoration(
                                color: context.color.cardGradientEnd,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.px),
                                  topRight: Radius.circular(16.px),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16.px),
                                    child: Text(
                                      'Select Country',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge?.copyWith(
                                        color: context.color.cardTitleColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  CustomDivider(),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: countries.length,
                                      itemBuilder: (context, index) {
                                        final country = countries[index];
                                        return ListTile(
                                          title: Text(
                                            country.name,
                                            style: TextStyle(
                                              color:
                                                  context.color.cardTitleColor,
                                            ),
                                          ),
                                          selected:
                                              selectedCountry == country.name,
                                          selectedTileColor: context
                                              .color
                                              .primaryColor500
                                              .withOpacity(0.1),
                                          onTap: () {
                                            homePresenter.onCountrySelected(
                                              country: country,
                                            );
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      );
                    }
                    : null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.px, vertical: 16.px),
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.color.cardTitleColor.withOpacityInt(0.3),
                ),
                borderRadius: BorderRadius.circular(8.px),
                color: context.color.cardGradientStart.withOpacityInt(0.5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedCountry?.isNotEmpty == true
                          ? selectedCountry!
                          : 'Select Country',
                      style: TextStyle(
                        color:
                            selectedCountry?.isNotEmpty == true
                                ? context.color.cardTitleColor
                                : context.color.cardTitleColor.withOpacityInt(
                                  0.6,
                                ),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: context.color.cardTitleColor.withOpacityInt(0.6),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCityDropdown({
    required BuildContext context,
    required BottomSheetPresenter presenter,
    required HomePresenter homePresenter,
    required bool enabled,
  }) {
    final cities = homePresenter.currentUiState.selectedCountryCities ?? [];
    final selectedCity = homePresenter.currentUiState.selectedCity;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          child: InkWell(
            onTap:
                enabled
                    ? () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder:
                            (context) => Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              decoration: BoxDecoration(
                                color: context.color.cardGradientEnd,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.px),
                                  topRight: Radius.circular(16.px),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16.px),
                                    child: Text(
                                      'Select City',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge?.copyWith(
                                        color: context.color.cardTitleColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  CustomDivider(),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: cities.length,
                                      itemBuilder: (context, index) {
                                        final city = cities[index];
                                        return ListTile(
                                          title: Text(
                                            city.name,
                                            style: TextStyle(
                                              color:
                                                  context.color.cardTitleColor,
                                            ),
                                          ),
                                          selected: selectedCity == city.name,
                                          selectedTileColor: context
                                              .color
                                              .primaryColor500
                                              .withOpacityInt(0.1),
                                          onTap: () {
                                            homePresenter.onCitySelected(
                                              city: city,
                                            );
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      );
                    }
                    : null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.px, vertical: 16.px),
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.color.cardTitleColor.withOpacityInt(0.3),
                ),
                borderRadius: BorderRadius.circular(8.px),
                color: context.color.cardGradientStart.withOpacityInt(0.5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedCity?.isNotEmpty == true
                          ? selectedCity!
                          : 'Select City',
                      style: TextStyle(
                        color:
                            selectedCity?.isNotEmpty == true
                                ? context.color.cardTitleColor
                                : context.color.cardTitleColor.withOpacityInt(
                                  0.6,
                                ),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: context.color.cardTitleColor.withOpacityInt(0.6),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
