// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class VistaControl extends StatefulWidget {
  const VistaControl({super.key});

  @override
  State<VistaControl> createState() => _VistaControlState();
}

class _VistaControlState extends State<VistaControl> {
  bool _visibleUp = false;
  bool _visibleDown = false;
  int pisoActual = 1;
  int pisoDestino = 1;

  void _compararpiso(int piso) {
    if (piso > pisoActual) {
      setState(() {
        _visibleUp = true;
        _visibleDown = false;
        pisoDestino = piso;
      });
    } else if (piso < pisoActual) {
      setState(() {
        _visibleUp = false;
        _visibleDown = true;
        pisoDestino = piso;
      });
    } else {
      setState(() {
        _visibleUp = false;
        _visibleDown = false;
        pisoDestino = piso;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              Text('Elevador UPC REDES E03',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              Text('Tutor: David Manotas',
                  style: TextStyle(
                    fontSize: 8.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  )),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              //Navigator.pushNamed(context, '/acerca');
            },
            splashColor: Colors.white,
          ),
        ],
        backgroundColor: Color.fromARGB(255, 89, 217, 217),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/fondo.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: Text(
                          'Control de elevador',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: 370.0,
                        height: 200.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/images/pantalla.png",
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: _visibleUp,
                                child: Image.asset(
                                  "assets/images/arrow_up.gif",
                                  width: 50,
                                  height: 120,
                                ),
                              ),
                              Text(
                                'Piso 1',
                                style: TextStyle(
                                  fontSize: 40.0,
                                  fontFamily: 'LCD',
                                  color: Colors.red[900],
                                ),
                              ),
                              Visibility(
                                visible: _visibleDown,
                                child: Image.asset(
                                  "assets/images/arrow_down.gif",
                                  width: 50,
                                  height: 120,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TecledoButton(
                    texto: '1',
                    modo: _compararpiso,
                  ),
                  TecledoButton(
                    texto: '2',
                    modo: _compararpiso,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TecledoButton(
                    texto: '3',
                    modo: _compararpiso,
                  ),
                  TecledoButton(
                    texto: '4',
                    modo: _compararpiso,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TecledoButton2(
                    modo: 1,
                  ),
                  TecledoButton(
                    texto: '0',
                    modo: _compararpiso,
                  ),
                  TecledoButton2(
                    modo: 2,
                  ),
                ],
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

class TecledoButton extends StatefulWidget {
  String texto;
  dynamic modo;
  TecledoButton({required this.texto, required this.modo, super.key});

  @override
  _TecledoButtonState createState() => _TecledoButtonState();
}

class _TecledoButtonState extends State<TecledoButton> {
  Color _buttonColor = const Color.fromARGB(168, 255, 255, 255);
  Color _textColor =
      const Color.fromARGB(255, 0, 0, 0); // Color inicial del botón
  bool _isButtonDisabled =
      false; // Para desactivar el botón mientras cambia de color

  void _changeColor() {
    setState(() {
      _buttonColor = const Color.fromARGB(255, 89, 217, 217);
      _textColor =
          const Color.fromARGB(255, 89, 217, 217); // Color al ser presionado
      _isButtonDisabled = true; // Desactiva el botón mientras cambia de color
      widget.modo(int.parse(widget.texto));
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _buttonColor = const Color.fromARGB(
              168, 255, 255, 255); // Color inicial después de 3 segundos
          _textColor = const Color.fromARGB(255, 0, 0, 0);
          _isButtonDisabled = false; // Vuelve a activar el botón
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isButtonDisabled ? null : _changeColor,
      child: Container(
          width: 100,
          height: 100,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            shape: BoxShape.circle,
            color: _buttonColor,
            //image:
          ),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(0, -3),
                    blurRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(0, 3),
                    blurRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(-3, 0),
                    blurRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(3, 0),
                    blurRadius: 2,
                  ),
                ],
                color: Colors.transparent),
            child: Center(
              child: Text(
                widget.texto,
                style: TextStyle(
                    color: _textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0),
              ),
            ),
          )),
    );
  }
}

class TecledoButton2 extends StatefulWidget {
  int modo;
  TecledoButton2({required this.modo, super.key});

  @override
  _TecledoButton2State createState() => _TecledoButton2State();
}

class _TecledoButton2State extends State<TecledoButton2> {
  Color _buttonColor = const Color.fromARGB(168, 255, 255, 255);
  Color _iconColor =
      const Color.fromARGB(255, 0, 0, 0); // Color inicial del botón
  bool _isButtonDisabled =
      false; // Para desactivar el botón mientras cambia de color

  void _changeColor() {
    setState(() {
      _buttonColor = const Color.fromARGB(255, 89, 217, 217);
      _iconColor =
          const Color.fromARGB(255, 89, 217, 217); // Color al ser presionado
      _isButtonDisabled = true; // Desactiva el botón mientras cambia de color

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _buttonColor = const Color.fromARGB(
              168, 255, 255, 255); // Color inicial después de 3 segundos
          _iconColor = const Color.fromARGB(255, 0, 0, 0);
          _isButtonDisabled = false; // Vuelve a activar el botón
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isButtonDisabled ? null : _changeColor,
      child: Container(
        width: 100,
        height: 100,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          shape: BoxShape.circle,
          color: _buttonColor,
          //image:
        ),
        child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(0, -3),
                    blurRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(0, 3),
                    blurRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(-3, 0),
                    blurRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(3, 0),
                    blurRadius: 2,
                  ),
                ],
                color: Colors.transparent),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: widget.modo == 1
                    ? [
                        Icon(Icons.arrow_right, color: _iconColor, size: 35),
                        Text("|",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _iconColor)),
                        Icon(Icons.arrow_left, color: _iconColor, size: 35)
                      ]
                    : [
                        Icon(Icons.arrow_left, color: _iconColor, size: 35),
                        Text("|",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _iconColor)),
                        Icon(Icons.arrow_right, color: _iconColor, size: 35)
                      ],
              ),
            )),
      ),
    );
  }
}
