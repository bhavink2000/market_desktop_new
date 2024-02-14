import 'package:get/get.dart';
import 'package:marketdesktop/customWidgets/appTextField.dart';
import 'package:marketdesktop/customWidgets/contextMenueBuilder.dart';
import 'package:marketdesktop/modelClass/getScriptFromSocket.dart';
import '../../../../constant/index.dart';
import '../../../../constant/utilities.dart';
import '../../../../modelClass/allSymbolListModelClass.dart';
import 'marketWatchController.dart';

class MarketWatchScreen extends BaseView<MarketWatchController> {
  const MarketWatchScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Visibility(
        visible: true,
        child: GestureDetector(
          onTap: () {
            // controller.focusNode.requestFocus();
            ContextMenuController.removeAny();
          },
          child: Container(
            // margin: EdgeInsets.symmetric(horizontal: 1.w),
            color: Colors.black,
            child: Column(
              children: [
                // headerViewContent(title: "Market Watch", isFromMarket: true),
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors().customGradient,
                    color: AppColors().whiteColor,
                  ),
                  height: 45,
                  child: Row(
                    children: [
                      Focus(focusNode: controller.tempFocus.value, child: Container()),
                      controller.exchangeTypeDropDown(controller.selectedExchange),
                      controller.allScriptListDropDown(),
                      if (controller.selectedExchange.value.isCallPut) controller.expiryTypeDropDown(),
                      if (controller.selectedExchange.value.isCallPut) controller.callPutTypeDropDown(),
                      if (controller.selectedExchange.value.isCallPut) controller.strikePriceTypeDropDown(),
                      searchBox(),
                      const Spacer(),
                      // GestureDetector(
                      //   onTap: () async {
                      //     controller.getSymbolListTabWise();
                      //     if (isMarketSocketConnected.value == false) {
                      //       await socket.connectSocket();
                      //       if (arrSymbolNames.isNotEmpty) {
                      //         var txt = {"symbols": arrSymbolNames};
                      //         socket.connectScript(jsonEncode(txt));
                      //       }
                      //     }
                      //     // if (isMarketSocketConnected.value) {
                      //     //   socket.channel?.sink.close(status.normalClosure);
                      //     //   isMarketSocketConnected.value = false;
                      //     // } else {
                      //     //   await socket.connectSocket();
                      //     //   if (arrSymbolNames.isNotEmpty) {
                      //     //     var txt = {"symbols": arrSymbolNames};
                      //     //     socket.connectScript(jsonEncode(txt));
                      //     //   }
                      //     // }
                      //     // controller.update();
                      //   },
                      //   child: controller.isSymbolListApiCall
                      //       ? Container(
                      //           width: 45,
                      //           height: 50,
                      //           padding: const EdgeInsets.all(14),
                      //           child: CircularProgressIndicator(
                      //             color: AppColors().blueColor,
                      //             strokeWidth: 2,
                      //           ),
                      //         )
                      //       : Container(
                      //           width: 50,
                      //           height: 50,
                      //           padding: const EdgeInsets.all(10),
                      //           child: Icon(Icons.refresh, color: AppColors().blueColor),
                      //         ),
                      // )
                    ],
                  ),
                ),
                Container(
                  height: 2,
                  color: AppColors().blueColor,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: controller.mainScroll,
                    child: Container(
                      width: controller.maxWidth,
                      child: Column(
                        children: [
                          Container(
                            height: 3.h,
                            color: AppColors().backgroundColor,
                            child: listTitleContent(),
                          ),
                          Expanded(
                            child: Obx(() {
                              return ReorderableListView.builder(
                                scrollController: controller.listScroll,
                                physics: const ClampingScrollPhysics(),
                                itemCount: controller.arrScript.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ColoredBox(
                                    key: Key('$index'),
                                    color: Colors.black,
                                    child: ContextMenuRegion(
                                      contextMenuBuilder: (BuildContext context, Offset offset) {
                                        // The custom context menu will look like the default context menu
                                        // on the current platform with a single 'Print' button.
                                        return AdaptiveTextSelectionToolbar.buttonItems(
                                          anchors: TextSelectionToolbarAnchors(
                                            primaryAnchor: offset,
                                          ),
                                          buttonItems: <ContextMenuButtonItem>[
                                            ContextMenuButtonItem(
                                              onPressed: () {
                                                ContextMenuController.removeAny();
                                              },
                                              label: 'View Chart',
                                            ),
                                            ContextMenuButtonItem(
                                              onPressed: () {
                                                ContextMenuController.removeAny();
                                                showMarketColumnPopUp();
                                              },
                                              label: 'Arrange Script',
                                            ),
                                            ContextMenuButtonItem(
                                              onPressed: () {
                                                ContextMenuController.removeAny();
                                                showFontChangePopup();
                                              },
                                              label: 'Set Script Font',
                                            ),
                                            ContextMenuButtonItem(
                                              onPressed: () {
                                                ContextMenuController.removeAny();
                                                controller.arrListTitleMarket.forEach((element) {
                                                  element.small = 60;
                                                  element.normal = 102;
                                                  element.big = 120;
                                                  element.large = 190;
                                                  element.smallLarge = 155;
                                                  element.extraLarge = 500;
                                                  element.smallUpdated = 60;
                                                  element.normalUpdated = 102;
                                                  element.bigUpdated = 120;
                                                  element.smallLargeUpdated = 155;
                                                  element.largeUpdated = 210;
                                                  element.extraLargeUpdated = 500;
                                                  element.start = null;
                                                  controller.maxWidth = controller.screenSize.width > 1410 ? controller.screenSize.width : 1410;
                                                });
                                                controller.update();
                                              },
                                              label: 'Fit to Size',
                                            ),
                                            ContextMenuButtonItem(
                                              onPressed: () {
                                                ContextMenuController.removeAny();
                                                controller.selectedScriptIndex = index;
                                                controller.selectedScript.value = controller.arrScript[controller.selectedScriptIndex];
                                                controller.isScripDetailOpen = true;

                                                showScriptInfoPopup();

                                                controller.update();
                                              },
                                              label: 'Script Info',
                                            ),
                                            // ContextMenuButtonItem(
                                            //   onPressed: () {
                                            //     ContextMenuController.removeAny();
                                            //     showMarketColumnPopUp();
                                            //   },
                                            //   label: 'Manage Columns',
                                            // ),
                                            ContextMenuButtonItem(
                                              onPressed: () {
                                                ContextMenuController.removeAny();
                                                controller.isGridActive = !controller.isGridActive;
                                                controller.update();
                                              },
                                              label: 'Grid',
                                            ),
                                            ContextMenuButtonItem(
                                              onPressed: () {
                                                ContextMenuController.removeAny();
                                                if (controller.selectedScriptIndex != -1) {
                                                  controller.selectedIndexforCut = controller.selectedScriptIndex;
                                                  controller.selectedIndexforUndo = controller.selectedScriptIndex;
                                                } else {
                                                  showWarningToast("Please selected script for cut");
                                                }
                                              },
                                              label: 'Cut    (Ctrl + x)',
                                            ),

                                            ContextMenuButtonItem(
                                              onPressed: () {
                                                ContextMenuController.removeAny();
                                                if (controller.selectedIndexforCut != -1) {
                                                  final ScriptData item = controller.arrScript.removeAt(controller.selectedIndexforCut);

                                                  controller.arrScript.insert(controller.selectedScriptIndex, item);

                                                  final ScriptData preItem = controller.arrPreScript.removeAt(controller.selectedIndexforCut);

                                                  controller.arrPreScript.insert(controller.selectedScriptIndex, preItem);

                                                  controller.selectedIndexforCut = -1;

                                                  controller.selectedIndexforPaste = controller.selectedScriptIndex;

                                                  controller.storeScripsInDB();
                                                }
                                              },
                                              label: 'Paste    (Ctr + v)',
                                            ),
                                            ContextMenuButtonItem(
                                              onPressed: () {
                                                ContextMenuController.removeAny();
                                                if (controller.selectedIndexforUndo != -1) {
                                                  final ScriptData item = controller.arrScript.removeAt(controller.selectedIndexforPaste);

                                                  controller.arrScript.insert(controller.selectedIndexforUndo, item);

                                                  final ScriptData preItem = controller.arrPreScript.removeAt(controller.selectedIndexforPaste);

                                                  controller.arrPreScript.insert(controller.selectedIndexforUndo, preItem);
                                                  controller.selectedIndexforCut = -1;
                                                  controller.selectedIndexforPaste = -1;
                                                  controller.selectedIndexforUndo = -1;

                                                  controller.storeScripsInDB();
                                                }
                                              },
                                              label: 'Undo    (ctrl + z)',
                                            ),

                                            ContextMenuButtonItem(
                                              onPressed: () {
                                                ContextMenuController.removeAny();
                                                if (controller.arrScript[index].symbol == "") {
                                                  controller.arrScript.removeAt(index);
                                                  controller.arrPreScript.removeAt(index);
                                                  controller.storeScripsInDB();
                                                  if (controller.selectedScriptIndex == index) {
                                                    if (controller.arrScript.isNotEmpty) {
                                                      controller.selectedScriptIndex = controller.selectedScriptIndex - 1;
                                                    } else {
                                                      controller.selectedScriptIndex = -1;
                                                    }
                                                  }
                                                } else {
                                                  var temp = controller.arrSymbol.firstWhereOrNull((element) => controller.arrScript[index].symbol == element.symbolName);

                                                  controller.deleteSymbolFromTab(temp!.userTabSymbolId!);
                                                }
                                              },
                                              label: 'Delete',
                                            ),
                                          ],
                                        );
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            height: 30,
                                            color: Colors.transparent,
                                            child: ReorderableDragStartListener(index: index, child: scriptContent(context, index)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                onReorder: (int oldIndex, int newIndex) {
                                  controller.isFilterClicked = 0;
                                  if (oldIndex < newIndex) {
                                    newIndex -= 1;
                                  }
                                  if (controller.selectedScriptIndex != -1) {
                                    controller.selectedScriptIndex = -1;
                                    controller.selectedScript.value = ScriptData();
                                    // controller.selectedScript.value = controller.arrScript[controller.selectedScriptIndex];
                                    controller.update();
                                  }
                                  final ScriptData item = controller.arrScript.removeAt(oldIndex);

                                  controller.arrScript.insert(newIndex, item);

                                  final ScriptData preItem = controller.arrPreScript.removeAt(oldIndex);

                                  controller.arrPreScript.insert(newIndex, preItem);
                                  controller.update();
                                  controller.storeScripsInDB();
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // if (controller.arrScript.isNotEmpty)
                Container(
                  height: 3.h,
                  color: AppColors().whiteColor,
                  child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      clipBehavior: Clip.hardEdge,
                      itemCount: controller.arrTabList.length,
                      scrollDirection: Axis.horizontal,
                      // shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return tablistContent(context, index);
                      }),
                ),
                // if (controller.isScripDetailOpen) showScriptDetailPopUp(),
                Container(
                  height: 2.h,
                  color: AppColors().headerBgColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        // final double animValue = Curves.easeInOut.transform(animation.value);

        return Material(
          color: AppColors().darkText,
          child: child,
        );
      },
      child: child,
    );
  }

  Widget tablistContent(BuildContext context, int index) {
    return GestureDetector(
      onTap: () async {
        controller.selectedTab = controller.arrTabList[index];
        controller.selectedPortfolio = index;
        controller.selectedScriptIndex = -1;
        controller.isScripDetailOpen = false;
        controller.update();
        controller.arrCurrentWatchListOrder.clear();
        controller.arrCurrentWatchListOrder.addAll(await controller.dbSerivice.readScripts((index + 1).toString()));
        controller.getSymbolListTabWise();
      },
      child: Container(
        width: 170,
        margin: const EdgeInsets.all(3),
        color: controller.selectedPortfolio == index ? AppColors().grayBg : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 30,
              // padding:
              //     EdgeInsets.only(right: 20, left: controller.selectedCurrentTab == controller.arrAvailableTabs[index] ? 5 : 20),
              child: Center(
                child: Text(controller.arrTabList[index].title ?? "",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: CustomFonts.family1Medium,
                      color: controller.selectedPortfolio == index ? AppColors().fontColor : AppColors().fontColor,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget scriptContent(BuildContext context, int index) {
    var scriptValue = controller.arrScript[index];

    return GestureDetector(
      key: Key('$index'),
      onTap: () {
        // controller.focusNode.requestFocus();
        ContextMenuController.removeAny();
        controller.selectedScriptIndex = index;
        controller.tempFocus.value.requestFocus();
        controller.selectedScript.value!.copyObject(scriptValue);
        controller.selectedScriptForF5.value!.copyObject(scriptValue);
        controller.selectedScriptForF5.value!.lut = DateTime.now();
        var indexOfSymbol = controller.arrSymbol.indexWhere((element) => controller.arrScript[index].symbol == element.symbolName);
        if (indexOfSymbol != -1) {
          controller.selectedSymbol = controller.arrSymbol[indexOfSymbol];
        }

        controller.update();
      },
      child: controller.arrScript[index].symbol!.isNotEmpty
          ? Container(
              decoration: BoxDecoration(
                  color: controller.arrScript[index].low! < controller.arrPreScript[index].low! || controller.arrScript[index].high! > controller.arrPreScript[index].high!
                      ? AppColors().pinkColor
                      : controller.selectedIndexforCut == index
                          ? AppColors().lightOnlyText
                          : Colors.transparent,
                  border: Border.all(width: 1, color: controller.selectedScriptIndex == index ? AppColors().whiteColor : Colors.transparent)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ScriptBox(-1, index: index, isImage: true),
                  SizedBox(
                    height: 30,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: controller.arrListTitleMarket.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int indexT) {
                        switch (controller.arrListTitleMarket[indexT].title) {
                          case 'EXCHANGE':
                            {
                              return controller.arrListTitleMarket[indexT].isSelected ? ScriptBox(indexT, isLeftAlign: true, title: scriptValue.exchange.toString(), index: index, textColor: AppColors().whiteColor) : const SizedBox();
                            }
                          case 'SYMBOL':
                            {
                              return controller.arrListTitleMarket[indexT].isSelected
                                  ? ScriptBox(indexT, isLeftAlign: true, title: scriptValue.name ?? "", bgColor: controller.arrScript[index].ch! < 0 ? AppColors().redColor : AppColors().blueColor, index: index, isBig: true, textColor: AppColors().whiteColor)
                                  : const SizedBox();
                            }
                          case 'EXPIRY':
                            {
                              return controller.arrListTitleMarket[indexT].isSelected
                                  ? ScriptBox(
                                      indexT,
                                      index: index,
                                      title: scriptValue.expiry == null ? "No Expiry" : shortDate(scriptValue.expiry!),
                                      textColor: AppColors().whiteColor,
                                    )
                                  : const SizedBox();
                            }
                          case 'BUY QTY':
                            {
                              return controller.arrListTitleMarket[indexT].isSelected
                                  ? ScriptBox(indexT,
                                      title: scriptValue.tbq.toString(),
                                      bgColor: controller.arrScript[index].tbq! < controller.arrPreScript[index].tbq!
                                          ? AppColors().redColor
                                          : controller.arrScript[index].tbq! != controller.arrPreScript[index].tbq!
                                              ? AppColors().blueColor
                                              : Colors.transparent,
                                      index: index,
                                      textColor: AppColors().whiteColor)
                                  : const SizedBox();
                            }
                          case 'BUY PRICE':
                            {
                              return controller.arrListTitleMarket[indexT].isSelected
                                  ? ScriptBox(indexT,
                                      title: scriptValue.bid.toString(),
                                      bgColor: controller.arrScript[index].ask! < controller.arrPreScript[index].ask!
                                          ? AppColors().redColor
                                          : controller.arrScript[index].ask! != controller.arrPreScript[index].ask!
                                              ? AppColors().blueColor
                                              : Colors.transparent,
                                      index: index,
                                      textColor: AppColors().whiteColor)
                                  : const SizedBox();
                            }
                          case 'SELL PRICE':
                            {
                              return controller.arrListTitleMarket[indexT].isSelected
                                  ? ScriptBox(indexT,
                                      title: scriptValue.ask.toString(),
                                      bgColor: controller.arrScript[index].bid! < controller.arrPreScript[index].bid!
                                          ? AppColors().redColor
                                          : controller.arrScript[index].bid! != controller.arrPreScript[index].bid!
                                              ? AppColors().blueColor
                                              : Colors.transparent,
                                      index: index,
                                      textColor: AppColors().whiteColor)
                                  : const SizedBox();
                            }
                          case 'SELL QTY':
                            {
                              return controller.arrListTitleMarket[indexT].isSelected
                                  ? ScriptBox(indexT,
                                      title: scriptValue.tsq.toString(),
                                      bgColor: controller.arrScript[index].tsq! < controller.arrPreScript[index].tsq!
                                          ? AppColors().redColor
                                          : controller.arrScript[index].tsq! != controller.arrPreScript[index].tsq!
                                              ? AppColors().blueColor
                                              : Colors.transparent,
                                      index: index,
                                      textColor: AppColors().whiteColor)
                                  : const SizedBox();
                            }
                          case 'LTP':
                            {
                              return controller.arrListTitleMarket[indexT].isSelected
                                  ? ScriptBox(indexT,
                                      title: scriptValue.ltp.toString(),
                                      bgColor: controller.arrScript[index].ltp! < controller.arrPreScript[index].ltp!
                                          ? AppColors().redColor
                                          : controller.arrScript[index].ltp! != controller.arrPreScript[index].ltp!
                                              ? AppColors().blueColor
                                              : Colors.transparent,
                                      index: index,
                                      textColor: AppColors().whiteColor)
                                  : const SizedBox();
                            }
                          case 'NET CHANGE':
                            {
                              return controller.arrListTitleMarket[indexT].isSelected
                                  ? ScriptBox(indexT,
                                      title: scriptValue.ch.toString(),
                                      isBig: true,
                                      bgColor: controller.arrScript[index].ch! < controller.arrPreScript[index].ch!
                                          ? AppColors().redColor
                                          : controller.arrScript[index].ch! != controller.arrPreScript[index].ch!
                                              ? AppColors().blueColor
                                              : Colors.transparent,
                                      index: index,
                                      textColor: AppColors().whiteColor)
                                  : const SizedBox();
                            }
                          case 'NET CHANGE %':
                            {
                              return controller.arrListTitleMarket[indexT].isSelected
                                  ? ScriptBox(indexT,
                                      title: scriptValue.chp.toString(),
                                      isBig: true,
                                      bgColor: controller.arrScript[index].chp! < controller.arrPreScript[index].chp!
                                          ? AppColors().redColor
                                          : controller.arrScript[index].chp! != controller.arrPreScript[index].chp!
                                              ? AppColors().blueColor
                                              : Colors.transparent,
                                      index: index,
                                      textColor: AppColors().whiteColor)
                                  : const SizedBox();
                            }
                          case 'OPEN':
                            {
                              return controller.arrListTitleMarket[indexT].isSelected ? ScriptBox(indexT, title: scriptValue.open.toString(), index: index, textColor: AppColors().whiteColor) : const SizedBox();
                            }
                          case 'HIGH':
                            {
                              return controller.arrListTitleMarket[indexT].isSelected ? ScriptBox(indexT, title: scriptValue.high.toString(), index: index, textColor: AppColors().whiteColor) : const SizedBox();
                            }
                          case 'LOW':
                            {
                              return controller.arrListTitleMarket[indexT].isSelected ? ScriptBox(indexT, title: scriptValue.low.toString(), index: index, textColor: AppColors().whiteColor) : const SizedBox();
                            }
                          case 'CLOSE':
                            {
                              return controller.arrListTitleMarket[indexT].isSelected ? ScriptBox(indexT, title: scriptValue.close.toString(), index: index, textColor: AppColors().whiteColor) : const SizedBox();
                            }
                          case 'STRIKE PRICE':
                            {
                              return controller.arrListTitleMarket[indexT].isSelected
                                  ? ScriptBox(indexT, title: scriptValue.strikePrice != 0 ? scriptValue.instrumentType! + " - " + scriptValue.strikePrice.toString() : "--", index: index, textColor: AppColors().whiteColor, isSmallLarge: true)
                                  : const SizedBox();
                            }
                          case 'LUT':
                            {
                              return controller.arrListTitleMarket[indexT].isSelected ? ScriptBox(indexT, title: scriptValue.lut != null ? shortFullDateTime(scriptValue.lut!) : "", index: index, textColor: AppColors().whiteColor, isSmallLarge: true) : const SizedBox();
                            }
                          default:
                            {
                              return const SizedBox();
                            }
                        }
                      },
                    ),
                  ),
                ],
              ))
          : Container(
              height: 30,
              width: 96.5.w,
              decoration: BoxDecoration(color: Colors.transparent, border: Border.all(width: 1, color: controller.selectedScriptIndex == index ? AppColors().whiteColor : Colors.transparent)),
            ),
    );
  }

  Widget listTitleContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          width: 30,
        ),
        ReorderableListView.builder(
          scrollDirection: Axis.horizontal,
          buildDefaultDragHandles: false,
          padding: EdgeInsets.zero,
          itemCount: controller.arrListTitleMarket.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            switch (controller.arrListTitleMarket[index].title) {
              case 'EXCHANGE':
                {
                  return controller.arrListTitleMarket[index].isSelected
                      ? titleBox("EXCHANGE", index)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'SYMBOL':
                {
                  return controller.arrListTitleMarket[index].isSelected
                      ? titleBox("SYMBOL", index, isBig: true, hasFilterIcon: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'EXPIRY':
                {
                  return controller.arrListTitleMarket[index].isSelected
                      ? titleBox("EXPIRY", index)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'BUY QTY':
                {
                  return controller.arrListTitleMarket[index].isSelected
                      ? titleBox("BUY QTY", index)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'BUY PRICE':
                {
                  return controller.arrListTitleMarket[index].isSelected
                      ? titleBox("BUY PRICE", index)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'SELL PRICE':
                {
                  return controller.arrListTitleMarket[index].isSelected
                      ? titleBox("SELL PRICE", index)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'SELL QTY':
                {
                  return controller.arrListTitleMarket[index].isSelected
                      ? titleBox("SELL QTY", index)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'LTP':
                {
                  return controller.arrListTitleMarket[index].isSelected
                      ? titleBox("LTP", index)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'NET CHANGE':
                {
                  return controller.arrListTitleMarket[index].isSelected
                      ? titleBox("NET CHANGE", index, isBig: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'NET CHANGE %':
                {
                  return controller.arrListTitleMarket[index].isSelected
                      ? titleBox("NET CHANGE %", index, isBig: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'OPEN':
                {
                  return controller.arrListTitleMarket[index].isSelected
                      ? titleBox("OPEN", index)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'HIGH':
                {
                  return controller.arrListTitleMarket[index].isSelected
                      ? titleBox("HIGH", index)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'LOW':
                {
                  return controller.arrListTitleMarket[index].isSelected
                      ? titleBox("LOW", index)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'CLOSE':
                {
                  return controller.arrListTitleMarket[index].isSelected
                      ? titleBox("CLOSE", index)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'STRIKE PRICE':
                {
                  return controller.arrListTitleMarket[index].isSelected
                      ? titleBox("STRIKE PRICE", index, isSmallLarge: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'LUT':
                {
                  return controller.arrListTitleMarket[index].isSelected
                      ? titleBox("LUT", index, isSmallLarge: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              default:
                {
                  return SizedBox(
                    key: Key('$index'),
                  );
                }
            }
          },
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            var temp = controller.arrListTitleMarket.removeAt(oldIndex);
            if (newIndex > controller.arrListTitleMarket.length) {
              newIndex = controller.arrListTitleMarket.length;
            }
            controller.arrListTitleMarket.insert(newIndex, temp);
            controller.update();
          },
        ),
      ],
    );
  }

  Widget ScriptBox(
    int titleIndex, {
    String title = "",
    Color? bgColor,
    Color? textColor,
    int? index,
    bool isLeftAlign = false,
    bool isBig = false,
    bool isLarge = false,
    bool isSmallLarge = false,
    bool isSmall = false,
    bool isExtraLarge = false,
    bool isImage = false,
    bool isFromBlank = false,
  }) {
    return isImage == false
        ? Container(
            width: setWidthDynamic(titleIndex, isBig: isBig, isSmall: isSmall, isLarge: isLarge, isExtraLarge: isExtraLarge, isSmallLarge: isSmallLarge) + 2,
            decoration: BoxDecoration(color: bgColor, border: controller.isGridActive ? Border(bottom: BorderSide(color: isFromBlank ? Colors.transparent : AppColors().darkText, width: 2)) : const Border(bottom: BorderSide(color: Colors.transparent, width: 2))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: setWidthDynamic(titleIndex, isBig: isBig, isSmall: isSmall, isLarge: isLarge, isExtraLarge: isExtraLarge, isSmallLarge: isSmallLarge) - 20,
                  child: Text(title,
                      textAlign: isLeftAlign ? TextAlign.start : TextAlign.end,
                      style: TextStyle(fontSize: controller.selectedFontSize, fontFamily: controller.selectedFontFamily, overflow: TextOverflow.ellipsis, color: textColor != null ? textColor : AppColors().darkText, decoration: TextDecoration.none)),
                ),
                const Spacer(),
                if (controller.isGridActive)
                  Container(
                    height: 3.h,
                    width: 2,
                    color: isFromBlank ? Colors.transparent : AppColors().darkText,
                  )
              ],
            ),
          )
        : Container(
            padding: const EdgeInsets.only(left: 5, right: 5),
            // width: 30,
            child: isFromBlank
                ? const SizedBox(
                    width: 25,
                    height: 25,
                  )
                : Image.asset(
                    controller.arrScript[index!].ch! < 0 ? AppImages.marketUpIcon : AppImages.marketDownIcon,
                    width: 20,
                    height: 20,
                  ),
          );
  }

  double setWidthDynamic(
    int index, {
    bool isBig = false,
    bool isSmall = false,
    bool isSmallLarge = false,
    bool isLarge = false,
    bool isExtraLarge = false,
  }) {
    var width = controller.arrListTitleMarket[index].normalUpdated;

    if (isBig) {
      width = controller.arrListTitleMarket[index].bigUpdated;
    } else if (isSmall) {
      width = controller.arrListTitleMarket[index].smallUpdated;
    } else if (isSmallLarge) {
      width = controller.arrListTitleMarket[index].smallLargeUpdated;
    } else if (isLarge) {
      width = controller.arrListTitleMarket[index].largeUpdated;
    } else if (isExtraLarge) {
      width = controller.arrListTitleMarket[index].extraLargeUpdated;
    }
    // if (controller.arrListTitleMarket[index].isSortingActive) {
    //   width += 3.h;
    // }

    return width;
  }

  Widget titleBox(
    String title,
    int index, {
    bool isBig = false,
    bool isSmall = false,
    bool isSmallLarge = false,
    bool isLarge = false,
    bool isExtraLarge = false,
    Function? onClickImage,
    bool isImage = false,
    String? strImage = "",
    bool hasFilterIcon = false,
  }) {
    return Row(
      key: Key('$index'),
      children: [
        ReorderableDragStartListener(
          enabled: true,
          index: index,
          child: isImage == false
              ? GestureDetector(
                  onTap: () {
                    if (controller.arrListTitleMarket[index].isSortingActive) {
                      controller.sortScript(controller.arrListTitleMarket[index].title);
                    } else {
                      controller.arrListTitleMarket.forEach((element) {
                        element.isSortingActive = false;
                        element.sortType = 0;
                      });

                      controller.arrListTitleMarket[index].isSortingActive = true;
                    }
                    controller.update();
                  },
                  child: Container(
                    color: controller.arrListTitleMarket[index].isSortingActive ? AppColors().blueColor.withOpacity(0.1) : AppColors().backgroundColor,
                    width: setWidthDynamic(index, isBig: isBig, isSmall: isSmall, isLarge: isLarge, isExtraLarge: isExtraLarge, isSmallLarge: isSmallLarge),
                    height: 3.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Text(title, style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1SemiBold, color: AppColors().fontColor)),
                        const Spacer(),
                        if (controller.arrListTitleMarket[index].isSortingActive)
                          Container(
                            height: 20,
                            width: 20,
                            padding: const EdgeInsets.all(0),
                            child: controller.arrListTitleMarket[index].sortType < 1 ? const Icon(Icons.arrow_drop_down) : const Icon(Icons.arrow_drop_up),
                          ),
                      ],
                    ),
                  ),
                )
              : GestureDetector(
                  key: Key(strImage!),
                  onTap: () {
                    if (onClickImage != null) {
                      onClickImage();
                    }
                  },
                  child: Container(
                    color: AppColors().backgroundColor,
                    height: 3.h,
                    padding: const EdgeInsets.only(left: 22, right: 22),
                    child: Image.asset(
                      strImage,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
        ),
        MouseRegion(
          cursor: SystemMouseCursors.resizeColumn,
          child: GestureDetector(
            onPanStart: (details) {
              controller.arrListTitleMarket[index].start = details.localPosition;
            },
            onPanEnd: (details) {
              controller.arrListTitleMarket[index].start = null;
              if (isBig) {
                controller.arrListTitleMarket[index].big = controller.arrListTitleMarket[index].bigUpdated;
              } else if (isSmall) {
                controller.arrListTitleMarket[index].small = controller.arrListTitleMarket[index].smallUpdated;
              } else if (isLarge) {
                controller.arrListTitleMarket[index].large = controller.arrListTitleMarket[index].largeUpdated;
              } else if (isExtraLarge) {
                controller.arrListTitleMarket[index].extraLarge = controller.arrListTitleMarket[index].extraLargeUpdated;
              } else {
                controller.arrListTitleMarket[index].normal = controller.arrListTitleMarket[index].normalUpdated;
              }
            },
            onPanUpdate: (details) {
              var diff = details.localPosition.dx - controller.arrListTitleMarket[index].start!.dx;
              if ((controller.maxWidth + diff) >= controller.screenSize.width) {
                controller.maxWidth = controller.screenSize.width + diff;
              }

              if (isBig) {
                if ((controller.arrListTitleMarket[index].big + diff) >= controller.arrListTitleMarket[index].bigOriginal) {
                  controller.arrListTitleMarket[index].bigUpdated = controller.arrListTitleMarket[index].big + diff;
                }
              } else if (isSmall) {
                if ((controller.arrListTitleMarket[index].small + diff) >= controller.arrListTitleMarket[index].smallOriginal) {
                  controller.arrListTitleMarket[index].smallUpdated = controller.arrListTitleMarket[index].small + diff;
                }
              } else if (isLarge) {
                if ((controller.arrListTitleMarket[index].large + diff) >= controller.arrListTitleMarket[index].largeOriginal) {
                  controller.arrListTitleMarket[index].largeUpdated = controller.arrListTitleMarket[index].large + diff;
                }
              } else if (isExtraLarge) {
                if ((controller.arrListTitleMarket[index].extraLarge + diff) >= controller.arrListTitleMarket[index].extraLargeOriginal) {
                  controller.arrListTitleMarket[index].extraLargeUpdated = controller.arrListTitleMarket[index].extraLarge + diff;
                }
              } else {
                if ((controller.arrListTitleMarket[index].normal + diff) >= controller.arrListTitleMarket[index].normalOriginal) {
                  controller.arrListTitleMarket[index].normalUpdated = controller.arrListTitleMarket[index].normal + diff;
                }
              }
              controller.update();
            },
            child: Container(
              height: 3.h,
              width: 2,
              color: AppColors().lightOnlyText,
            ),
          ),
        )
      ],
    );
  }

  Widget searchBox() {
    return Container(
      width: 200,
      // height: 4.h,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6.5),
      decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1), borderRadius: BorderRadius.circular(3)),
      child: Autocomplete<GlobalSymbolData>(
        displayStringForOption: (GlobalSymbolData option) => option.symbolTitle!,
        fieldViewBuilder: (BuildContext context, TextEditingController searchEditingController, FocusNode searchFocus, VoidCallback onFieldSubmitted) {
          return CustomTextField(
            type: 'Search',
            keyBoardType: TextInputType.text,
            isEnabled: true,
            isOptional: false,
            inValidMsg: "",
            placeHolderMsg: "Search",
            emptyFieldMsg: "",
            fontStyle: TextStyle(
              fontSize: 10,
              fontFamily: CustomFonts.family1Medium,
              color: AppColors().darkText,
            ),
            controller: searchEditingController,
            focus: searchFocus,
            focusBorderColor: AppColors().blueColor,
            isSecure: false,
            borderColor: AppColors().grayLightLine,
            keyboardButtonType: TextInputAction.search,
            maxLength: 64,
            prefixIcon: Image.asset(
              AppImages.searchIcon,
              height: 15,
              width: 15,
            ),
            onTap: () {
              searchFocus.requestFocus();
            },
            suffixIcon: Container(
              child: GestureDetector(
                onTap: () {
                  searchEditingController.clear();
                  controller.arrSearchedScript.clear();
                },
                child: Image.asset(
                  AppImages.crossIcon,
                  height: 20,
                  width: 20,
                ),
              ),
            ),
          );
        },
        optionsViewBuilder: (context, onSelected, options) => Align(
          alignment: Alignment.topLeft,
          child: Material(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.0)),
            ),
            child: Container(
              height: 250,
              width: 200, // <-- Right here !
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                shrinkWrap: false,
                itemBuilder: (BuildContext context, int index) {
                  final String option = controller.arrSearchedScript.elementAt(index).symbolTitle!;
                  return InkWell(
                    onTap: () => onSelected(controller.arrSearchedScript.elementAt(index)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: CustomFonts.family1Medium,
                          color: AppColors().darkText,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        optionsMaxHeight: 30.h,
        optionsBuilder: (TextEditingValue textEditingValue) async {
          if (textEditingValue.text == '') {
            return const Iterable<GlobalSymbolData>.empty();
          }
          return await controller.getSymbolListByKeyword(textEditingValue.text);
        },
        onSelected: (GlobalSymbolData selection) {
          debugPrint('You just selected $selection');
          controller.addSymbolToTab(selection.symbolId!);
        },
      ),
    );
  }
}
