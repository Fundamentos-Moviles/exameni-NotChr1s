import 'dart:math';
import 'package:examen_1/utils/singletton.dart';
import 'package:flutter/material.dart';
import 'constantes.dart' as cons;

//DE LA CRUZ MENDOZA ISRAEL 356756

class Carta {
  Color color;
  bool estado;
  bool encontrado;
  Carta({required this.color, this.estado = false, this.encontrado =false});
}

class Memorama extends StatefulWidget {
  const Memorama({super.key});

  @override
  State<Memorama> createState() => _MemoramaState();
}

class _MemoramaState extends State<Memorama> {
  List<Carta> cartas = [];
  Singleton singleton = Singleton();
  bool juegoFinalizado = false;

  final int columnas = 4;
  final int filas = 5;


  @override
  void initState() {
    super.initState();
    initializeCards();
  }

  void initializeCards() {
    singleton.tarjetas=filas*columnas;
    List<Color> colores = generateColors((singleton.tarjetas/2) as int);
    cartas = colores.map((color) => Carta(color: color)).toList();
  }

  void reiniciarJuego() {
    setState(() {
      singleton.iniciarPar = false;
      singleton.paresHechos = 0;
      initializeCards();
      singleton.bloquearClic= false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('De La Cruz Mendoza Israel | MEMORAMA'),
        actions: [
          TextButton(onPressed: (){
            setState(() {
              juegoFinalizado = false;
              reiniciarJuego();
            });
          },
              child: const Text('Reiniciar Juego'))
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnas,
                childAspectRatio: 1.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: cartas.length,
              itemBuilder: (context, index) {
                final card = cartas[index];
                return InkWell(
                  onTap: card.encontrado  || singleton.bloquearClic ? null : () {
                    setState(() {
                      if(singleton.iniciarPar == false){
                        singleton.iniciarPar = true;
                        singleton.colorParActual = card.color;
                        singleton.indexParActual = index;
                        card.encontrado = true;
                      }else{
                        if(singleton.colorParActual == card.color){
                          card.encontrado = true;
                          singleton.iniciarPar = false;
                          singleton.paresHechos = singleton.paresHechos + 1;
                          print(singleton.paresHechos);
                          if(singleton.paresHechos == (singleton.tarjetas/2)){
                            juegoFinalizado = true;
                          }
                        }else{
                          singleton.bloquearClic = true;
                          Future.delayed(Duration(seconds: 1), () {
                            setState(() {
                              card.estado = !card.estado;
                              cartas[singleton.indexParActual].estado = !cartas[singleton.indexParActual].estado;
                              cartas[singleton.indexParActual].encontrado = !cartas[singleton.indexParActual].encontrado;
                              singleton.bloquearClic = false;
                            });
                          });
                          singleton.iniciarPar = false;
                        }
                      }
                      card.estado = !card.estado;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: card.estado ? card.color : cons.gris,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),
          ),

         if(juegoFinalizado)(
            Container(
              color: cons.fondo,
              alignment: Alignment.center,
              child: AlertDialog(
                title: const Text('JUEGO FINALIZADO', textAlign: TextAlign.center),
                content: const Text('HAZ ENCONTRADO TODOS LOS PARES', textAlign: TextAlign.center),
                actions: [
                  TextButton(onPressed: (){
                    setState(() {
                      juegoFinalizado = false;
                      reiniciarJuego();
                    });
                  },
                      child: const Text('Jugar de Nuevo'))
                ],
              ),
            )
         ),
        ],
      ),
    );
  }

  Color randomColor() {
    final Random random = Random();
    return Color(0xFF000000 + random.nextInt(0xFFFFFF));
  }

  List<Color> generateColors(int pairs) {
    List<Color> Colores = List.generate(pairs, (index) => randomColor());

    List<Color> coloresPares = [];
    for (var color in Colores) {
      coloresPares.add(color);
      coloresPares.add(color);
    }

    coloresPares.shuffle();
    return coloresPares;
  }
}