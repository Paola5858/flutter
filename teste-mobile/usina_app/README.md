# usina aurora

painel flutter para leitura de indicadores de extração agrícola, construído a partir do diagrama de classes do projeto.

## domínio

O projeto agora representa `Usina`, `Unidade`, `Equipamento`, `Safra`, `UnidadeMedida`, `TipoInformacao`, `Indicador`, `Medicao` e `DashboardExtracao`. Também estão explícitas as classes centrais de POO `Motor`, `Sensor`, `SensorDoMotor` e `RegistroDeEnvioDeDadosDosSensores`, conectando o equipamento à captura e ao envio das leituras.

Os modelos possuem serialização JSON onde prevista no diagrama. `Medicao` calcula status e variação, `Indicador` avalia sua meta e `DashboardExtracao` filtra períodos, obtém a medição principal e gera o resumo operacional.

## interface

A tela inicial usa fundo ameixa/grafite, superfícies translúcidas com blur, bordas sutis, acentos rosa queimado e lavanda, cartões de leitura, barra de progresso, status de meta e filtro por dia, semana, mês e safra. Todo o texto da interface segue a escrita em minúsculas pedida para o produto.

## execução

Na raiz de `teste-mobile/usina_app`, execute:

```bash
flutter pub get
flutter run
```

A validação automática está em `test/widget_test.dart` e cobre a inicialização do dashboard com dados de demonstração.
