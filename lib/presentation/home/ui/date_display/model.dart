class DateModel {
  final String arabicDate;
  final String englishDate;

  DateModel({required this.arabicDate, required this.englishDate});

  static List<DateModel> getDates() {
    return [
      DateModel(arabicDate: '15 Ramadan, 1445', englishDate: '16 March 2025'),
      DateModel(arabicDate: '16 Ramadan, 1445', englishDate: '17 March 2025'),
      DateModel(arabicDate: '17 Ramadan, 1445', englishDate: '18 March 2025'),
      DateModel(arabicDate: '18 Ramadan, 1445', englishDate: '19 March 2025'),
      DateModel(arabicDate: '19 Ramadan, 1445', englishDate: '20 March 2025'),
      DateModel(arabicDate: '20 Ramadan, 1445', englishDate: '21 March 2025'),
      DateModel(arabicDate: '21 Ramadan, 1445', englishDate: '22 March 2025'),
      DateModel(arabicDate: '22 Ramadan, 1445', englishDate: '23 March 2025'),
      DateModel(arabicDate: '23 Ramadan, 1445', englishDate: '24 March 2025'),
      DateModel(arabicDate: '24 Ramadan, 1445', englishDate: '25 March 2025'),
    ];
  }
}
