import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RemoteControlActions {
  // 定义 shortcuts
  static final Map<LogicalKeySet, Intent> shortcuts = {
    LogicalKeySet(LogicalKeyboardKey.arrowUp): MoveUpIntent(),
    LogicalKeySet(LogicalKeyboardKey.arrowDown): MoveDownIntent(),
    LogicalKeySet(LogicalKeyboardKey.arrowLeft): MoveLeftIntent(),
    LogicalKeySet(LogicalKeyboardKey.arrowRight): MoveRightIntent(),
    LogicalKeySet(LogicalKeyboardKey.enter): ConfirmIntent(),
    LogicalKeySet(LogicalKeyboardKey.escape): BackIntent(),
  };

  // 定义 actions
  static Map<Type, Action<Intent>> createActions({
    required void Function(String direction) handleDirection,
    required void Function(String action) handleAction,
  }) {
    return {
      MoveUpIntent: CallbackAction<MoveUpIntent>(
        onInvoke: (_) => handleDirection('up'),
      ),
      MoveDownIntent: CallbackAction<MoveDownIntent>(
        onInvoke: (_) => handleDirection('down'),
      ),
      MoveLeftIntent: CallbackAction<MoveLeftIntent>(
        onInvoke: (_) => handleDirection('left'),
      ),
      MoveRightIntent: CallbackAction<MoveRightIntent>(
        onInvoke: (_) => handleDirection('right'),
      ),
      ConfirmIntent: CallbackAction<ConfirmIntent>(
        onInvoke: (_) => handleAction('confirm'),
      ),
      BackIntent: CallbackAction<BackIntent>(
        onInvoke: (_) => handleAction('back'),
      ),
    };
  }
}
// 自定义 Intent 类
class MoveUpIntent extends Intent {}

class MoveDownIntent extends Intent {}

class MoveLeftIntent extends Intent {}

class MoveRightIntent extends Intent {}

class OpenLeftDrawerIntent extends Intent {}

class OpenRightDrawerIntent extends Intent {}

class ConfirmIntent extends Intent {}

class BackIntent extends Intent {}