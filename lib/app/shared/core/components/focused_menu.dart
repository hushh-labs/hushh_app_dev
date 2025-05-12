library focused_menu;

import 'dart:ui';

import 'package:flutter/material.dart';

class FocusedMenuHolder extends StatefulWidget {
  final Widget child;
  final double? menuItemExtent;
  final double? menuWidth;
  final List<FocusedMenuItem> menuItems;
  final bool? animateMenuItems;
  final BoxDecoration? menuBoxDecoration;
  final Function onPressed;
  final Duration? duration;
  final double? blurSize;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;
  final bool isme;

  /// Open with tap instead of long press.
  final bool openWithTap;

  const FocusedMenuHolder(
      {Key? key,
      required this.child,
      required this.onPressed,
      required this.menuItems,
      this.duration,
      required this.isme,
      this.menuBoxDecoration,
      this.menuItemExtent,
      this.animateMenuItems,
      this.blurSize,
      this.blurBackgroundColor,
      this.menuWidth,
      this.bottomOffsetHeight,
      this.menuOffset,
      this.openWithTap = false})
      : super(key: key);

  @override
  _FocusedMenuHolderState createState() => _FocusedMenuHolderState();
}

class _FocusedMenuHolderState extends State<FocusedMenuHolder> {
  GlobalKey containerKey = GlobalKey();
  Offset childOffset = const Offset(0, 0);
  Size? childSize;

  getOffset() {
    RenderBox renderBox =
        containerKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    setState(() {
      childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: containerKey,
        onTap: () async {
          // widget.onPressed();
          /* if (!widget.openWithTap) {
            await openMenu(context);
          }*/
        },
        onLongPress: () async {
          await widget.onPressed();
          if (widget.onPressed()) {
            await openMenu(context);
          }
        },
        child: widget.child);
  }

  Future openMenu(BuildContext context) async {
    getOffset();
    await Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration:
                widget.duration ?? const Duration(milliseconds: 100),
            pageBuilder: (context, animation, secondaryAnimation) {
              animation = Tween(begin: 0.0, end: 1.0).animate(animation);
              return FadeTransition(
                  opacity: animation,
                  child: FocusedMenuDetails(
                    ismean: widget.isme,
                    itemExtent: widget.menuItemExtent,
                    menuBoxDecoration: widget.menuBoxDecoration,
                    child: widget.child,
                    childOffset: childOffset,
                    childSize: childSize,
                    menuItems: widget.menuItems,
                    blurSize: widget.blurSize,
                    menuWidth: widget.menuWidth,
                    blurBackgroundColor: widget.blurBackgroundColor,
                    animateMenu: widget.animateMenuItems ?? true,
                    bottomOffsetHeight: widget.bottomOffsetHeight ?? 0,
                    menuOffset: widget.menuOffset ?? 0,
                  ));
            },
            fullscreenDialog: true,
            opaque: false));
  }
}

class FocusedMenuDetails extends StatelessWidget {
  final List<FocusedMenuItem> menuItems;
  final BoxDecoration? menuBoxDecoration;
  final Offset childOffset;
  final double? itemExtent;
  final Size? childSize;
  final Widget child;
  final bool animateMenu;
  final bool ismean;
  final double? blurSize;
  final double? menuWidth;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;

  const FocusedMenuDetails(
      {Key? key,
      required this.menuItems,
      required this.child,
      required this.childOffset,
      required this.childSize,
      required this.menuBoxDecoration,
      required this.itemExtent,
      required this.animateMenu,
      required this.blurSize,
      required this.blurBackgroundColor,
      required this.menuWidth,
      this.bottomOffsetHeight,
      this.menuOffset,
      required this.ismean})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final maxMenuHeight = size.height * 0.45;
    final listHeight = menuItems.length * (itemExtent ?? 50.0);
    final maxMenuWidth = menuWidth ?? (size.width * 0.70);
    final menuHeight = listHeight < maxMenuHeight ? listHeight : maxMenuHeight;
    final leftOffset =
        5.0 /*(childOffset.dx+maxMenuWidth ) < size.width ? childOffset.dx: (childOffset.dx-maxMenuWidth+childSize!.width)*/;
    /*final topOffset =142.0*/ /* (childOffset.dy + menuHeight + childSize!.height) < size.height - bottomOffsetHeight! ? childOffset.dy + childSize!.height + menuOffset! : childOffset.dy - menuHeight - menuOffset!*/ /*;*/
    final topOffset = ismean
        ? (childOffset.dy + menuHeight + childSize!.height) <=
                (size.height - bottomOffsetHeight!)
            ? childOffset.dy + childSize!.height
            : childOffset.dy - menuHeight - (1.5 * menuOffset!)
        : (childOffset.dy + menuHeight + childSize!.height) <=
                (size.height - bottomOffsetHeight!)
            ? childOffset.dy + childSize!.height
            : childOffset.dy - menuHeight - menuOffset! - (menuOffset! / 2);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: blurSize ?? 5, sigmaY: blurSize ?? 5),
                child: Container(
                  color: (blurBackgroundColor ?? Colors.white).withOpacity(0.7),
                ),
              )),
          Positioned(
              top: topOffset,
              left: ismean
                  ? MediaQuery.of(context).size.width * 0.27
                  : leftOffset,
              child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 100),
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return Transform.scale(
                    scale: value,
                    alignment: Alignment.center,
                    child: child,
                  );
                },
                tween: Tween(begin: 0.0, end: 1.0),
                child: Container(
                  margin: const EdgeInsets.all(15),
                  width: maxMenuWidth,
                  height: menuHeight,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 0.1,
                            spreadRadius: 0.1)
                      ]),
                  child: ListView.builder(
                    itemCount: menuItems.length,
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      FocusedMenuItem item = menuItems[index];
                      Widget listItem = GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            item.onPressed();
                          },
                          child: Column(
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  height: itemExtent ?? 50.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        item.title,
                                        if (item.trailingIcon != null) ...[
                                          item.trailingIcon!
                                        ]
                                      ],
                                    ),
                                  )),
                              const Divider(
                                color: Colors.black12,
                                height: 0.5,
                                thickness: 0.5,
                              )
                            ],
                          ));
                      if (animateMenu) {
                        return listItem;
                      } else {
                        return listItem;
                      }
                    },
                  ),
                ),
              )),
          Positioned(
              top: childOffset.dy,
              left: childOffset.dx,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: AbsorbPointer(
                    absorbing: true,
                    child: SizedBox(
                        width: childSize!.width,
                        height: childSize!.height,
                        child: child)),
              )),
        ],
      ),
    );
  }
}

class FocusedMenuItem {
  Color? backgroundColor;
  Widget title;
  Widget? trailingIcon;
  Function onPressed;

  FocusedMenuItem(
      {this.backgroundColor,
      required this.title,
      this.trailingIcon,
      required this.onPressed});
}
