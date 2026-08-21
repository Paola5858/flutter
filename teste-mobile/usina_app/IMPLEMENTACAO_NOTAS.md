# inventário inicial

## classes presentes no diagrama

- Usina: id, nome, localizacao; fromJson e toJson.
- Unidade: id, nome, usina; fromJson e toJson.
- Equipamento: id, nome, unidade; fromJson e toJson.
- Safra: id, nomeSafra, dataInicio, dataFim; diasRestantes, fromJson e toJson.
- UnidadeMedida: id, nome, simbolo; fromJson e toJson.
- TipoInformacao: id, nome, unidadeMedida; fromJson e toJson.
- Indicador: id, nome, descricao, url, tipoInformacao, metaValor, comparacaoIdeal; estados e filtros maiorMelhor, menorMelhor, faixaIdeal, dia, semana, mes, safra, dentroMeta, foraMeta, atencao; fromJson e toJson.
- Medicao: id, safra, equipamento, tipoInformacao, valor decimal, data, periodo; calcularStatus, calcularVariacao, fromJson e toJson.
- DashboardExtracao: safra, medicoes, indicadores; filtrarPorPeriodo, obterIndicadorPrincipal e calcularResumoStatus.

## relações

Usina possui unidades e safras. Unidade possui equipamentos. Equipamento registra medições. Medição usa safra e tipo de informação, e é classificada por status. Indicador referencia tipo de informação. Dashboard agrega medições e indicadores.

## estado atual

O app já possui `Indicador` simplificado com id, nome, valor, unidade e data, uma lista fixa em `main.dart`, `DashboardScreen` e `IndicadorCard`. A implementação deverá preservar a entrada atual ou migrá-la para o modelo completo sem quebrar o fluxo.

## direção visual

Interface em minúsculas naturais, fundo escuro ameixa/grafite, superfícies translúcidas com blur, bordas claras sutis, acentos rosa queimado, lavanda e coral, tipografia limpa, hierarquia editorial, cartões com indicadores, status e filtros de período.
