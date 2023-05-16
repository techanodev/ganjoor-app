import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ganjoor/models/poet/poet_complete.dart';
import 'package:ganjoor/models/recitation/vers_position.dart';
import 'package:ganjoor/services/request.dart';
import 'package:miniplayer/miniplayer.dart';
import 'dart:math' as math;
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ganjoor/models/poem/poem_model_complete.dart';
import 'package:ganjoor/models/recitation/recitation.dart';
import 'package:ganjoor/models/position_data.dart';
import 'package:xml/xml.dart';

class MusicPlayer extends StatefulWidget {
  PoemCompleteModel? poem;
  PoetCompleteModel? poet;
  List<RecitationModel>? recitations;
  List<VersPositionModel> versPositions = [];

  MusicPlayer({this.poem, this.recitations, this.poet});
  double _minHeight = 0;
  Function _state = () {};
  Function playMusic = () {};
  Function getAudioPlayer = () {};
  Function pause = () {};
  Function resume = () {};
  bool isPlay = false;
  int vser = 0;
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
}

class _MusicPlayerState extends State<MusicPlayer> {
  final _player = AudioPlayer();
  final Color _color = Color.fromARGB(255, 89, 89, 89);

  late String audioArtist = '';
  late String coverUrl = '';
  late String mp3Url = '';
  late String poetName = '';
  late String title = '';
  int recitationId = 0;

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  _getAudioPlayer() {
    return _player;
  }

  getVersPositionModel(int id) {
    Request('/api/audio/file/${id}.xml').get(parse: false, (data) {
      if (data == null) {
        getVersPositionModel(id);
        return;
      }
      widget.versPositions = XmlDocument.parse(data)
          .findAllElements('SyncInfo')
          .map((e) => VersPositionModel(
              id: int.parse(e.getElement('VerseOrder')!.text),
              position: int.parse(e.getElement('AudioMiliseconds')!.text)))
          .toList();
    });
  }

  void _changerecitation(int id) async {
    _player.stop();
    recitationId = id;
    getVersPositionModel(widget.recitations![recitationId].id);
    setState(() {
      mp3Url = widget.recitations![recitationId].mp3Url;
      audioArtist = widget.recitations![recitationId].artist;
      coverUrl = widget.poet!.imageUrl;
      poetName = widget.poet!.name;
      title = widget.poem!.title;
    });

    await _player.setAudioSource(AudioSource.uri(Uri.parse(mp3Url)));
    _player.play();
  }

  void _play() async {
    setState(() {
      widget.isPlay = true;
    });
    recitationId = 0;
    getVersPositionModel(widget.recitations![recitationId].id);
    mp3Url = widget.recitations![recitationId].mp3Url;
    audioArtist = widget.recitations![recitationId].artist;
    coverUrl = widget.poet!.imageUrl;
    poetName = widget.poet!.name;
    title = widget.poem!.title;

    await _player.setAudioSource(AudioSource.uri(Uri.parse(mp3Url)));
    _player.play();

    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _player.pause();
          _player.seek(Duration.zero);
          widget.isPlay = false;
        });
      }
    });
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

  void _versListenre() {
    _player.positionStream.listen((Duration p) {
      int v = 0;
      widget.versPositions.forEach((e) {
        if (e.position < p.inMilliseconds) {
          v = e.id;
        }
      });
      setState(() {
        widget.vser = v;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    widget.playMusic = _play;
    widget.getAudioPlayer = _getAudioPlayer;
    widget.isPlay = _player.playing;
    widget.pause = _pause;
    widget.resume = _resume;
    _versListenre();
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

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Miniplayer(
        minHeight: widget._minHeight,
        maxHeight: height - 50,
        controller: widget._controller,
        backgroundColor: _color,
        builder: (height, percentage) {
          int alpah = ((1 - (percentage / 0.4)) * 255).toInt();
          double balpah = ((percentage - 0.6) * 2.5);

          return widget._minHeight > 0
              ? Container(
                  decoration: BoxDecoration(
                      color: _color,
                      border: Border.all(color: _color, width: 0)),
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
                                        padding: const EdgeInsets.symmetric(
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
                                      child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: SimpleDialog(
                                                    backgroundColor: _color,
                                                    title: const Text(
                                                      'انتخاب خواننده',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 22,
                                                      ),
                                                    ),
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(15),
                                                      ),
                                                    ),
                                                    children: widget
                                                        .recitations!
                                                        .map(
                                                          (e) =>
                                                              SimpleDialogOption(
                                                            child: Text(
                                                              e.artist,
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 17,
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              int id = widget
                                                                  .recitations!
                                                                  .indexOf(e);
                                                              _changerecitation(
                                                                  id);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                                );
                                              });
                                        },
                                        icon: Icon(
                                          CupertinoIcons.music_mic,
                                          size: balpah * 34,
                                          color: Colors.white,
                                        ),
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
