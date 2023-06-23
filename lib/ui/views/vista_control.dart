import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netduino_upc_app/domain/controller/controllerPerfilUser.dart';
import 'package:netduino_upc_app/domain/controller/controllerUserFirebase.dart';
import 'package:audioplayers/audioplayers.dart';
// import 'package:wifi_scan/wifi_scan.dart';
// import 'package:network_info_plus/network_info_plus.dart';
import 'package:android_flutter_wifi/android_flutter_wifi.dart';
import 'package:permission_handler/permission_handler.dart';

class VistaControl extends StatefulWidget {
  const VistaControl({super.key});

  @override
  State<VistaControl> createState() => _VistaControlState();
}

class _VistaControlState extends State<VistaControl> {
  // VARIABLES DE AUDIO
  AudioPlayer audioPlayer = AudioPlayer();
  late PermissionStatus permissionLocation;
  // VARIABLES DE WIFI
  String _wifiName = 'Unknown';
  // final NetworkInfo _networkInfo = NetworkInfo();
  List<Map<String, dynamic>> _wifiNetworks = [];
  bool connectedToArduino = false;
  // VARIABLES DE ASCENSOR
  bool _isLoading = false;
  bool _isActive = false;
  bool _visbleUp = false;
  bool _visbleDown = false;
  int pisoActual = 1;
  String textoPantalla = "Piso 1";
  //CONTROLADORES
  ControlUserAuth controlua = Get.find();
  ControlUserPerfil controlPerfil = ControlUserPerfil();
  //late TextEditingController _montoInicialController;
  //Funciones
  void sonidoAscensorBajando() {
    // String audioPath = 'sounds/down.mp3';
    // audioPlayer.play(AssetSource(audioPath));
    String melodyPath = 'sounds/wait_floor_calabria.mp3';
    audioPlayer.play(AssetSource(melodyPath));
  }

  void accionBajar(int piso) {
    setState(() {
      if (pisoActual > piso) {
        _visbleUp = false;
        _visbleDown = true;
        pisoActual = pisoActual - 1;
      } else if (pisoActual == piso) {
        _visbleUp = false;
        _visbleDown = false;
        pisoActual = piso - 1;
        // Reproducir el audio
        String audioPath = 'sounds/elevatorDing.mp3';
        audioPlayer.play(AssetSource(audioPath));
      }
    });
    if (pisoActual == piso - 1) {
      pisoActual = piso;
    } else {
      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          textoPantalla = " Piso $pisoActual ";
          accionBajar(piso);
        });
      });
    }
  }

  void sonidoAscensorSubiendo() {
    // String audioPath = 'sounds/up.mp3';
    // audioPlayer.play(AssetSource(audioPath));
    String melodyPath = 'sounds/wait_floor_da_da.mp3';
    audioPlayer.play(AssetSource(melodyPath));
  }

  void accionSubir(int piso) {
    setState(() {
      if (pisoActual < piso) {
        _visbleUp = true;
        _visbleDown = false;
        //print(pisoActual);
        // print("Subiendo");
        pisoActual = pisoActual + 1;
        //print(pisoActual);
      } else if (pisoActual == piso) {
        //print("LLego al destino");
        _visbleUp = false;
        _visbleDown = false;
        pisoActual = piso + 1;
        String audioPath = 'sounds/elevatorDing.mp3';
        audioPlayer.play(AssetSource(audioPath));
      }
    });
    if (pisoActual == piso + 1) {
      //print("Fin de la accion");
      pisoActual = piso;
      //print(pisoActual);
      //pisoActual = piso-1;
    } else {
      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          textoPantalla = " Piso $pisoActual ";
          accionSubir(piso);
        });
      });
    }
  }

  void encurso() {
    String audioPath = 'sounds/elevatorClose.mp3';
    audioPlayer.play(AssetSource(audioPath));
  }

  void disponible() {
    String audioPath = 'sounds/elevatorDing.mp3';
    audioPlayer.play(AssetSource(audioPath));
  }

  void _compararpiso(int piso) {
    if (pisoActual > piso) {
      encurso();
      sonidoAscensorBajando();
      accionBajar(piso);
      //disponible();
    } else if (pisoActual < piso) {
      encurso();
      sonidoAscensorSubiendo();
      accionSubir(piso);
      //disponible();
    }
  }

  void obtenerWifiActual() async {
    print("llego al metodo");
    ActiveWifiNetwork activeWifiNetwork =
        await AndroidFlutterWifi.getActiveWifiInfo();
    _wifiName = activeWifiNetwork.ssid.toString();
    print('Este es el nombre de la red: $_wifiName');
    if (_wifiName.isEmpty || _wifiName == '<unknown ssid>') {
      _wifiName = 'No conectado';
    } else {
      setState(() {
        _wifiName = activeWifiNetwork.ssid.toString();
      });
    }
  }

  void escanearWifis() async {
    permissionLocation = await Permission.location.request();
    if (permissionLocation.isGranted) {
      List<WifiNetwork> wifiList = await AndroidFlutterWifi.getWifiScanResult();
      print('Estas son las redes: $wifiList');
      if (wifiList.isNotEmpty) {
        for (WifiNetwork wifiNetwork in wifiList) {
          Map<String, dynamic> networkData = {
            'Nombre: ': wifiNetwork.ssid,
            'Id de red: ': wifiNetwork.bssid,
            'Nivel de señal: ': wifiNetwork.signalLevel,
            'Frecuencia: ': wifiNetwork.frequency,
            'Seguridad: ': wifiNetwork.security,
            // Agrega más propiedades según tus necesidades
          };
          print('Estas son las redes: $networkData');
          _wifiNetworks.add(networkData);
        }
      }
    }
  }
  // void obtenerRedActual() async {
  //   String? wifiName;
  //   wifiName = await _networkInfo.getWifiName();
  //   setState(() {
  //     if (wifiName == null) {
  //       _wifiName = 'No conectado';
  //     } else {
  //       _wifiName = '$wifiName';
  //     }
  //   });
  // }

  // void scanWiFiNetworks() async {
  //   WiFiScan wifiScan = WiFiScan.instance;
  //   CanStartScan canStartScan = await wifiScan.canStartScan();
  //   if (canStartScan == CanStartScan.yes) {
  //     bool isSuccess = await wifiScan.startScan();
  //     if (isSuccess) {
  //       List<WiFiAccessPoint> scannedResults =
  //           await wifiScan.getScannedResults();
  //       // Utiliza la lista de resultados escaneados
  //       for (WiFiAccessPoint accessPoint in scannedResults) {
  //         print('SSID: ${accessPoint.ssid}');
  //         print('BSSID: ${accessPoint.bssid}');
  //         print('Signal Level: ${accessPoint.frequency}');
  //         print('------------------------');
  //         _wifiNetworks.add(
  //           {
  //             'Nombre: ': accessPoint.ssid,
  //             'id de red: ': accessPoint.bssid,
  //             'nivel de señal: ': accessPoint.frequency,
  //           },
  //         );
  //       }
  //     } else {
  //       print('El escaneo no se pudo iniciar.');
  //     }
  //   } else {
  //     print('No se pueden iniciar los escaneos de WiFi.');
  //   }
  // }

  void _encenderWifi() {
    setState(() {
      _isActive = !_isActive;
    });
    if (_isActive == true) {
      AndroidFlutterWifi.enableWifi();
      print('Wi-Fi encendido');
      _wifiNetworks.clear();
    } else {
      if (_isActive == false) {
        AndroidFlutterWifi.disableWifi();
        print('Wi-Fi apagado');
        _wifiNetworks.clear();
      }
    }
  }

  void inicializarEscaneo() async {
    await AndroidFlutterWifi.init();
  }

  @override
  void initState() {
    super.initState();
    inicializarEscaneo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 89, 217, 217),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    _isActive
                        ? Icons.wifi
                        : Icons
                            .wifi_off, // Utiliza el ícono correspondiente según el estado del Wi-Fi
                    size: 64,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  Text(
                    // '$wifiName'
                    'Modulo Wi-Fi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            10.0), // Ajusta el valor según tus necesidades
                        color: Color.fromARGB(255, 43, 40,
                            40), // Elige el color de fondo de tu Row
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 100,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _isActive ? 'Activado' : 'Desactivado',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Row(
                              children: [
                                Visibility(
                                  visible: _isLoading,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: SizedBox(
                                      width:
                                          12.0, // Cambia el tamaño según tus necesidades
                                      height:
                                          12.0, // Cambia el tamaño según tus necesidades
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(Colors
                                                .blue), // Cambia el color según tus necesidades
                                      ),
                                    ),
                                  ),
                                ),
                                Switch(
                                  value: _isActive,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _isLoading =
                                          true; // Mostrar el spinner de carga al cambiar el valor del switch
                                    });
                                    _encenderWifi();
                                    // Simular una espera de 5 segundos antes de ocultar el spinner de carga
                                    if (_isActive) {
                                      obtenerWifiActual();
                                      escanearWifis();
                                      // obtenerRedActual();
                                      // scanWiFiNetworks();
                                      Future.delayed(
                                        Duration(seconds: 5),
                                        () {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        },
                                      );
                                    } else {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: _isActive
                  ? Column(
                      children: [
                        _wifiName != 'No conectado' && _wifiName != 'Unknown'
                            ? Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Red Actual',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Red con conexion actual
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      children: [
                                        ExpansionTile(
                                          leading: Icon(Icons.wifi),
                                          title: Text('$_wifiName'),
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextButton(
                                                    child: Text(
                                                      'Olvidar red',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      // Lógica para olvidar la red
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Redes Disponibles',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Lista de redes disponibles
                            Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                children: [
                                  SingleChildScrollView(
                                    child: Container(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: _wifiNetworks.length,
                                        itemBuilder: (context, index) {
                                          var network = _wifiNetworks[index];
                                          return ListTile(
                                            leading: Icon(Icons.wifi),
                                            title: Text(network['Nombre: ']),
                                            subtitle: Text(
                                                'Intensidad: ${network['Nivel de señal: ']}'),
                                            trailing: ElevatedButton(
                                              onPressed: () {
                                                // Lógica para conectar a la red
                                              },
                                              child: Text(
                                                'Conectar',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(
                      padding: EdgeInsets.only(top: 50),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(Icons.help_outline, size: 64),
                          SizedBox(height: 8),
                          Text(
                            'Activa el Wi-Fi para ver las redes disponibles',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/images/NetduinoUPC_logo.png'),
          backgroundColor: Colors.black,
          radius: 20.0,
        ),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.settings),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ],
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
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 370.0,
                        height: 60.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/images/placa_banner.png",
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Text(
                          'Control de elevador',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[800],
                          ),
                          textAlign: TextAlign.center,
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
                                visible: _visbleUp,
                                child: Image.asset(
                                  "assets/images/arrow_up.gif",
                                  width: 50,
                                  height: 120,
                                ),
                              ),
                              Text(
                                textoPantalla,
                                style: TextStyle(
                                  fontSize: 50.0,
                                  fontFamily: 'LCD',
                                  color: Colors.red[900],
                                ),
                              ),
                              Visibility(
                                visible: _visbleDown,
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
          SizedBox(
            height: 20.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TecledoButton(
                    texto: '1',
                    modo: _compararpiso,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  TecledoButton(
                    texto: '2',
                    modo: _compararpiso,
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TecledoButton(
                    texto: '3',
                    modo: _compararpiso,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  TecledoButton(
                    texto: '4',
                    modo: _compararpiso,
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TecledoButton2(
                    modo: 1,
                    sound: encurso,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  TecledoButton(
                    texto: '0',
                    modo: _compararpiso,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  TecledoButton2(
                    modo: 2,
                    sound: disponible,
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
      widget.modo(int.parse(widget.texto)); // Llama a la función
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
  dynamic sound;
  TecledoButton2({required this.modo, required this.sound, super.key});

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
      widget.sound(); // Llama a la función
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
