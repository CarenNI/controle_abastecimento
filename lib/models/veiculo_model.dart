class Veiculo {
  final String id; // ID do documento no Firestore
  final String modelo;
  final String marca;
  final String placa;
  final int ano;
  final String tipoCombustivel;

  Veiculo({
    required this.id,
    required this.modelo,
    required this.marca,
    required this.placa,
    required this.ano,
    required this.tipoCombustivel,
  });

  // Para criar um veículo novo SEM ID ainda (o Firestore gera o ID)
  factory Veiculo.novo({
    required String modelo,
    required String marca,
    required String placa,
    required int ano,
    required String tipoCombustivel,
  }) {
    return Veiculo(
      id: '',
      modelo: modelo,
      marca: marca,
      placa: placa,
      ano: ano,
      tipoCombustivel: tipoCombustivel,
    );
  }

  // Converter para Map (para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'modelo': modelo,
      'marca': marca,
      'placa': placa,
      'ano': ano,
      'tipoCombustivel': tipoCombustivel,
    };
  }

  // Criar Veiculo a partir de um documento do Firestore
  factory Veiculo.fromFirestore(String id, Map<String, dynamic> data) {
    return Veiculo(
      id: id,
      modelo: data['modelo'] ?? '',
      marca: data['marca'] ?? '',
      placa: data['placa'] ?? '',
      ano: (data['ano'] ?? 0) as int,
      tipoCombustivel: data['tipoCombustivel'] ?? '',
    );
  }
}
