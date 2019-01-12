import 'package:card_swipe/profiles.dart';
import 'package:flutter/widgets.dart';

class MatchEngine extends ChangeNotifier {
  final List<DateMatch> _matches;
  int _currentIndexMatch;
  int _nextIndexMatch;

  MatchEngine({List<DateMatch> matches}) : _matches= matches {
    _currentIndexMatch = 0;
    _nextIndexMatch = 1;
  }

  DateMatch get currentMatch => _matches[_currentIndexMatch];
  DateMatch get nextMatch => _matches[_nextIndexMatch];

  void cycleMatch(){
    if(currentMatch.decision == Decision.undecided){
      currentMatch.reset();

      _currentIndexMatch = _nextIndexMatch;
      _nextIndexMatch = _nextIndexMatch < _matches.length -1 ? 1 : 0;

      notifyListeners();
    }
  }
}

class DateMatch extends ChangeNotifier {
  final Profiles profile;

  Decision decision = Decision.undecided;

  DateMatch({this.profile});

  void nope() {
    if (decision == Decision.undecided) {
      decision = Decision.nope;
      notifyListeners();
    }
  }

  void like() {
    if (decision == Decision.undecided) {
      decision = Decision.like;
      notifyListeners();
    }
  }

  void superLike() {
    if (decision == Decision.undecided) {
      decision = Decision.superLike;
      notifyListeners();
    }
  }

  void reset() {
    if (decision != Decision.undecided) {
      decision = Decision.undecided;
      notifyListeners();
    }
  }
}

enum Decision {
  undecided,
  nope,
  like,
  superLike,
}
