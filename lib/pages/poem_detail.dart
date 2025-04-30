import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:sheidaie/main.dart';
import 'package:sheidaie/models/poem/poem_model_complete.dart';
import 'package:sheidaie/models/poet/poet_complete.dart';
import 'package:sheidaie/models/recitation/vers_position.dart';
import 'package:sheidaie/models/recitation/recitation.dart';
import 'package:sheidaie/services/ganjoor_service.dart';
import 'package:sheidaie/services/request.dart';
import 'package:sheidaie/widgets/loading.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';

class PoemDetail extends StatefulWidget {
  final int id;
  const PoemDetail({super.key, required this.id});

  @override
  State<PoemDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<PoemDetail> {
  int _vers = 0;
  double _fontSize = 18;
  List<RecitationModel>? _recitations;
  PoemCompleteModel? _poem;
  PoetCompleteModel? _poet;
  bool _isPlay = false;
  bool _thisPoemIsPlay = false;
  late StreamSubscription _positionStream;
  late StreamSubscription _playingStream;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    _getData();
    _audioPlayer = musicPlayer.getAudioPlayer();
    _positionStream = _audioPlayer.positionStream.listen((Duration p) {
      setState(() {
        _vers = musicPlayer.vers;
      });
    });

    _playingStream = _audioPlayer.playingStream.listen((e) {
      setState(() {
        if (musicPlayer.poem != null) {
          if (musicPlayer.poem!.id == _poem!.id) {
            _isPlay = e;
          }
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _positionStream.cancel();
    _playingStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (musicPlayer.poem == _poem) {
      _isPlay = musicPlayer.isPlay;
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: _poem != null && _poet != null
              ? ListView(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                padding: EdgeInsets.zero,
                                alignment: Alignment.centerRight,
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              Text(
                                _poem!.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                _poem!.excerpt,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            _poet!.imageUrl,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        _poet!.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _poem!.source.toString() != 'null'
                                      ? Row(
                                          children: [
                                            const Text(
                                              'منبع : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              _poem!.source.toString(),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  _poem!.rhythm != null
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'وزن : ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                _poem!.rhythm!,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: GestureDetector(
                                      onTap: () {
                                        launchUrl(Uri.parse(
                                            GanjoorService.siteUrl +
                                                _poem!.url));
                                      },
                                      child: const Text(
                                        'نمایش در گنجور',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w700,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 0.2,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          _recitations!.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isPlay = !_isPlay;

                                      if (musicPlayer.poem != null) {
                                        _vers = 0;
                                        if (musicPlayer.poem!.id == _poem!.id) {
                                          if (!_isPlay) {
                                            musicPlayer.pause();
                                          } else {
                                            musicPlayer.resume();
                                          }
                                          return;
                                        }
                                      }

                                      musicPlayer.poem = _poem;
                                      musicPlayer.recitations = _recitations;
                                      musicPlayer.poet = _poet;
                                      musicPlayer.playMusic();
                                      musicPlayer.start();
                                      if (_audioPlayer.position ==
                                          Duration.zero) {
                                        _vers = 0;
                                      }
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: _isPlay
                                          ? Colors.black87
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _isPlay
                                            ? Colors.transparent
                                            : Colors.black45,
                                      ),
                                    ),
                                    child: Icon(
                                      _isPlay ? Icons.pause : Icons.play_arrow,
                                      color: _isPlay
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                )
                              : Container(),
                          Row(
                            children: const [
                              Text('الف'),
                              Icon(Icons.arrow_downward_sharp),
                            ],
                          ),
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: Slider(
                                value: _fontSize,
                                divisions: 100,
                                min: 12,
                                max: 32,
                                onChanged: (double newValue) {
                                  setState(() {
                                    _fontSize = newValue;
                                  });
                                },
                              ),
                            ),
                          ),
                          Row(
                            children: const [
                              Text(
                                'الف',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                ),
                              ),
                              Icon(
                                Icons.arrow_upward_sharp,
                                size: 28,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 0.4,
                      color: Colors.grey,
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 120),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: List.generate(
                            _poem!.vers.last.coupletIndex + 1,
                            (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: _poem!.vers
                                    .where((element) =>
                                        element.coupletIndex == index)
                                    .map((e) {
                                  if (musicPlayer.poem != null) {
                                    if (musicPlayer.poem!.id == _poem!.id) {
                                      _thisPoemIsPlay = true;
                                    }
                                  }

                                  return GestureDetector(
                                    onTap: () {
                                      if (_thisPoemIsPlay) {
                                        for (var i = 0;
                                            i <
                                                musicPlayer
                                                    .versPositions.length;
                                            i++) {
                                          VersPositionModel v =
                                              musicPlayer.versPositions[i];
                                          if (e.vOrder == 0) {
                                            _audioPlayer.seek(
                                                const Duration(seconds: 0));
                                          } else if (e.vOrder - 1 == v.id) {
                                            _audioPlayer.seek(Duration(
                                                milliseconds: v.position + 1));
                                          }
                                        }
                                      }
                                    },
                                    child: Text(
                                      e.text,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: _fontSize,
                                        fontWeight: e.vOrder == _vers + 1 &&
                                                _thisPoemIsPlay
                                            ? FontWeight.w800
                                            : FontWeight.w500,
                                        color: e.vOrder <= _vers + 1 &&
                                                _thisPoemIsPlay
                                            ? Colors.blue
                                            : Colors.black,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    CommentTreeWidget({
                      'id': 1,
                      'name': 'armin'
                    }, [
                      {'id': 2, 'name': 'benyamin1'},
                      {'id': 2, 'name': 'benyamin1'}
                    ],
                        avatarRoot: (context, Map value) => PreferredSize(
                              preferredSize: Size.fromRadius(18),
                              child: Container(
                                padding: EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  value['name'][0],
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        avatarChild: (context, Map value) => PreferredSize(
                              preferredSize: Size.fromRadius(18),
                              child: Container(
                                padding: EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  value['name'][0],
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        contentChild: (context, data) {
                          return Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                color: Colors.red,
                              )
                            ],
                          );
                        },
                        contentRoot: (context, Map data) {
                          return Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                color: Colors.blue,
                              )
                            ],
                          );
                        }),
                  ],
                )
              : loading(),
        ),
      ),
    );
  }

  _getData() {
    Request('/api/ganjoor/poem/${widget.id}').get((data) {
      if (data != null) {
        setState(() {
          _poem = PoemCompleteModel.fromJson(data);
          _poet = PoetCompleteModel.fromJson(data['category']);
          _recitations = data['recitations']
              .map<RecitationModel>((e) => RecitationModel.fromJson(e))
              .toList();

          if (musicPlayer.poem != null) {
            if (musicPlayer.poem!.id == _poem!.id) {
              _isPlay = musicPlayer.isPlay;
            }
          }
        });
      } else {
        AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.leftSlide,
            headerAnimationLoop: false,
            title: 'خطا',
            alignment: Alignment.center,
            desc:
                'هنگام برقراری ارتباط با سرور با خطا مواجه شدیم لطفا اینترنت خود را چک کرده و مجددا تلاش کنید',
            btnOkText: 'تلاش مجدد',
            btnOkColor: Colors.green,
            btnOkOnPress: _getData,
            onDismissCallback: (e) {
              if (e == DismissType.modalBarrier) {
                Navigator.of(context).pop();
              }
            }).show();
      }
    });
  }
}
