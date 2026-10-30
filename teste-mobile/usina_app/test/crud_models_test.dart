import 'package:flutter_test/flutter_test.dart';
import 'package:usina_app/models/crud_models.dart';
import 'package:usina_app/models/indicador.dart';

void main() {
  test('safra serializa datas no formato esperado pela api', () {
    final safra = Safra(
      nomeSafra: 'safra 2026/2027',
      dataInicio: DateTime(2026, 4, 1),
      dataFim: DateTime(2027, 3, 31),
    );

    expect(safra.toJson(), {
      'NomeSafra': 'safra 2026/2027',
      'DataInicio': '2026-04-01',
      'DataFim': '2027-03-31',
    });
  });

  test('medição preserva relacionamentos, valor e data em json', () {
    final medicao = Medicao(
      safraId: 1,
      equipamentoId: 2,
      tipoInformacaoId: 3,
      valor: 1250.5,
      data: DateTime(2026, 10, 28, 14, 30),
    );

    final json = medicao.toJson();
    expect(json['SafraId'], 1);
    expect(json['EquipamentoId'], 2);
    expect(json['TipoInformacaoId'], 3);
    expect(json['Valor'], 1250.5);
    expect(json['Data'], '2026-10-28T14:30:00.000');
  });

  test('indicador aceita contrato PascalCase e camelCase', () {
    final pascal = IndicadorRest.fromJson(const {
      'Id': 7,
      'Nome': 'produção',
      'Descricao': 'volume do turno',
      'Url': 'https://exemplo.com/bi',
    });
    final camel = IndicadorRest.fromJson(const {
      'id': 8,
      'nome': 'temperatura',
      'descricao': 'média da linha',
      'url': 'https://exemplo.com/temp',
    });

    expect(pascal.toJson()['Nome'], 'produção');
    expect(camel.id, 8);
  });
}
