import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ganjoor/models/poem/poem_model_complete.dart';
import 'package:ganjoor/models/poet/poet_complete.dart';
import 'package:ganjoor/services/request.dart';
import 'package:ganjoor/widgets/loading.dart';

class PoemDetail extends StatefulWidget {
  final int id;
  const PoemDetail({Key? key, required this.id}) : super(key: key);

  @override
  State<PoemDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<PoemDetail> {
  PoemCompleteModel? _poem;
  PoetCompleteModel? _poet;
  double _fontSize = 18;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: _poem != null && _poet != null
            ? ListView(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
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
                              padding: const EdgeInsets.symmetric(vertical: 8),
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
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
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
                                  _poem!.rhythm.toString() != 'null'
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
                                                _poem!.rhythm,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.5,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
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
                    height: 0.5,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: List.generate(
                          _poem!.vers.length ~/ 2,
                          (index) => Column(
                                children: [
                                  Text(
                                    _poem!.vers[index * 2].text,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: _fontSize,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 25,
                                    ),
                                    child: Text(
                                      _poem!.vers[index * 2 + 1].text,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: _fontSize,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                    ),
                  )
                ],
              )
            : loading(),
      ),
    );
  }

  _getData() {
    Request('/api/ganjoor/poem/${widget.id}').get((data) {
      if (data != null) {
        setState(() {
          _poem = PoemCompleteModel.fromJson(data);
          _poet = PoetCompleteModel.fromJson(data['category']);
        });
      } else {
        AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.LEFTSLIDE,
            headerAnimationLoop: false,
            title: 'خطا',
            aligment: Alignment.center,
            desc:
                'هنگام برقراری ارتباط با سرور با خطا مواجه شدیم لطفا اینترنت خود را چک کرده و مجددا تلاش کنید',
            btnOkText: 'تلاش مجدد',
            btnOkColor: Colors.green,
            btnOkOnPress: _getData,
            onDissmissCallback: (e) {
              Navigator.of(context).pop();
            }).show();
      }
    });
  }
}
