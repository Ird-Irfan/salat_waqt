import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salat_waqt/presentation/home/presenter/home_presenter.dart';

class LocationScreen extends StatelessWidget {
  final LocationController controller;

  const LocationScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('নামাজের সময়')),
      body: Obx(
        () =>
            controller.isLoading
                ? Center(child: CircularProgressIndicator())
                : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'আপনার বর্তমান অবস্থান:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        controller.currentAddress,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _showLocationDialog(
                            context,
                          ); // লোকেশন পরিবর্তনের ডায়ালগ বক্স
                        },
                        child: Text('লোকেশন পরিবর্তন করুন'),
                      ),
                      SizedBox(height: 30),
                      controller.prayerTimes != null
                          ? Column(
                            children: [
                              Text(
                                'নামাজের সময়সূচী:',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 10),
                              Text('ফজর: ${controller.prayerTimes!['Fajr']}'),
                              Text('যোহর: ${controller.prayerTimes!['Dhuhr']}'),
                              Text('আসর: ${controller.prayerTimes!['Asr']}'),
                              Text(
                                'মাগরিব: ${controller.prayerTimes!['Maghrib']}',
                              ),
                              Text('ঈশা: ${controller.prayerTimes!['Isha']}'),
                            ],
                          )
                          : Container(),
                    ],
                  ),
                ),
      ),
    );
  }

  //  লোকেশন পরিবর্তনের জন্য ডায়ালগ বক্স
  Future<void> _showLocationDialog(BuildContext context) async {
    String newLocation = '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('নতুন লোকেশন দিন'),
          content: TextField(
            onChanged: (value) {
              newLocation = value;
            },
            decoration: InputDecoration(hintText: "শহরের নাম লিখুন"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('বাতিল'),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text('ঠিক আছে'),
              onPressed: () async {
                if (newLocation.isNotEmpty) {
                  await controller.changeLocation(newLocation);
                }
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
