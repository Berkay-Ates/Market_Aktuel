import 'package:market_aktuel/enums/enums_main_page.dart';
import '../enums/enums_category.dart';

class EnumSets{
  List<MainPageCategoryEnum> mainPageEnums = [
    MainPageCategoryEnum.en_yeni_brosurler,
    MainPageCategoryEnum.populer_brosurler,
    MainPageCategoryEnum.onerilen_brosurler
  ];

  List<CategoryEnum> categoryEnums = [
    CategoryEnum.supermarket,
    CategoryEnum.kozmetik,
    CategoryEnum.yapi_market,
    CategoryEnum.moda,
    CategoryEnum.kitap,
    CategoryEnum.otomotiv,
    CategoryEnum.restorant,
    CategoryEnum.seyahat,
    CategoryEnum.spor,
    CategoryEnum.ev_mobilya,
    CategoryEnum.cocuk,
    CategoryEnum.elektronik,
    CategoryEnum.bankalar
  ];

  List<String> mainPageEnumNames = [
    'En Yeni Broşürler',
    'Popüler Broşürler',
    'Önerilen Broşürler'
  ];

  List<String> categoryEnumNames = [
    'Süpermarket',
    'Kozmetik',
    'Yapı Market',
    'Moda',
    'Kitap',
    'Otomotiv',
    'Restorantlar',
    'Seyahat',
    'Spor',
    'Ev ve Mobilya',
    'Çocuk',
    'Elektronik',
    'Bankalar'
  ];
}