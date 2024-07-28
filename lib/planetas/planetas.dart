class Planetas {
  int? id;
  String? nombre;
  double? distanciaSol;
  double? radio;

  Planetas(this.id, this.nombre, this.distanciaSol, this.radio);

  // Crea un objeto a partir de un Json
  Planetas.delMapa(Map<String, dynamic> mapa) {
    id = mapa["id"];
    nombre = mapa["nombre"];
    distanciaSol = mapa["distanciaSol"];
    radio = mapa["radio"];
  }

  // El Mapeador sirve para convertir un objeto a mapa
  Map<String, dynamic> mapeador() {
    return {
      "id": id,
      "nombre": nombre,
      "distanciaSol": distanciaSol,
      "radio": radio
    };
  }
}
