import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ganjoor/main.dart';
import 'package:ganjoor/models/poet/poet_complete.dart';
import 'package:ganjoor/widgets/loading.dart';
import 'package:ganjoor/widgets/poet_detail/app_bar.dart';
import 'package:miniplayer/miniplayer.dart';
import 'dart:math' as math;
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ganjoor/models/poem/poem_model_complete.dart';
import 'package:ganjoor/models/recitation/recitation.dart';
import 'package:ganjoor/models/position_data.dart';

class MusicPlayer extends StatefulWidget {
  PoemCompleteModel? poem;
  PoetCompleteModel? poet;
  List<RecitationModel>? recitations;

  MusicPlayer({this.poem, this.recitations, this.poet});
  double _minHeight = 0;
  Function _state = () {};
  Function playMusic = () {};
  Function addListener = () {};
  Function pause = () {};
  Function resume = () {};
  bool isPlay = false;
  final MiniplayerController _controller = MiniplayerController();

  void start() {
    _minHeight = 100;
    _controller.animateToHeight(height: 100);
    Future.delayed(const Duration(milliseconds: 300), () {
      _state();
    });
  }

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
  // State<MusicPlayer> createState() => _asa();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final _player = AudioPlayer();

  late String audioArtist = '';
  late String coverUrl = '';
  late String mp3Url = '';
  late String poetName = '';
  late String title = '';
  // bool widget.isPlay = false;
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  _addListener(Function func) {
    _player.playingStream.listen((event) {
      print(event);
      func(event);
    });
  }

  void _play(Function func) async {
    setState(() {
      widget.isPlay = true;
    });
    mp3Url = widget.recitations![0].mp3Url;
    audioArtist = widget.recitations![0].artist;
    coverUrl = widget.poet!.imageUrl;
    poetName = widget.poet!.name;
    title = widget.poem!.title;

    await _player.setAudioSource(AudioSource.uri(Uri.parse(mp3Url)));
    _player.play();

    _player.playerStateStream.listen((state) {
      switch (state.processingState) {
        case ProcessingState.completed:
          setState(() {
            _player.pause();
            _player.seek(Duration.zero);
            widget.isPlay = false;
          });
          break;
      }
    });
    func();
  }

  void _pause() {
    _player.pause();
    setState(() {
      widget.isPlay = false;
    });
  }

  void _resume() {
    _player.play();
    setState(() {
      widget.isPlay = true;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.playMusic = _play;
    widget.addListener = _addListener;
    widget.isPlay = _player.playing;
    widget.pause = _pause;
    widget.resume = _resume;
  }

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    widget._state = () {
      setState(() {});
    };
    // if (audioArtist == '' ||
    //     coverUrl == '' ||
    //     mp3Url == '' ||
    //     poetName == '' ||
    //     title == '') {
    //   return Container();
    // }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Miniplayer(
        minHeight: widget._minHeight,
        maxHeight: height - 50,
        controller: widget._controller,
        backgroundColor: Color.fromARGB(255, 98, 88, 88),
        builder: (height, percentage) {
          int alpah = ((1 - (percentage / 0.4)) * 255).toInt();
          double balpah = ((percentage - 0.6) * 2.5);

          return widget._minHeight > 0
              ? Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 98, 88, 88),
                      border: Border.all(
                          color: const Color.fromARGB(255, 98, 88, 88),
                          width: 0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Stack(
                      children: [
                        percentage > 0.6
                            ? Align(
                                alignment: Alignment.topLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    widget._controller
                                        .animateToHeight(state: PanelState.MIN);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 22),
                                    child: Transform.rotate(
                                      angle: -math.pi / 2,
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.white
                                            .withAlpha((balpah * 255).toInt()),
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: (width - 36) * percentage +
                                      ((1 - percentage) * 80),
                                  height: percentage < 0.4 ? height - 10 : 250,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        coverUrl,
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                percentage < 0.4
                                    ? Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        width: width * 0.45,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              poetName,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                color: Colors.white
                                                    .withAlpha(alpah),
                                              ),
                                            ),
                                            Text(
                                              title,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                color: Colors.white
                                                    .withAlpha(alpah),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                percentage < 0.4
                                    ? Expanded(child: Container())
                                    : Container(),
                                percentage < 0.4
                                    ? GestureDetector(
                                        onTap: () {
                                          if (widget.isPlay) {
                                            _player.pause();
                                          } else {
                                            _player.play();
                                          }
                                          setState(() {
                                            widget.isPlay = !widget.isPlay;
                                          });
                                          // gSetState();
                                        },
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                widget.isPlay
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                size: 32,
                                                color: Colors.white
                                                    .withAlpha(alpah),
                                              ),
                                            ),
                                            // Padding(
                                            //   padding: const EdgeInsets.symmetric(
                                            //       horizontal: 8),
                                            //   child: GestureDetector(
                                            //     onTap: () {
                                            //       widget._controller
                                            //           .animateToHeight(height: 0);
                                            //       Future.delayed(
                                            //           const Duration(
                                            //               milliseconds: 290), () {
                                            //         setState(() {
                                            //           widget._minHeight = 0;
                                            //           _player.stop();
                                            //         });
                                            //       });
                                            //     },
                                            //     child: Icon(
                                            //       CupertinoIcons.xmark,
                                            //       size: 28,
                                            //       color: Colors.white
                                            //           .withAlpha(alpah),
                                            //     ),
                                            //   ),
                                            // )
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                            percentage > 0.6
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        poetName,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: balpah * 22,
                                          color: Colors.white.withAlpha(
                                              (balpah * 255).toInt()),
                                        ),
                                      ),
                                      Text(
                                        title,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: balpah * 18,
                                          color: Colors.white.withAlpha(
                                              (balpah * 255).toInt()),
                                        ),
                                      ),
                                      Text(
                                        audioArtist,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: balpah * 18,
                                          color: Colors.white.withAlpha(
                                              (balpah * 255).toInt()),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                            percentage > 0.6
                                ? StreamBuilder<PositionData>(
                                    stream: _positionDataStream,
                                    builder: ((context, snapshot) {
                                      final positionData = snapshot.data;

                                      // return Text(positionData!.position.toString());
                                      return Container(
                                        height: balpah * 50,
                                        padding: const EdgeInsets.all(8.0),
                                        child: ProgressBar(
                                          progressBarColor: Colors.white
                                              .withAlpha(
                                                  (balpah * 200).toInt()),
                                          thumbColor: Colors.white.withAlpha(
                                              (balpah * 255).toInt()),
                                          baseBarColor: Colors.white
                                              .withAlpha((balpah * 50).toInt()),
                                          timeLabelTextStyle: TextStyle(
                                            color: Colors.white.withAlpha(
                                                (balpah * 200).toInt()),
                                          ),
                                          bufferedBarColor: Colors.white
                                              .withAlpha(
                                                  (balpah * 100).toInt()),
                                          total: positionData?.duration ??
                                              Duration.zero,
                                          progress: positionData?.position ??
                                              Duration.zero,
                                          buffered:
                                              positionData?.bufferedPosition ??
                                                  Duration.zero,
                                          barHeight: 10,
                                          onSeek: _player.seek,
                                        ),
                                      );
                                    }))
                                : Container(),
                            percentage > 0.6
                                ? Container(
                                    padding: EdgeInsets.all(balpah * 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white
                                          .withAlpha((balpah * 255).toInt()),
                                      shape: BoxShape.circle,
                                    ),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (widget.isPlay) {
                                          _player.pause();
                                        } else {
                                          _player.play();
                                        }
                                        setState(() {
                                          widget.isPlay = !widget.isPlay;
                                        });
                                        // gSetState();
                                      },
                                      child: Icon(
                                        widget.isPlay
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        size: balpah * 48,
                                        color: Colors.black
                                            .withAlpha((balpah * 255).toInt()),
                                      ),
                                    ),
                                  )
                                : Container(),
                            percentage > 0.6
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: balpah * 8),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Icon(
                                        CupertinoIcons.music_mic,
                                        size: balpah * 34,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Container();
        },
      ),
    );
  }
}
