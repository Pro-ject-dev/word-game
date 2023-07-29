import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:word_game/glass.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  List index_list = [];
  var data;
  List<bool> cellStates = List.filled(25, false);
  String a = '';
  String points = "0";
  List<String> words = ['POT', 'TOP', 'HAT', "BAT", "UGLY", "TOY"];
  List<String> letters = [
    "P",
    "O",
    "T",
    "S",
    "U",
    "I",
    "T",
    "P",
    "I",
    "G",
    "D",
    "O",
    "A",
    "T",
    "L",
    "T",
    "I",
    "A",
    "B",
    "Y",
    "R",
    "H",
    "T",
    "O",
    "Y",
    "C"
  ];
  AudioPlayer audioPlayer = AudioPlayer();

  void playLocalAudio() async {
    await audioPlayer.setAsset('Assets/click.wav');
    await audioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Opacity(
              opacity: 0.95,
              child: Transform.rotate(
                angle: 0,
                child: Image.asset(
                  repeat: ImageRepeat.repeat,
                  'Assets/c.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.workspace_premium_outlined,
                            color: Colors.amber,
                            size: 35,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "${points} Points",
                            style: TextStyle(
                                shadows: [
                                  BoxShadow(
                                      color: Colors.pink,
                                      offset: Offset(
                                        0,
                                        1,
                                      ),
                                      blurRadius: 2)
                                ],
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => Game())));
                        },
                        child: Icon(
                          Icons.restart_alt,
                          color: Color.fromARGB(255, 255, 255, 255),
                          size: 35,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: GlassContainer(
                    borderColor: Colors.white,
                    child: Container(
                      height: 105,
                      width: 330,
                      child: GridView.builder(
                          itemCount: words.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 2,
                                  mainAxisSpacing: 0.7,
                                  childAspectRatio: 2.5),
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 11.0, bottom: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white10,
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        words[index],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      a.length >= 1
                          ? GlassContainer(
                              borderColor: Colors.tealAccent,
                              child: Container(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(a,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                              )),
                            )
                          : Container(),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Center(
                  child: GlassContainer(
                    borderColor: Colors.white,
                    child: SizedBox(
                      height: 340,
                      width: 330,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 7,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: 25,
                          itemBuilder: (BuildContext context, int index) {
                            final rowIndex = index ~/ 5;
                            final colIndex = index % 5;
                            final cellIndex = index;

                            return GestureDetector(
                              onTap: () async {
                                playLocalAudio();
                                if (index_list.length >= 1) {
                                  data = index_list[index_list.length - 1];
                                }

                                if (index_list.length == 0) {
                                  index_list.add([
                                    rowIndex,
                                    colIndex,
                                    letters[cellIndex],
                                    cellIndex
                                  ]);
                                  print(index_list);
                                  setState(() {
                                    cellStates[cellIndex] =
                                        !cellStates[cellIndex];
                                  });
                                  check_valid(colIndex, rowIndex);
                                } else if (rowIndex ==
                                        index_list[index_list.length - 1][0] &&
                                    colIndex ==
                                        index_list[index_list.length - 1][1]) {
                                  index_list.removeWhere((item) =>
                                      item[0] == rowIndex &&
                                      item[1] == colIndex);
                                  setState(() {
                                    cellStates[cellIndex] =
                                        !cellStates[cellIndex];
                                  });
                                } else if ((rowIndex == data[0] - 1 &&
                                        colIndex == data[1] - 1) ||
                                    (rowIndex == data[0] - 1 &&
                                        colIndex == data[1]) ||
                                    (rowIndex == data[0] - 1 &&
                                            colIndex == data[1] + 1 ||
                                        (rowIndex == data[0] &&
                                            colIndex == data[1] - 1) ||
                                        (rowIndex == data[0] &&
                                            colIndex == data[1] + 1) ||
                                        (rowIndex == data[0] + 1 &&
                                            colIndex == data[1] - 1) ||
                                        (rowIndex == data[0] + 1 &&
                                                colIndex == data[1] ||
                                            (rowIndex == data[0] + 1 &&
                                                colIndex == data[1] + 1)))) {
                                  if (index_list.length >= 2) {
                                    if ((rowIndex == data[0] - 1 &&
                                        colIndex == data[1] - 1)) {
                                      if (index_list[index_list.length - 2][0] -
                                                  data[0] ==
                                              1 &&
                                          index_list[index_list.length - 2][1] -
                                                  data[1] ==
                                              1) {
                                        index_list.add([
                                          rowIndex,
                                          colIndex,
                                          letters[cellIndex],
                                          cellIndex
                                        ]);
                                        print(index_list);
                                        setState(() {
                                          cellStates[cellIndex] =
                                              !cellStates[cellIndex];
                                        });
                                        check_valid(colIndex, rowIndex);
                                      }
                                    } else if (rowIndex == data[0] - 1 &&
                                        colIndex == data[1]) {
                                      if (index_list[index_list.length - 2][0] -
                                                  data[0] ==
                                              1 &&
                                          index_list[index_list.length - 2][1] -
                                                  data[1] ==
                                              0) {
                                        index_list.add([
                                          rowIndex,
                                          colIndex,
                                          letters[cellIndex],
                                          cellIndex
                                        ]);
                                        print(index_list);
                                        setState(() {
                                          cellStates[cellIndex] =
                                              !cellStates[cellIndex];
                                        });
                                        check_valid(colIndex, rowIndex);
                                      }
                                    } else if (rowIndex == data[0] - 1 &&
                                        colIndex == data[1] + 1) {
                                      if (index_list[index_list.length - 2][0] -
                                                  data[0] ==
                                              1 &&
                                          index_list[index_list.length - 2][1] -
                                                  data[1] ==
                                              -1) {
                                        index_list.add([
                                          rowIndex,
                                          colIndex,
                                          letters[cellIndex],
                                          cellIndex
                                        ]);

                                        setState(() {
                                          cellStates[cellIndex] =
                                              !cellStates[cellIndex];
                                        });
                                        check_valid(colIndex, rowIndex);
                                      }
                                    } else if (rowIndex == data[0] &&
                                        colIndex == data[1] - 1) {
                                      if (index_list[index_list.length - 2][0] -
                                                  data[0] ==
                                              0 &&
                                          index_list[index_list.length - 2][1] -
                                                  data[1] ==
                                              1) {
                                        index_list.add([
                                          rowIndex,
                                          colIndex,
                                          letters[cellIndex],
                                          cellIndex
                                        ]);

                                        setState(() {
                                          cellStates[cellIndex] =
                                              !cellStates[cellIndex];
                                        });
                                        check_valid(colIndex, rowIndex);
                                      }
                                    } else if (rowIndex == data[0] &&
                                        colIndex == data[1] + 1) {
                                      if (index_list[index_list.length - 2][0] -
                                                  data[0] ==
                                              0 &&
                                          index_list[index_list.length - 2][1] -
                                                  data[1] ==
                                              -1) {
                                        index_list.add([
                                          rowIndex,
                                          colIndex,
                                          letters[cellIndex],
                                          cellIndex
                                        ]);
                                        print(index_list);
                                        setState(() {
                                          cellStates[cellIndex] =
                                              !cellStates[cellIndex];
                                        });
                                        check_valid(colIndex, rowIndex);
                                      }
                                    } else if (rowIndex == data[0] + 1 &&
                                        colIndex == data[1] - 1) {
                                      if (index_list[index_list.length - 2][0] -
                                                  data[0] ==
                                              -1 &&
                                          index_list[index_list.length - 2][1] -
                                                  data[1] ==
                                              1) {
                                        index_list.add([
                                          rowIndex,
                                          colIndex,
                                          letters[cellIndex],
                                          cellIndex
                                        ]);
                                        print(index_list);
                                        setState(() {
                                          cellStates[cellIndex] =
                                              !cellStates[cellIndex];
                                        });
                                        check_valid(colIndex, rowIndex);
                                      }
                                    } else if (rowIndex == data[0] + 1 &&
                                        colIndex == data[1]) {
                                      if (index_list[index_list.length - 2][0] -
                                                  data[0] ==
                                              -1 &&
                                          index_list[index_list.length - 2][1] -
                                                  data[1] ==
                                              0) {
                                        index_list.add([
                                          rowIndex,
                                          colIndex,
                                          letters[cellIndex],
                                          cellIndex
                                        ]);
                                        print(index_list);
                                        setState(() {
                                          cellStates[cellIndex] =
                                              !cellStates[cellIndex];
                                        });
                                        check_valid(colIndex, rowIndex);
                                      }
                                    } else if (rowIndex == data[0] + 1 &&
                                        colIndex == data[1] + 1) {
                                      if (index_list[index_list.length - 2][0] -
                                                  data[0] ==
                                              -1 &&
                                          index_list[index_list.length - 2][1] -
                                                  data[1] ==
                                              -1) {
                                        index_list.add([
                                          rowIndex,
                                          colIndex,
                                          letters[cellIndex],
                                          cellIndex
                                        ]);
                                        print(index_list);
                                        setState(() {
                                          cellStates[cellIndex] =
                                              !cellStates[cellIndex];
                                        });
                                        check_valid(colIndex, rowIndex);
                                      }
                                    }
                                  } else {
                                    index_list.add([
                                      rowIndex,
                                      colIndex,
                                      letters[cellIndex]
                                    ]);
                                    print(index_list);
                                    setState(() {
                                      cellStates[cellIndex] =
                                          !cellStates[cellIndex];
                                    });
                                    check_valid(colIndex, rowIndex);
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: cellStates[cellIndex]
                                      ? Colors.teal
                                      : Colors.white,
                                ),
                                child: GlassContainer(
                                  borderColor: cellStates[cellIndex]
                                      ? Colors.tealAccent
                                      : Colors.pinkAccent,
                                  child: Center(
                                    child: Text(
                                      letters[cellIndex],
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        color: cellStates[cellIndex]
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  check_valid(rowIndex, colIndex) {
    a = '';

    for (var i = 0; i < index_list.length; i++) {
      a += index_list[i][2].toString();
    }
    if (words.contains(a)) {
      words.removeWhere((item) => item == a);
      var b = int.parse(points);
      b += 10;
      print(b);
      setState(() {
        points = b.toString();
      });
      index_list.clear();
      if (words.length == 0) {
        Navigator.pop(context);
      }
    }
  }
}

final List<String> meaningfulWords = [
  'happy',
  'love',
  'create',
  'learn',
  'explore',
  'dream',
  'kind',
  'laugh',
  'smile',
  'peace',
  'joy',
  'hope',
  'brave',
  'faith',
  'calm',
  'grace',
  'bliss',
  'magic',
  'hug',
  'pure',
  'shine',
  'heart',
  'trust',
  'gaze',
  'cheer',
  'vivid',
  'bloom',
  'honor',
  'sweet',
  'gentle',
  'rejoice',
  'grin',
  'smirk',
  'spunk',
  'charm',
  'chill',
  'bliss',
  'fun',
  'muse',
  'glimpse',
  'glow',
  'charm',
  'bold',
  'wise',
  'calm',
  'warm',
  'soul',
  'pure',
  'free',
  'kind',
  'play',
  'cool',
  'fair',
  'true',
  'care',
  'pure',
  'ease',
  'tame',
  'calm',
  'mild',
  'rare',
  'soft',
  'live',
  'silk',
  'glim',
  'gala',
  'nice',
  'rich',
  'love',
  'mild',
  'pure',
  'lily',
  'warm',
  'smile',
  'fine',
  'glow',
  'wish',
  'fair',
  'easy',
  'open',
  'calm',
  'free',
  'true',
  'bold',
  'dear',
  'care',
  'kind',
  'muse',
  'gaze',
  'play',
  'cool',
  'tame',
  'soft',
  'true',
  'calm',
  'kind',
  'pure',
  'fine',
  'rich',
  'mild',
  'free',
  'nice',
  'fair',
  'bold',
  'glow',
  'wish',
  'gala',
  'easy',
  'live',
  'lily',
  'ease',
  'smile',
  'glim',
  'open',
  'warm',
  'silk',
  'glimpse',
  'spunk',
  'hug',
  'heart',
  'trust',
  'brave'
];
