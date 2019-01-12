import 'dart:math';
import 'package:card_swipe/AnchoredOverlay.dart';
import 'package:card_swipe/matches.dart';
import 'package:card_swipe/photos.dart';
import 'package:flutter/material.dart';

class DraggableCard extends StatefulWidget {
  final DateMatch match;

  const DraggableCard({Key key, this.match}) : super(key: key);

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with TickerProviderStateMixin {
  Decision decision;
  GlobalKey profileCardKey = GlobalKey(debugLabel: 'profile_card');
  Offset cardOffset = const Offset(0, 0);
  Offset dragStart;
  Offset dragPosition;
  Offset slideBackStart;
  AnimationController slideBackAnimation;
  Tween<Offset> slideOutTween;
  AnimationController slideOutAnimation;

  @override
  void initState() {
    super.initState();
    slideBackAnimation = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 1000),
    )
      ..addListener(() => setState(() {
            cardOffset = Offset.lerp(
              slideBackStart,
              const Offset(0, 0),
              Curves.elasticOut.transform(slideBackAnimation.value),
            );
          }))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            slideBackStart = null;
            dragPosition = null;
          });
        }
      });

    slideOutAnimation = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )
      ..addListener(() {
        setState(() {
          cardOffset = slideOutTween.evaluate(slideOutAnimation);
        });
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            dragPosition = null;
            slideOutTween = null;
            cardOffset = const Offset(0, 0);
            widget.match.reset();
          });
        }
      });

    widget.match.addListener(onMatchChange);
    decision = widget.match.decision;
  }

  @override
  void didUpdateWidget(DraggableCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.match != oldWidget.match) {
      oldWidget.match.removeListener(onMatchChange);
      widget.match.addListener(onMatchChange);
    }
  }

  @override
  void dispose() {
    slideBackAnimation.dispose();
    widget.match.removeListener(onMatchChange);
    super.dispose();
  }

  void onMatchChange() {
    if (widget.match.decision != decision) {
      switch (widget.match.decision) {
        case Decision.nope:
          _slideLeft();
          break;
        case Decision.like:
          _slideRight();
          break;
        case Decision.superLike:
          _slideUp();
          break;
        default:
          break;
      }
    }

    decision = widget.match.decision;
  }

  Offset _chooseRandomDragStart() {
    final cardContext = profileCardKey.currentContext;
    final cardTopLeft = (cardContext.findRenderObject() as RenderBox)
        .localToGlobal(Offset(0, 0));
    final dragStartY =
        cardContext.size.height * (Random().nextDouble() < 0.5 ? 0.25 : 0.75) +
            cardTopLeft.dy;

    return Offset(cardContext.size.width / 2 + cardTopLeft.dx, dragStartY);
  }

  void _slideLeft() {
    final screenWidth = context.size.width;
    dragStart = _chooseRandomDragStart();
    slideOutTween = Tween(begin: Offset(0, 0), end: Offset(2 * screenWidth, 0));
    slideOutAnimation.forward(from: 0);
  }

  void _slideRight() {
    final screenWidth = context.size.width;
    dragStart = _chooseRandomDragStart();
    slideOutTween =
        Tween(begin: Offset(0, 0), end: Offset(-2 * screenWidth, 0));
    slideOutAnimation.forward(from: 0);
  }

  void _slideUp() {
    final screenHeight = context.size.height;
    dragStart = _chooseRandomDragStart();
    slideOutTween =
        Tween(begin: Offset(0, 0), end: Offset(0, -2 * screenHeight));
    slideOutAnimation.forward(from: 0);
  }

  void _onPanStart(DragStartDetails details) {
    dragStart = details.globalPosition;

    if (slideBackAnimation.isAnimating) {
      slideBackAnimation.stop(canceled: true);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      dragPosition = details.globalPosition;
      cardOffset = dragPosition - dragStart;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final dragVector = cardOffset / cardOffset.distance;

    final itsInNopRegion = (cardOffset.dx / context.size.width) < -0.40;
    final itsInLikeRegion = (cardOffset.dx / context.size.width) > 0.40;
    final itsInSuperLikeRegion = (cardOffset.dy / context.size.height) > -0.40;

    setState(() {
      if (itsInNopRegion || itsInLikeRegion) {
        slideOutTween = Tween(
            begin: cardOffset, end: (dragVector * (2 * context.size.width)));
        slideOutAnimation.forward(from: 0);
      } else if (itsInSuperLikeRegion) {
        slideOutTween = Tween(
            begin: cardOffset, end: (dragVector * (2 * context.size.height)));
        slideOutAnimation.forward(from: 0);
      } else {
        slideBackStart = cardOffset;
        slideBackAnimation.forward(from: 0);
      }
    });
  }

  double _rotation(Rect dragBounds) {
    if (dragStart != null) {
      final rotationCornerMultiplier =
          dragStart.dy >= dragBounds.top + (dragBounds.height / 2) ? -1 : 1;
      return (pi / 8) *
          (cardOffset.dx / dragBounds.width) *
          rotationCornerMultiplier;
    } else {
      return 0;
    }
  }

  Offset _rotationOrigin(Rect dragBounds) {
    if (dragStart != null) {
      return dragStart - dragBounds.topLeft;
    } else {
      return const Offset(0, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnchoredOverlay(
      showOverlay: true,
      child: Center(),
      overlayBuilder: (BuildContext context, Rect anchorBounds, Offset anchor) {
        return CenterAbout(
          position: anchor,
          child: Transform(
            transform:
                Matrix4.translationValues(cardOffset.dx, cardOffset.dy, 0.0)
                  ..rotateZ(_rotation(anchorBounds)),
            origin: _rotationOrigin(anchorBounds),
            child: Container(
              key: profileCardKey,
              width: anchorBounds.width,
              height: anchorBounds.height,
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: ProfileCard(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProfileCard extends StatefulWidget {
  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  Widget _buildBackground() {
    return PhotoBrowser(
      photoAssetPaths: [
        'assets/foto_1.jpg',
        'assets/foto_2.jpg',
        'assets/foto_3.jpg',
        'assets/foto_4.jpg',
        'assets/foto_5.jpeg',
      ],
      visiblePhotoIndex: 0,
    );
  }

  Widget _buildProfileSynopsis() {
    return Positioned(
      left: 0,
      bottom: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black87],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Anya Arguelles',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'PhD Student',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.info,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Color(0x11000000), blurRadius: 5, spreadRadius: 2),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[_buildBackground(), _buildProfileSynopsis()],
          ),
        ),
      ),
    );
  }
}
