# usina aurora

painel flutter para leitura de indicadores de extração agrícola, construído a partir do diagrama de classes do projeto.

## domínio

O projeto agora representa `Usina`, `Unidade`, `Equipamento`, `Safra`, `UnidadeMedida`, `TipoInformacao`, `Indicador`, `Medicao` e `DashboardExtracao`. Também estão explícitas as classes centrais de POO `Motor`, `Sensor`, `SensorDoMotor` e `RegistroDeEnvioDeDadosDosSensores`, conectando o equipamento à captura e ao envio das leituras.

Os modelos possuem serialização JSON onde prevista no diagrama. `Medicao` calcula status e variação, `Indicador` avalia sua meta e `DashboardExtracao` filtra períodos, obtém a medição principal e gera o resumo operacional.

## interface

A tela inicial usa fundo grafite, superfícies translúcidas com blur, bordas sutis, acentos verde musgo, cartões de leitura, barra de progresso, status de meta e filtro por dia, semana, mês e safra. Todo o texto da interface segue a escrita em minúsculas pedida para o produto.

A atividade do menu principal foi integrada diretamente ao dashboard. O AppBar agora abre um drawer com estética natural em verde musgo, cabeçalho da usina, estado visual do item ativo e submenu expansível de cadastro com unidade, setor, equipamento, indicador, usuário, tipo de medição e parâmetro. Os itens ainda não implementados exibem um feedback contextual, enquanto `indicador` e `usuário` abrem telas de cadastro reais.

A tela `CadastroIndicadorPage` segue o mesmo sistema visual do produto e inclui preview em tempo real, campos para nome, descrição e url, contador de caracteres, validações específicas, exigência de conexão `https`, estado de salvamento, limpeza do formulário, mensagens de erro e retorno do objeto `Indicador` criado. Nesta etapa a sessão mantém o objeto em memória, sem banco ou API, conforme o manual.

A tela `CadastroUsuarioPage` adiciona nome, e-mail, senha e foto de perfil. A imagem pode vir da galeria ou ser capturada pela câmera por meio do pacote `image_picker`. O fluxo inclui bottom sheet de escolha da origem, preview circular, troca e remoção da foto, recuperação de seleção interrompida no Android, mensagens para permissões indisponíveis, validação de credenciais e retorno do objeto `Usuario`. O iOS recebeu as descrições de uso de câmera e biblioteca de fotos no `Info.plist`.

O fluxo de acesso agora começa em `LoginPage`, com credencial didática `aluno@usina.com` e senha `123456`. A sessão é persistida com `shared_preferences`, sem salvar a senha, e restaurada automaticamente ao reabrir o aplicativo. No momento do login, `geolocator` tenta capturar latitude e longitude, mas gps desligado, permissão recusada ou posição indisponível não impedem a entrada. O drawer mostra e-mail, data do acesso, estado das coordenadas e oferece logout, que limpa os dados da sessão.

O item `dashboard power bi` abre `PowerBiScreen` em uma WebView com o relatório fornecido. A tela possui barra de progresso, atualização manual, tratamento de erro e bloqueio de navegação para domínios fora do fluxo autorizado do Power BI/Microsoft e do portal educacional identificado pelo próprio link. O relatório não foi publicado na web e nenhum token foi colocado no aplicativo. Como o endpoint redireciona para o login educacional, cada usuário ainda precisa ter uma conta autorizada no Power BI/portal; a sessão do login didático da usina não substitui a autenticação Microsoft.

Os seis CRUDs da atividade foram estruturados em `CrudPage`, `CrudEditorPage`, `CrudService` e `crud_models.dart`. O fluxo inclui GET, POST, PUT e DELETE para safra, unidade, unidade de medida, equipamento, tipo de informação e medição. Há busca local na listagem, estados de carregamento, erro, lista vazia, atualização por gesto, confirmação antes da exclusão e feedback de sucesso ou falha. Equipamento, tipo de informação e medição carregam suas chaves estrangeiras por dropdown antes de permitir o envio.

Indicadores agora possuem gerenciamento REST próprio em `IndicadoresPage`, com criação, edição, exclusão confirmada, busca, atualização e abertura da fonte em `IndicadorWebView`. O DTO aceita respostas PascalCase ou camelCase e envia `Nome`, `Descricao` e `Url`. A rota padrão é `/api/indicador`, combinada com a base `http://10.0.2.2:1880`; ela pode ser substituída por `USINA_INDICADORES_ROUTE` caso o Node-RED use outro caminho. A URL do indicador aceita HTTP ou HTTPS com host válido, mas a WebView restringe a navegação ao host informado.

A API é configurável por `--dart-define=USINA_API_BASE_URL=...`; por padrão, o Android Emulator usa `http://10.0.2.2:1880`. O projeto mantém `http://` apenas para o laboratório Node-RED, com `usesCleartextTraffic` delimitado ao build didático. Em apresentação externa ou produção, substitua por HTTPS e remova essa exceção. Nenhum endpoint foi tratado como confirmado além das rotas descritas no manual, e a mensagem da API é preservada quando o servidor retorna erro.

## execução

Na raiz de `teste-mobile/usina_app`, execute:

```bash
flutter pub get
flutter run
```

A validação automática está em `test/widget_test.dart` e cobre a inicialização do dashboard com dados de demonstração. No dispositivo, o sistema exibirá as permissões de localização conforme as descrições configuradas no Android Manifest e no `Info.plist`.
