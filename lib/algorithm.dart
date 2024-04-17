import 'package:trotter/trotter.dart';

num operate(num val1, String op, num val2) {
  if (val2 == 0) return -99999;

  switch (op) {
    case '+':
      return val1 + val2;
    case '-':
      return val1 - val2;
    case '×':
      return val1 * val2;
    case '/':
      return val1 / val2;
    default:
      return -99999;
  }
}

num calculate(List<int> pk, List<String> po, int code) {
  switch (code) {
    case 1:
      // 1, 2, 3
      final valAB = operate(pk[0], po[0], pk[1]);
      final valABC = operate(valAB, po[1], pk[2]);
      final valABCD = operate(valABC, po[2], pk[3]);
      return valABCD;
    case 2:
      // 1, 3, 2 dan 3, 1, 2
      final valAB = operate(pk[0], po[0], pk[1]);
      final valCD = operate(pk[2], po[2], pk[3]);
      final valABCD = operate(valAB, po[1], valCD);
      return valABCD;
    case 3:
      // 2, 1, 3
      final valBC = operate(pk[1], po[1], pk[2]);
      final valABC = operate(pk[0], po[0], valBC);
      final valABCD = operate(valABC, po[2], pk[3]);
      return valABCD;
    case 4:
      // 2, 3, 1
      final valBC = operate(pk[1], po[1], pk[2]);
      final valBCD = operate(valBC, po[2], pk[3]);
      final valABCD = operate(pk[0], po[0], valBCD);
      return valABCD;
    case 5:
      // 3, 2, 1
      final valCD = operate(pk[2], po[2], pk[3]);
      final valBCD = operate(pk[1], po[1], valCD);
      final valABCD = operate(pk[0], po[0], valBCD);
      return valABCD;
    default:
      return -9999;
  }
}

String printSolution(List<int> pk, List<String> po, int code) {
  final arr = [pk[0], po[0], pk[1], po[1], pk[2], po[2], pk[3]];
  final indices = ['a', 'b', 'c', 'd', 'e', 'f', 'g'];
  String ret = '';
  switch (code) {
    case 1:
      ret = "(( a b c ) d e ) f g ";
      break;
    case 2:
      ret = "( a b c ) d ( e f g )";
      break;
    case 3:
      ret = "( a b ( c d e )) f g ";
      break;
    case 4:
      ret = " a b (( c d e ) f g )";
      break;
    case 5:
      ret = " a b ( c d ( e f g ))";
      break;
    default:
      return '-';
  }

  if (ret == '-') return ret;
  // replace
  for (int i = 0; i < arr.length; i++) {
    ret = ret.replaceFirst(indices[i], arr[i].toString());
  }
  return ret;
}

List<String> generateSolutions(List<int> cards, int target) {
  List<String> solutions = [];

  final indices = List<int>.generate(cards.length, (i) => i); // [0,1,2,3]
  final permsAllCards =
      indices.permutations().iterable.map((arr) => arr.map((i) => cards[i]).join(',')).toSet().toList();
  // indices.permutations().iterable.map<List<int>>((arr) => arr.map<int>((i) => cards[i]).toList()).toSet();
  final permsAllOps = Amalgams(4, characters('+-×/'))();

  for (final cardstr in permsAllCards) {
    List<int> card = cardstr.split(',').map<int>((el) => int.parse(el)).toList();
    for (final op in permsAllOps) {
      for (int code = 1; code < 6; code++) {
        if (calculate(card, op, code) == target) {
          solutions.add(printSolution(card, op, code));
        }
      }
    }
  }

  // remove duplicate
  solutions = solutions.toSet().toList();
  return solutions;
}
