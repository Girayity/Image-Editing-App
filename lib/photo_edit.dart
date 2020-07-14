import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:ui' as ui;
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

class PhotoEdit extends StatefulWidget {
  @override
  _PhotoEditState createState() => _PhotoEditState();
}

class _PhotoEditState extends State<PhotoEdit>
    with SingleTickerProviderStateMixin {
  File _secilenResim;
  final _picker = ImagePicker();
  int _selectedPage = 0;
  var image1, image2, image3, image4;
  final _boundaryKey = GlobalKey();
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
  final ValueNotifier<Matrix4> notifier1 = ValueNotifier(Matrix4.identity());
  final ValueNotifier<Matrix4> notifier2 = ValueNotifier(Matrix4.identity());
  final ValueNotifier<Matrix4> notifier3 = ValueNotifier(Matrix4.identity());
  final ValueNotifier<Matrix4> notifier4 = ValueNotifier(Matrix4.identity());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade100,
      appBar: AppBar(
        actions: <Widget>[
          SingleChildScrollView(
            child: PopupMenuButton(
              //key: popupmenuItem,
              onSelected: _selectMenuItem,
              color: Colors.red.shade200,
              elevation: 4,
              icon: Icon(Icons.add_photo_alternate),
              initialValue: 4,
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/sapka.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/isik.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/kar.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/kardanadam.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ];
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.redAccent),
        child: BottomNavigationBar(
          currentIndex: _selectedPage,
          onTap: _changePage,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.edit),
              title: Text(
                'EDIT',
                style: TextStyle(fontSize: 14, fontFamily: 'Dosis', fontWeight: FontWeight.bold),
              ),
            ),
            /* BottomNavigationBarItem(
              icon: Icon(Icons.rotate_left),
              title: Text(
                'Rotate',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
              ),
            ), */
            BottomNavigationBarItem(
              icon: Icon(Icons.save_alt),
              title: Text(
                'SAVE',
                style: TextStyle(fontSize: 14, fontFamily: 'Dosis', fontWeight: FontWeight.bold),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.delete),
              title: Text(
                'DELETE',
                style: TextStyle(fontSize: 14, fontFamily: 'Dosis', fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      body: showPage(_selectedPage),
    );
  }

  Future _addPhotoFromGallery() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    final File resim = File(pickedFile.path);

    setState(() {
      _secilenResim = resim;
    });
  }

  void _takePhoto() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    final File resim = File(pickedFile.path);

    if (resim != null) {
      setState(() {
        _secilenResim = resim;
      });
    } else {}
  }

  void _deleteImage() {
    setState(() {
      _secilenResim = null;
      image1 = null;
      image2 = null;
      image3 = null;
      image4 = null;
    });
  }

  Future _saveImageToGallery() async {
    /* _scrFile = null;
                            screenshotController.capture().then((File scr) {
                              //Capture Done
                              setState(() {
                                _scrFile = scr;
                              });
                            }).catchError((onError) {
                              print(onError);
                            });
                            await ImageGallerySaver.saveImage(_scrFile.readAsBytesSync()); */
    RenderRepaintBoundary boundary =
        _boundaryKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 5.0);
    var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
    print(pngBytes);
    //await ImageGallerySaver.saveImage(pngBytes.readAsBytesSync());
    await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
  }

  void _changePage(int index) {
    setState(() {
      _selectedPage = index;
    });
    if (_selectedPage == 0) {
      page1();
    } else if (_selectedPage == 1) {
      _saveDialog(context);
    } else if (_selectedPage == 2) {
      _deleteDialog(context);
    }
  }

  Widget showPage(int _selectedPage) {
    if (_selectedPage == 0) {
      return page1();
    } else if (_selectedPage == 1) {
      return _secilenResim == null ? page3() : page1();
    } else if (_selectedPage == 2) {
      return _secilenResim == null ? page4() : page1();
    }
  }

  Widget page1() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _secilenResim == null ? () => _showUploadDialog(context) : () {},
      child: RepaintBoundary(
        key: _boundaryKey,
        child: Stack(
          children: <Widget>[
            _secilenResim == null
                ? Center(
                    child: Text("Tap here to Upload Image"),
                  )
                : MatrixGestureDetector(
                    onMatrixUpdate: (m, tm, sm, rm) {
                      notifier.value = m;
                    },
                    child: AnimatedBuilder(
                      animation: notifier,
                      builder: (ctx, child) {
                        return Transform(
                          transform: notifier.value,
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Image.file(_secilenResim),
                          ),
                        );
                      },
                    ),
                  ),
            Positioned(
              child: MatrixGestureDetector(
                onMatrixUpdate: (m1, tm1, sm1, rm1) {
                  notifier1.value = m1;
                },
                child: AnimatedBuilder(
                  animation: notifier1,
                  builder: (ctx1, child) {
                    return Transform(
                      transform: notifier1.value,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: image1,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              child: MatrixGestureDetector(
                onMatrixUpdate: (m2, tm2, sm2, rm2) {
                  notifier2.value = m2;
                },
                child: AnimatedBuilder(
                  animation: notifier2,
                  builder: (ctx2, child) {
                    return Transform(
                      transform: notifier2.value,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: image2,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              child: MatrixGestureDetector(
                onMatrixUpdate: (m3, tm3, sm3, rm3) {
                  notifier3.value = m3;
                },
                child: AnimatedBuilder(
                  animation: notifier3,
                  builder: (ctx3, child) {
                    return Transform(
                      transform: notifier3.value,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: image3,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              child: MatrixGestureDetector(
                onMatrixUpdate: (m4, tm4, sm4, rm4) {
                  notifier4.value = m4;
                },
                child: AnimatedBuilder(
                  animation: notifier4,
                  builder: (ctx4, child) {
                    return Transform(
                      transform: notifier4.value,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: image4,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget page3() {
    return Container(
      child: Center(
        child: _secilenResim == null
            ? Text("Please upload an image before trying to save")
            : Image.file(_secilenResim),
      ),
    );
  }

  Widget page4() {
    return Container(
      child: Center(
        child: _secilenResim == null
            ? Text("There is nothing to delete")
            : Image.file(_secilenResim),
      ),
    );
  }

  void _deleteDialog(BuildContext contextD) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Container(
            alignment: Alignment.center,
            child: Text(
              "Are you sure?",
              style: TextStyle(
                fontSize: 24,
                fontFamily: "Dosis",
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: ButtonBar(
                    children: <Widget>[
                      OutlineButton(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                        onPressed: () {
                          _deleteImage();
                          Navigator.pop(context);
                        },
                        color: Colors.redAccent,
                        child: Text(
                          "Yes",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                            fontFamily: "Dosis",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      OutlineButton(
                        highlightElevation: 6,
                        borderSide:
                            BorderSide(color: Theme.of(context).accentColor),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: Colors.redAccent,
                        child: Text(
                          "No",
                          style: TextStyle(
                            fontFamily: "Dosis",
                            color: Theme.of(context).accentColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _saveDialog(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Container(
            alignment: Alignment.center,
            child: Text(
              "Do you want to save?",
              style: TextStyle(
                fontSize: 24,
                fontFamily: "Dosis",
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: ButtonBar(
                    children: <Widget>[
                      OutlineButton(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                        onPressed: () {
                          Navigator.pop(context);
                          showProgress(context);
                        },
                        color: Colors.redAccent,
                        child: Text(
                          "Yes",
                          style: TextStyle(
                            fontFamily: "Dosis",
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      OutlineButton(
                        highlightElevation: 6,
                        borderSide:
                            BorderSide(color: Theme.of(context).accentColor),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: Colors.redAccent,
                        child: Text(
                          "No",
                          style: TextStyle(
                            fontFamily: "Dosis",
                            color: Theme.of(context).accentColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showUploadDialog(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ButtonBar(
                      children: <Widget>[
                        OutlineButton(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                          onPressed: () {
                            Navigator.pop(context);
                            _addPhotoFromGallery();
                          },
                          color: Colors.redAccent,
                          child: Text(
                            "Upload From Gallery",
                            style: TextStyle(
                              fontFamily: "Dosis",
                              color: Theme.of(context).primaryColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        OutlineButton(
                          highlightElevation: 6,
                          borderSide:
                              BorderSide(color: Theme.of(context).accentColor),
                          onPressed: () {
                            Navigator.pop(context);
                            _takePhoto();
                          },
                          color: Colors.redAccent,
                          child: Text(
                            "Take a Photo",
                            style: TextStyle(
                              fontFamily: "Dosis",
                              color: Theme.of(context).accentColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  _selectMenuItem(int value) {
    setState(() {
      if (value == 0) {
        debugPrint("0");
        image1 = Image.asset('assets/images/sapka.png');
      } else if (value == 1) {
        debugPrint("1");
        image2 = Image.asset('assets/images/isik.png');
      } else if (value == 2) {
        debugPrint("2");
        image3 = Image.asset('assets/images/kar.png');
      } else if (value == 3) {
        debugPrint("3");
        image4 = Image.asset('assets/images/kardanadam.png');
      }
    });
  }

  Future<void> showProgress(BuildContext context) async {
    await showDialog(
        context: context,
        child: FutureProgressDialog(_saveImageToGallery(),
            message: Text('Saving...')));
  }
}
/* List<Positioned> createPositionedWidget(_count) {
    var positionedWidgets = <Positioned>[];
    var list = new List<int>.generate(_count, (index) => index + 1);

    list.forEach((i) {
      var positionedWidget = Positioned(
        child: MatrixGestureDetector(
          onMatrixUpdate: (m, tm, sm, rm) {
            notifier.value = m;
          },
          child: AnimatedBuilder(
            animation: notifier,
            builder: (ctx, child) {
              return Transform(
                transform: notifier.value,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: image,
                ),
              );
            },
          ),
        ),
      );
      setState(() {
        positionedWidgets.add(positionedWidget);
      });
    });
    debugPrint(_count.toString());
    debugPrint("dizi:" + positionedWidgets.length.toString());
    /* debugPrint(positionedWidgets[2].toString());
    debugPrint(positionedWidgets[0].toString());
    debugPrint(image.toString()); */
    return positionedWidgets;
  } */