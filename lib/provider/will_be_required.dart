import 'package:flutter/cupertino.dart';
import 'package:market_aktuel/enums/enums_category.dart';
import '../enums/enums_main_page.dart';


class WillBeRequired extends ChangeNotifier {
  String pdfCurrentPage = '1';
  String _pdfName = '';
  String _pdfUrl = '';

  CategoryEnum _categoryEnum = CategoryEnum.supermarket;
  MainPageCategoryEnum _mainPageCategoryEnum =
      MainPageCategoryEnum.en_yeni_brosurler;

  String getPdfName() => _pdfName;

  String getPdfUrl() => _pdfUrl;

  void setPdfUrl(String value) {
    _pdfUrl = value;
  }

  void setPdfName(String value) {
    _pdfName = value;
  }

  void setCategory(CategoryEnum category) {
    _categoryEnum = category;
    notifyListeners();
  }

  CategoryEnum getCategory() {
    return _categoryEnum;
  }

  void setMainPageCategory(MainPageCategoryEnum mainPageCategory) {
    _mainPageCategoryEnum = mainPageCategory;
    notifyListeners();
  }

  MainPageCategoryEnum getMainPageCategory() {
    return _mainPageCategoryEnum;
  }

  void setPdfCurrentPage(int current) {
    pdfCurrentPage = current.toString();
    notifyListeners();
  }

  String getPdfCurrentPage() {
    return pdfCurrentPage;
  }
}
