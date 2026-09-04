# usina aurora

painel flutter para leitura de indicadores de extração agrícola, construído a partir do diagrama de classes do projeto.

## domínio

O projeto agora representa `Usina`, `Unidade`, `Equipamento`, `Safra`, `UnidadeMedida`, `TipoInformacao`, `Indicador`, `Medicao` e `DashboardExtracao`. Também estão explícitas as classes centrais de POO `Motor`, `Sensor`, `SensorDoMotor` e `RegistroDeEnvioDeDadosDosSensores`, conectando o equipamento à captura e ao envio das leituras.

Os modelos possuem serialização JSON onde prevista no diagrama. `Medicao` calcula status e variação, `Indicador` avalia sua meta e `DashboardExtracao` filtra períodos, obtém a medição principal e gera o resumo operacional.

## interface

A tela inicial usa fundo ameixa/grafite, superfícies translúcidas com blur, bordas sutis, acentos rosa queimado e lavanda, cartões de leitura, barra de progresso, status de meta e filtro por dia, semana, mês e safra. Todo o texto da interface segue a escrita em minúsculas pedida para o produto.

A atividade do menu principal foi integrada diretamente ao dashboard. O AppBar agora abre um drawer com estética natural em verde musgo, cabeçalho da usina, estado visual do item ativo e submenu expansível de cadastro com unidade, setor, equipamento, indicador, funcionário, tipo de medição e parâmetro. Os itens ainda não implementados exibem um feedback contextual, enquanto `indicador` abre a tela de cadastro real.

A tela `CadastroIndicadorPage` segue o mesmo sistema visual do produto e inclui preview em tempo real, campos para nome, descrição e url, contador de caracteres, validações específicas, exigência de conexão `https`, estado de salvamento, limpeza do formulário, mensagens de erro e retorno do objeto `Indicador` criado. Nesta etapa a sessão mantém o objeto em memória, sem banco ou API, conforme o manual.

## execução

Na raiz de `teste-mobile/usina_app`, execute:

```bash
flutter pub get
flutter run
```

A validação automática está em `test/widget_test.dart` e cobre a inicialização do dashboard com dados de demonstração.
