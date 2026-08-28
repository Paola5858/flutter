import 'package:flutter/material.dart';

enum TipoCampo { texto, numero, seleciona }

class CadastroCampo {
  final String rotulo;
  final TipoCampo tipo;
  final List<String> opcoes;
  final String dica;

  const CadastroCampo(
    this.rotulo,
    this.tipo, {
    this.opcoes = const [],
    this.dica = '',
  });
}

class CadastroConfig {
  final String titulo;
  final IconData icone;
  final String subtitulo;
  final List<CadastroCampo> campos;

  const CadastroConfig({
    required this.titulo,
    required this.icone,
    required this.subtitulo,
    required this.campos,
  });
}

const String usinaDemo = 'usina aurora';

const Map<String, CadastroConfig> cadastros = {
  'unidade': CadastroConfig(
    titulo: 'unidade',
    icone: Icons.account_tree_outlined,
    subtitulo: 'cadastre uma unidade de processamento da usina.',
    campos: [
      CadastroCampo('nome', TipoCampo.texto, dica: 'ex.: extração principal'),
      CadastroCampo('usina', TipoCampo.seleciona, opcoes: [usinaDemo]),
    ],
  ),
  'setor': CadastroConfig(
    titulo: 'setor',
    icone: Icons.view_quilt_outlined,
    subtitulo: 'organize a operação em setores de trabalho.',
    campos: [
      CadastroCampo('nome', TipoCampo.texto, dica: 'ex.: moagem'),
      CadastroCampo('unidade', TipoCampo.seleciona, opcoes: [usinaDemo]),
    ],
  ),
  'equipamento': CadastroConfig(
    titulo: 'equipamento',
    icone: Icons.precision_manufacturing_outlined,
    subtitulo: 'registre um equipamento monitorado.',
    campos: [
      CadastroCampo('nome', TipoCampo.texto, dica: 'ex.: linha de moagem 01'),
      CadastroCampo('unidade', TipoCampo.seleciona, opcoes: [usinaDemo]),
    ],
  ),
  'indicador': CadastroConfig(
    titulo: 'indicador',
    icone: Icons.insights_rounded,
    subtitulo: 'defina um indicador de desempenho.',
    campos: [
      CadastroCampo('nome', TipoCampo.texto, dica: 'ex.: produção de açúcar'),
      CadastroCampo('descrição', TipoCampo.texto, dica: 'breve descrição do que mede'),
      CadastroCampo('tipo de informação', TipoCampo.seleciona, opcoes: ['produção de açúcar', 'temperatura', 'umidade']),
      CadastroCampo('meta (valor)', TipoCampo.numero),
      CadastroCampo('comparação ideal', TipoCampo.seleciona, opcoes: ['maior é melhor', 'menor é melhor', 'faixa ideal']),
    ],
  ),
  'funcionário': CadastroConfig(
    titulo: 'funcionário',
    icone: Icons.badge_outlined,
    subtitulo: 'cadastre um membro da equipe.',
    campos: [
      CadastroCampo('nome', TipoCampo.texto, dica: 'ex.: maria silva'),
      CadastroCampo('cargo', TipoCampo.texto, dica: 'ex.: operadora de moagem'),
      CadastroCampo('unidade', TipoCampo.seleciona, opcoes: [usinaDemo]),
    ],
  ),
  'tipo de medição': CadastroConfig(
    titulo: 'tipo de medição',
    icone: Icons.tune_rounded,
    subtitulo: 'crie um tipo de medição e sua unidade.',
    campos: [
      CadastroCampo('nome', TipoCampo.texto, dica: 'ex.: umidade'),
      CadastroCampo('símbolo da unidade', TipoCampo.texto, dica: 'ex.: %'),
    ],
  ),
  'parâmetro': CadastroConfig(
    titulo: 'parâmetro',
    icone: Icons.settings_suggest_outlined,
    subtitulo: 'configure um parâmetro de referência.',
    campos: [
      CadastroCampo('nome', TipoCampo.texto, dica: 'ex.: pressão ideal'),
      CadastroCampo('valor de referência', TipoCampo.numero),
      CadastroCampo('unidade', TipoCampo.seleciona, opcoes: ['t', '°c', '%']),
    ],
  ),
};
