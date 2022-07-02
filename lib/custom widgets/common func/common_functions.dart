import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CommonFunctions{

  String catalogLifeCycle(Timestamp startingDate, Timestamp expiringDate) {
    var now = DateTime.now();
    var starting = startingDate.toDate();
    var expiring = expiringDate.toDate();
    var remainingDaysToExpire = expiring.difference(now).inDays;
    var remainingDaysToStart = starting.difference(now).inDays ;
    final DateFormat formatter = DateFormat('MMMM d EEEE ');
    final String startingFormatted = formatter.format(starting);
    final String expiringFormatted = formatter.format(expiring);

    if (remainingDaysToStart > 1) {
      return 'Yakında başlıyor\nBaşlangıç: $startingFormatted';

    } else if (remainingDaysToStart == 1) {
      return 'Yarın başlıyor';

    } else if (remainingDaysToStart == 0) {
      return 'Bugün başladı\nBitiş: $expiringFormatted';

    } else if (remainingDaysToStart < 0 && remainingDaysToExpire > 2) {
      return 'Devam ediyor\nBitiş: $expiringFormatted';

    } else if (remainingDaysToStart < 0 && remainingDaysToExpire > 1) {
      return 'Yakında bitiyor\nBitiş: $expiringFormatted';

    } else if (remainingDaysToStart < 0 && remainingDaysToExpire == 1) {
      return 'Yarın bitiyor';

    } else if (remainingDaysToStart < 0 && remainingDaysToExpire == 0) {
      return 'Bugün bitiyor';

    }else if(remainingDaysToStart < 0 && remainingDaysToExpire == -1){
      return 'Dün bitti\nBitiş: $expiringFormatted';

    }else if(remainingDaysToStart < 0 && remainingDaysToExpire < -1){
      return 'Çoktan bitti\nBitiş: $expiringFormatted';
    }
    return 'Birşeyler ters gitmiş olabilir';
  }

  Color getValidityColor(Timestamp startingDate, Timestamp expiringDate){

    var now = DateTime.now();
    var starting = startingDate.toDate();
    var expiring = expiringDate.toDate();
    var remainingDaysToExpire = expiring.difference(now).inDays;
    var remainingDaysToStart = starting.difference(now).inDays;

    if(remainingDaysToStart > 0){
      return const Color(0xff008E89);

    }else if(remainingDaysToStart <= 0 && remainingDaysToExpire>=0){
      return const Color(0xff6EBF8B);

    }else if(remainingDaysToStart <0 && remainingDaysToExpire<0){
      return const Color(0xffD82148);
    }

    return const Color(0xff886F6F);
  }
}