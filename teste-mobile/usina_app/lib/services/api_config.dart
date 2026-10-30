class ApiConfig {
  static const baseUrl = String.fromEnvironment(
    'USINA_API_BASE_URL',
    defaultValue: 'http://10.0.2.2:1880',
  );

  static const safras = '/api/safras';
  static const unidades = '/api/unidades';
  static const unidadesMedida = '/api/unidadesmedida';
  static const equipamentos = '/api/equipamentos';
  static const tiposInformacao = '/api/tipoinformacoes';
  static const medicoes = '/api/medicoes';
  static const indicadores = '/api/indicador';
}
