import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Offset _startLastOffset = Offset.zero;
  Offset _lastOffset = Offset.zero;
  Offset _currentOffset = Offset.zero;
  double _lastScale = 1.0;
  double _currentScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: this._buildBody(context),
    );
  }

  GestureDetector _buildBody(BuildContext context) {
    return GestureDetector(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          this._transformScaleAndTranslate(),
          this._positionedStatusBar(context),
          this._positionedInkWellAndInkResponse(context),
        ],
      ),
      onScaleStart: this._onScaleStart,
      onScaleUpdate: this._onScaleUpdate,
      onDoubleTap: this._onDoubleTap,
      onLongPress: this._onLongPress,
    );
  }

  Transform _transformScaleAndTranslate() {
    return Transform.scale(
      scale: this._currentScale,
      child: Transform.translate(
        offset: this._currentOffset,
        child: Image(
          image: AssetImage('assets/images/elephant.jpg'),
        ),
      ),
    );
  }

  Positioned _positionedStatusBar(BuildContext context) {
    return Positioned(
        top: 0.0,
        width: MediaQuery.of(context).size.width,
        child: Container(
          color: Colors.white54,
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Scale: ${this._currentScale.toStringAsFixed(4)}',
              ),
              Text('Current: ${this._currentOffset}'),
            ],
          ),
        ));
  }

  void _onScaleStart(ScaleStartDetails details) {
    print('ScaleStartDetails: $details');

    this._startLastOffset = details.focalPoint;
    this._lastOffset = this._currentOffset;
    this._lastScale = this._currentScale;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    print('ScaleUpdateDetails: $details - Scale: ${details.scale}');

    if (details.scale != 1.0) {
      double currentScale = this._lastScale * details.scale;
      if (currentScale < 0.5) {
        currentScale = 0.5;
      }
      setState(() {
        this._currentScale = currentScale;
      });
      print('_scale: ${this._currentScale} - _lastScale: ${this._lastScale}');
    } else if (details.scale == 1.0) {
      Offset offsetAdjustedForScale =
          (this._startLastOffset - this._lastOffset) / this._lastScale;
      Offset currentOffset =
          details.focalPoint - (offsetAdjustedForScale * this._currentScale);
      setState(() {
        this._currentOffset = currentOffset;
      });
      print(
          'offsetAdjustedForScale: $offsetAdjustedForScale - _currentOffset: ${this._currentOffset}');
    }
  }

  void _onDoubleTap() {
    print('onDoubleTap');

    double currentScale = this._lastScale * 2.0;
    if (currentScale > 16.0) {
      currentScale = 1.0;
      this._resetToDefaultValues();
    }
    this._lastScale = currentScale;
    setState(() {
      this._currentScale = currentScale;
    });
  }

  void _onLongPress() {
    print('onLongPress');

    setState(() {
      this._resetToDefaultValues();
    });
  }

  void _resetToDefaultValues() {
    this._startLastOffset = Offset.zero;
    this._lastOffset = Offset.zero;
    this._currentOffset = Offset.zero;
    this._lastScale = 1.0;
    this._currentScale = 1.0;
  }

  Positioned _positionedInkWellAndInkResponse(BuildContext context) {
    return Positioned(
        top: 50.0,
        width: MediaQuery.of(context).size.width,
        child: Container(
          color: Colors.white54,
          height: 56.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              InkWell(
                child: Container(
                  height: 48.0,
                  width: 128.0,
                  color: Colors.black12,
                  child: Icon(
                    Icons.touch_app,
                    size: 32.0,
                  ),
                ),
                splashColor: Colors.lightGreenAccent,
                highlightColor: Colors.lightBlueAccent,
                onTap: this._setScaleSmall,
                onDoubleTap: this._setScaleBig,
                onLongPress: this._onLongPress,
              ),
              InkResponse(
                child: Container(
                  height: 48.0,
                  width: 128.0,
                  color: Colors.black12,
                  child: Icon(
                    Icons.touch_app,
                    size: 32.0,
                  ),
                ),
                splashColor: Colors.lightGreenAccent,
                highlightColor: Colors.lightBlueAccent,
                onTap: this._setScaleSmall,
                onDoubleTap: this._setScaleBig,
                onLongPress: this._onLongPress,
              ),
            ],
          ),
        ));
  }

  void _setScaleSmall() {
    setState(() {
      this._currentScale = 0.5;
    });
  }

  void _setScaleBig() {
    setState(() {
      this._currentScale = 16.0;
    });
  }
}
