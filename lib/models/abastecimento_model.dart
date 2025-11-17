class Abastecimento {
  final String id;
  final String veiculoId;
  final DateTime data;
  final double quantidadeLitros;
  final double valorPago;
  final int quilometragem;
  final String tipoCombustivel;
  final double? consumo; // opcional
  final String? observacao;

  Abastecimento({
    required this.id,
    required this.veiculoId,
    required this.data,
    required this.quantidadeLitros,
    required this.valorPago,
    required this.quilometragem,
    required this.tipoCombustivel,
    this.consumo,
    this.observacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'veiculoId': veiculoId,
      'data': data.toIso8601String(),
      'quantidadeLitros': quantidadeLitros,
      'valorPago': valorPago,
      'quilometragem': quilometragem,
      'tipoCombustivel': tipoCombustivel,
      'consumo': consumo,
      'observacao': observacao,
    };
  }

  factory Abastecimento.fromFirestore(String id, Map<String, dynamic> data) {
    return Abastecimento(
      id: id,
      veiculoId: data['veiculoId'] ?? '',
      data: DateTime.parse(data['data'] as String),
      quantidadeLitros: (data['quantidadeLitros'] as num?)?.toDouble() ?? 0.0,
      valorPago: (data['valorPago'] as num?)?.toDouble() ?? 0.0,
      quilometragem: (data['quilometragem'] as num?)?.toInt() ?? 0,
      tipoCombustivel: data['tipoCombustivel'] ?? '',
      consumo: (data['consumo'] as num?)?.toDouble(),
      observacao: data['observacao'] as String?,
    );
  }
}
