import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lunar_calendar_converter/lunar_solar_converter.dart';
import 'package:sunrise_sunset/sunrise_sunset.dart';

enum CardType {
  zero,
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  eleven,
  twelve,
  thirteen,
  fourteen,
  fifteen,
  sixteen,
  seventeen,
  eighteen,
  nineteen,
  twenty,
  twenty_one,
}

class PlayingCard {
  CardType cardType;
  bool faceUp;
  bool opened;
  PlayingCard({
    @required this.cardType,
    this.faceUp = false,
    this.opened = false,
  });
}

class WatchingCard {
  CardType cardType;
  bool faceUp;
  bool opened;
  WatchingCard({
    @required this.cardType,
    this.faceUp = false,
    this.opened = false,
  });
}

void main() => runApp(MyApp());

var now = DateTime.now();
var mWeek = {
  0: 'Sun',
  1: 'Mon',
  2: 'Tue',
  3: 'Wed',
  4: 'Thu',
  5: 'Fri',
  6: 'Sat',
  7: 'Sun',
};
var mMonth = {
  1: 'Jan',
  2: 'Feb',
  3: 'Mar',
  4: 'Apr',
  5: 'May',
  6: 'Jun',
  7: 'Jul',
  8: 'Aug',
  9: 'Sep',
  10: 'Oct',
  11: 'Nov',
  12: 'Dec',
};

var tarotMean = [
  '우둔함, 어리석음, 방종',
  '기술, 의지력, 자신감',
  '과학, 교육, 지식',
  '풍요, 활동, 창조',
  '힘, 효율성, 이성',
  '자비, 덕, 이 속성의 사람',
  '통과해야할 시험, 새 사랑',
  '승리, 장애, 극복',
  '영적 힘',
  '신중함, 영적 진보',
  '행운, 성공, 운',
  '균형, 정의, 평형',
  '자기희생으로 얻는 지혜',
  '발전적 변화, 변형',
  '겉보기에 다른 것 합치기, 중용',
  '무언가 일어나야 하나 결국 좋은 일',
  '황폐, 파국, 분열',
  '희망, 밝은 미래',
  '속이는 것, 숨겨진 적',
  '행복, 만족',
  '부활, 재생',
  '확실한 성공, 완수',
];

Solar solar =
    Solar(solarYear: now.year, solarMonth: now.month, solarDay: now.day);
Lunar lunar = LunarSolarConverter.solarToLunar(solar);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp2(),
    );
  }
}

enum Dream { astral, psy, play }
enum Emotion { happy, normal, sad }
enum Body { good, bad }
enum Ritual {
  pentagram,
  hexagram,
  tarotWatch,
  tarotAstral,
}
enum Result { good, normal, bad }

class MyApp2 extends StatefulWidget {
  @override
  _MyApp2State createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {
  List<PlayingCard> cardList = List<PlayingCard>(22);

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _initialiseGame();
  }

  void _initialiseGame() {
    List<PlayingCard> allCards = [];
    CardType.values.forEach((type) {
      allCards.add(PlayingCard(
        cardType: type,
        faceUp: Random().nextBool(),
      ));
    });
    for (int i = 0; i < 7; i++) {
      int randomNumber = Random().nextInt(allCards.length);
      PlayingCard card = allCards[randomNumber];
      allCards.removeAt(randomNumber);
      cardList[i] = card;
    }
  }

  cardFunction(int kk) => cardList[kk].faceUp
      ? Image.asset(
          'images/ar${cardList[kk].cardType.toString().split('.').last}.jpg')
      : RotatedBox(
          quarterTurns: 10,
          child: Image.asset(
              'images/ar${cardList[kk].cardType.toString().split('.').last}.jpg'),
        );

  int tarotNumber = 0;
  bool tarotBool0 = false;
  bool tarotBool1 = false;
  bool tarotBool2 = false;
  bool tarotBool3 = false;
  bool tarotBool4 = false;
  bool tarotBool5 = false;
  bool tarotBool6 = false;
  bool tarotWatch = false;

  bool _tarotSet = false;
  Dream _dream = Dream.astral;
  Emotion _emotion = Emotion.happy;
  Body _body = Body.good;
  Ritual _ritual = Ritual.pentagram;
  Result _result = Result.good;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Container(
                child: Text(
                  '${mWeek[now.weekday]}, ${mMonth[now.month]} ${now.day}, ${now.year}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                  child: Text(
                '  ${now.hour} : ${now.minute},',
                style: TextStyle(fontSize: 20),
              )),
              SizedBox(
                width: 15,
              ),
              Container(
                  child: Text(
                'Lunar : ${lunar.lunarDay}',
                style: TextStyle(fontSize: 20),
              )),
              SizedBox(
                width: 10,
              ),
              Container(
                child: Image.asset('images/moon${lunar.lunarDay}.png'),
                width: 20,
                height: 20,
              ),
            ],
          ),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'note',
              ),
              Tab(text: 'diary'),
              Tab(text: 'tarot watch'),
              Tab(text: 'tarot astral'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('수행 의식 :'),
                    Radio(
                      value: Ritual.pentagram,
                      groupValue: _ritual,
                      onChanged: (Ritual value) {
                        setState(() {
                          _ritual = value;
                        });
                      },
                    ),
                    Text('펜타그램'),
                    Radio(
                      value: Ritual.hexagram,
                      groupValue: _ritual,
                      onChanged: (Ritual value) {
                        setState(() {
                          _ritual = value;
                        });
                      },
                    ),
                    Text('펜타+헥사'),
                    Radio(
                      value: Ritual.tarotWatch,
                      groupValue: _ritual,
                      onChanged: (Ritual value) {
                        setState(() {
                          _ritual = value;
                        });
                      },
                    ),
                    Text('타로응시'),
                    Radio(
                      value: Ritual.tarotAstral,
                      groupValue: _ritual,
                      onChanged: (Ritual value) {
                        setState(() {
                          _ritual = value;
                        });
                      },
                    ),
                    Text('타로점'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('감정 상태 :'),
                    Radio(
                      value: Emotion.happy,
                      groupValue: _emotion,
                      onChanged: (Emotion value) {
                        setState(() {
                          _emotion = value;
                        });
                      },
                    ),
                    Text('good'),
                    Radio(
                      value: Emotion.normal,
                      groupValue: _emotion,
                      onChanged: (Emotion value) {
                        setState(() {
                          _emotion = value;
                        });
                      },
                    ),
                    Text('normal'),
                    Radio(
                      value: Emotion.sad,
                      groupValue: _emotion,
                      onChanged: (Emotion value) {
                        setState(() {
                          _emotion = value;
                        });
                      },
                    ),
                    Text('sad'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('신체 컨디션 :'),
                    Radio(
                      value: Body.good,
                      groupValue: _body,
                      onChanged: (Body value) {
                        setState(() {
                          _body = value;
                        });
                      },
                    ),
                    Text('good'),
                    Radio(
                      value: Body.bad,
                      groupValue: _body,
                      onChanged: (Body value) {
                        setState(() {
                          _body = value;
                        });
                      },
                    ),
                    Text('bad'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('성과 :'),
                    Radio(
                      value: Result.good,
                      groupValue: _result,
                      onChanged: (Result value) {
                        setState(() {
                          _result = value;
                        });
                      },
                    ),
                    Text('good'),
                    Radio(
                      value: Result.normal,
                      groupValue: _result,
                      onChanged: (Result value) {
                        setState(() {
                          _result = value;
                        });
                      },
                    ),
                    Text('normal'),
                    Radio(
                      value: Result.bad,
                      groupValue: _result,
                      onChanged: (Result value) {
                        setState(() {
                          _result = value;
                        });
                      },
                    ),
                    Text('bad'),
                  ],
                ),
                Container(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    minLines: 15,
                    maxLines: null,
                  ),
                )
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('꿈 종류 : '),
                    Radio(
                      value: Dream.astral,
                      groupValue: _dream,
                      onChanged: (Dream value) {
                        setState(() {
                          _dream = value;
                        });
                      },
                    ),
                    Text('Astral travel'),
                    Radio(
                      value: Dream.psy,
                      groupValue: _dream,
                      onChanged: (Dream value) {
                        setState(() {
                          _dream = value;
                        });
                      },
                    ),
                    Text('Psycological message'),
                    Radio(
                      value: Dream.play,
                      groupValue: _dream,
                      onChanged: (Dream value) {
                        setState(() {
                          _dream = value;
                        });
                      },
                    ),
                    Text('Play'),
                  ],
                ),
                Container(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    minLines: 20,
                    maxLines: null,
                  ),
                )
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('타로 구성 :'),
                    Text('    초보자용'),
                    Switch(
                      value: _tarotSet,
                      onChanged: (bool value) {
                        setState(() {
                          _tarotSet = value;
                        });
                      },
                    ),
                    Text('숙련자용'),
                  ],
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      tarotNumber = Random().nextInt(22);
                      tarotWatch = true;
                    });
                  },
                  child: Container(
                    height: 680,
                    width: 350,
                    child: tarotWatch
                        ? Image.asset('images/lite$tarotNumber.jpg')
                        : Image.asset('images/tarot_back.png'),
                  ),
                ),
                Text('느낌 적기'),
                TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: null,
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        width: 120,
                        height: 150,
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              tarotBool0 = true;
                            });
                          },
                          child: tarotBool0
                              ? cardFunction(0)
                              : Image.asset('images/tarot_back.png'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        width: 120,
                        height: 150,
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              tarotBool1 = true;
                            });
                          },
                          child: tarotBool1
                              ? cardFunction(1)
                              : Image.asset('images/tarot_back.png'),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        width: 120,
                        height: 150,
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              tarotBool2 = true;
                            });
                          },
                          child: tarotBool2
                              ? cardFunction(2)
                              : Image.asset('images/tarot_back.png'),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        width: 120,
                        height: 150,
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              tarotBool3 = true;
                            });
                          },
                          child: tarotBool3
                              ? cardFunction(3)
                              : Image.asset('images/tarot_back.png'),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        width: 120,
                        height: 150,
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              tarotBool4 = true;
                            });
                          },
                          child: tarotBool4
                              ? cardFunction(4)
                              : Image.asset('images/tarot_back.png'),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        width: 120,
                        height: 150,
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              tarotBool5 = true;
                            });
                          },
                          child: tarotBool5
                              ? cardFunction(5)
                              : Image.asset('images/tarot_back.png'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        width: 120,
                        height: 150,
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              tarotBool6 = true;
                            });
                          },
                          child: tarotBool6
                              ? cardFunction(6)
                              : Image.asset('images/tarot_back.png'),
                        ),
                      ),
                    ),
                  ],
                ),
                RaisedButton(
                  child: Text('초기화'),
                  onPressed: () {
                    setState(() {
                      tarotBool6 = false;
                      tarotBool0 = false;
                    });
                  },
                ),
//                TextField(
//                  keyboardType: TextInputType.multiline,
//                  minLines: 1,
//                  maxLines: null,
//                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
