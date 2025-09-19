import 'package:flutter/material.dart';

class Singleton {
  static Singleton? _instance;

  Singleton._internal() {
    _instance = this;
  }

  factory Singleton() => _instance ?? Singleton._internal();

  int tarjetas = 0;
  int paresHechos = 0;
  bool iniciarPar = false;
  Color colorParActual = Colors.black;
  int indexParActual = 0;
  bool bloquearClic = false;
}

