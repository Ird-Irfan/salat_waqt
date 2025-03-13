import 'dart:ui';

import 'package:flutter/material.dart';

const List<Color> availableColors = [
  Color(0xff66BB6A),
  Color(0xff7986CB),
  Color(0xff4FC3F7),
  Color(0xff4DB6AC),
  Color(0xff9CCC65),
  Color(0xffDCE775),
  Color(0xffFFB74D),
  Color(0xffFF8A65),
  Color(0xffBA68C8),
  Color(0xffF06292),
  Color(0xffE57373),
  Color(0xffBCAAA4),
  Color(0xff90A4AE),
];

const String packageName = "com.oratiq.prayer_times";
const String appStoreAppId = "1324615850";

const String playStoreUrl =
    "https://play.google.com/store/apps/details?id=$packageName";
const String appStoreUrl =
    "https://apps.apple.com/sa/app/al-hadith/id$appStoreAppId";
const String websiteUrl = "https://oratiq.com";

//==============================================//
const String reportEmailAddress = 'report.irdfoundation@gmail.com';
const String donationUrl = 'https://irdfoundation.com/sadaqa-jaria.html';
const String messengerUrl = "https://m.me/ihadis.official";
const String twitterUrl = "https://twitter.com/irdofficial";
const String facebookGroupUrl = "https://www.facebook.com/groups/irdofficial";
const String facebookPageUrl = "https://www.facebook.com/com.oratiq/";

const Duration defaultPageTransitionDuration = Duration(milliseconds: 370);

const String ptayerNotAllowedTime = '''তিনটি সময় নামাজ পড়া ইসলামী শরীয়তে হারাম। সময় তিনটি হচ্ছেঃ 

(১) সূর্যোদয়ের সময়। অর্থাৎ সূর্য ওঠা শুরু হওয়ার সময় থেকে পুরোপুরি ওঠার আগ পর্যন্ত। গবেষক অনেক আলেমের মতে, এ সময় প্রায় ১০ মিনিট। তবে সতর্কতামূলক কেউ কেউ ১৫ মিনিটের কথাও বলেন। আমরা আমাদের অ্যাপে ১৫ মিনিটই দেখিয়েছি। 

(২) দ্বিপ্রহরের সময়। অর্থাৎ সূর্য যখন মধ্য আকাশে থাকে। এ সময় ৫ মিনিটের মতো। 

(৩) সূর্যাস্তের সময়। অর্থাৎ সূর্য অস্ত যাওয়ার পূর্বে যখন লাল হয়ে যায় তখন থেকে পুরোপুরি অস্তমিত হওয়ার আগ পর্যন্ত। এ সময় প্রায় ১৫ মিনিট। তবে কোনো ব্যক্তি ঐ দিনের আসরের নামাজ না পড়ে থাকলে সূর্যাস্ত হচ্ছে এমন সময়েও আসরের নামাজ পড়তে পারবেন। কিন্তু অন্য কোনো নামাজ এই সময়ে পড়া যাবে না। ইসলামিক ফাউন্ডেশন সহ কোনো কোনো আলেম নিষিদ্ধ সময় হিসাবে ২৩ মিনিটের কথা উল্লেখ করে থাকেন। কিন্তু বর্তমান সময়ের বৈজ্ঞানিক গবেষণা ও আলেমদের পর্যবেক্ষণ দ্বারা জানা যায় যে, নিষিদ্ধ সময়ের ব্যপ্তি ১৫ মিনিটের বেশি নয়। ১৫ মিনিটকে নিষিদ্ধ সময় ধরে সালাত থেকে বিরত থাকাই যথেষ্ট।''';




class ForbiddenTimeData {
  final String title;
  final String description;

  const ForbiddenTimeData({
    required this.title,
    required this.description,
  });
}

const List<ForbiddenTimeData> forbiddenTimesList = [
  ForbiddenTimeData(
    title: 'নামাজের নিষিদ্ধ সময়',
    description: ptayerNotAllowedTime,
  ),
  ForbiddenTimeData(
    title: 'সূর্যাস্তের সময়',
    description: 'সূর্য ডোবার সময় নামাজ পড়া নিষেধ। এই সময়টি সূর্য ডোবার ১০-১৫ মিনিট আগে থেকে সূর্য ডোবা পর্যন্ত।',
  ),
  ForbiddenTimeData(
    title: 'জাওয়ালের সময়',
    description: 'সূর্য মধ্য আকাশে থাকার সময় নামাজ পড়া নিষেধ। এই সময়টি দুপুরের ঠিক আগের ১০-১৫ মিনিট।',
  ),
];

