import 'dart:math';

class RandomGenerate{

  int randomNumber(int max){
    var randomNumber = new Random();
    return randomNumber.nextInt(max);
  }

  randomListItem(List list){
    int listItemNumber = list.length;
    int randomIndex = randomNumber(listItemNumber);
    return list[randomIndex];
  }
}