import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:drag_and_drop_lists/drag_and_drop_builder_parameters.dart';

class DragAndDropListTarget extends StatefulWidget {
  final Widget child;
  final DragAndDropBuilderParameters parameters;
  final Function(DragAndDropListInterface newOrReordered, DragAndDropListTarget receiver) onDropOnLastTarget;

  DragAndDropListTarget({this.child, @required this.parameters, @required this.onDropOnLastTarget, Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DragAndDropListTarget();
}

class _DragAndDropListTarget extends State<DragAndDropListTarget> with TickerProviderStateMixin {
  DragAndDropListInterface _hoveredDraggable;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            AnimatedSize(
              duration: Duration(milliseconds: widget.parameters.listSizeAnimationDuration),
              vsync: this,
              alignment: Alignment.bottomCenter,
              child: _hoveredDraggable != null
                  ? Opacity(
                      opacity: widget.parameters.listGhostOpacity,
                      child: widget.parameters.listGhost ??
                          _hoveredDraggable.generateWidget(widget.parameters),
                    )
                  : Container(),
            ),
            widget.child ??
                Container(
                  height: 110,
                ),
          ],
        ),
        Positioned.fill(
          child: DragTarget<DragAndDropListInterface>(
            builder: (context, candidateData, rejectedData) {
              if (candidateData != null && candidateData.isNotEmpty) {}
              return Container();
            },
            onWillAccept: (incoming) {
              setState(() {
                _hoveredDraggable = incoming;
              });
              return true;
            },
            onLeave: (incoming) {
              setState(() {
                _hoveredDraggable = null;
              });
            },
            onAccept: (incoming) {
              setState(() {
                if (widget.onDropOnLastTarget != null) widget.onDropOnLastTarget(incoming, widget);
                _hoveredDraggable = null;
              });
            },
          ),
        ),
      ],
    );
  }
}
