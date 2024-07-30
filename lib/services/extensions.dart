import 'package:flutter/material.dart';


extension CapExtension on String? {
  String get inCaps => isValid ? (this!.isNotEmpty ? '${this![0].toUpperCase()}${this!.substring(1)}' : '') : '';

  String get capitalizeFirstOfEach => isValid ? (this!.replaceAll(RegExp(' +'), ' ').split(" ").map((str) => str.inCaps).join(" ")) : '';

  bool get isValid => this != null && this!.isNotEmpty;

  bool get isNotValid => this == null || this!.isEmpty;

  bool get isEmail =>
      RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(this!);

  bool get isNotEmail =>
      !(RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(this!));

  String get initials {
    if (isValid) {
      var list = this!.trim().split(' ');
      if (list.length > 1) {
        return (list.first.isValid ? list.first[0] : '') + (list.last.isValid ? list.last[0] : '');
      } else {
        return this![0];
      }
      // return (this!.replaceAll(RegExp(' +'), ' ').split(" ").map((str) => str.inCaps).join(" "));
    } else {
      return '';
    }
  }

  String get getIfValid => isValid ? this! : '';

  String get removeAllWhitespace => isValid ? this!.replaceAll(' ', '') : this!;

  String get extension {
    String extension = isValid ? this!.split('/').last.split('.').last : '';
    if (extension.length > 5) {
      extension = 'jpg';
    }
    return extension;
  }

  String get url {
    if (isValid) {
      if (this!.startsWith('http') || this!.startsWith('https') || this!.startsWith('www.')) {
        return this!;
      } else {
        return 'https://$this';
      }
    }
    return '';
  }

  String get fileName {
    String extension = isValid ? this!.split('/').last : '';
    return extension;
  }
}

extension DateTimeExtensionNullable on DateTime? {
  bool get isNull {
    if (this == null) {
      return true;
    }
    return false;
  }

  bool get isNotNull {
    if (this != null) {
      return true;
    }
    return false;
  }
}


extension Sum<T> on List<T> {
  int get getSum {
    var sum = 0.0;
    for (var element in this) {
      sum += int.parse("$element");
    }
    return sum.toInt();
  }

  T? get getFirstIfNotEmpty {
    if (isNotEmpty) {
      return first;
    }
    return null;
  }

  String get getNamesPlus {
    if (length > 1) {
      return '${sublist(0, 1).map((e) => e).toString().replaceAll('(', '').replaceAll(')', '')}+ ${length - 1} more';
    }
    return map((e) => e).toString().replaceAll('(', '').replaceAll(')', '');
  }
}

extension ColorBrightness on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}

extension GetRequest on Map {
  String get convertGetResponseUrl {
    String url = '';
    for (int i = 0; i < keys.length; i++) {
      if (i == 0) {
        url += '?${keys.toList()[i]}=${this[keys.toList()[i]]}';
      } else {
        url += '&${keys.toList()[i]}=${this[keys.toList()[i]]}';
      }
    }
    return url;
  }
}
