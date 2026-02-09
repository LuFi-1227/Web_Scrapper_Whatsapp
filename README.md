# Documentação do projeto
- Este projeto trata-se de um robôzinho que funciona através de n8n para fazer um scrapping de notícias no Whatsapp. Atualmente, o robôzinho está habilitado a fazer Scrapping de notícias acerca das eleições de 2026 ou da copa do mundo de 2026, podendo ser alterado para pesquisar outros assuntos.

## Sumário:
- [Arquivos do projeto](#arquivos-do-projeto)
- [Requisitos para rodar o projeto](#requisitos-para-rodar-o-projeto)
- [Como subir o projeto](#como-subir-o-projeto)
- [Requisitos de credenciais no n8n](#requisitos-de-credenciais-no-n8n)
  - [Credenciais do postgreSQL](#credenciais-do-postgresql)
  - [Credenciais do Redis](#credenciais-do-redis)
- [API do Scrapper python](#api-do-scrapper-python)
  - [Rotas](#rotas)

## Arquivos do projeto:
- Este projeto conta com a seguinte estrutura de arquivos:
```bash
    ├─── Agente #-> Pasta usada pelo docker para armazenar arquivos do n8n (Não mexer).
    │   ├───binaryData
    │   └───nodes
    ├─── Scrapper #-> Pasta com os arquivos para subir a API usada pelo agente para fazer um scrapping no duckduckgo (Opção gratuita).
    │    ├───requirements.txt #-> Arquivo contendo as libs utilizadas pelo python para subir a API feita com Flask.
    │    └───scrapper.py #-> Script utilizado pela API para buscar notícias, possui só uma rota GET descrita mais adiante.
    ├───.env #-> Arquivo de configuração de ambiente usado pelo docker (Não mexer se não souber o que está fazendo).
    ├───docker-compose.yml #-> Arquivo contendo as especificações de containers necessários para rodar o projeto.
    ├───init.sql #-> Arquivo de inícialização do banco de dados em PostGreeSQL.
    └───Pesquisador de Notícias.json #-> Arquivo contendo os dados para serem importados em WorkFlow do n8n com a lógica de programação do robô.
```

## Requisitos para rodar o projeto:
- Para rodar este projeto, você precisa ter no seu computador os seguintes componentes:
  - Docker -> Para subir os containers;
  - Paciência -> Caso o seu computador não possua poder computacional o suficiente;
    
## Como subir o projeto:
- Com o docker instalado, suba o projeto com o seguinte comando:
```bash
docker compose up -d
```
- Após a finalização de upload dos containers, você terá no ar as seguintes aplicações:
  -  *n8n* -> http://localhost:5678/
  -  *python* -> http://localhost:8000/
  -  *postgres* -> http://localhost:5432/
  -  *Evolution API* -> http://localhost:8080/manager
  -  *redis* -> http://localhost:6380/
  -  *Adminer* -> http://localhost:8081/
- Entre no container de n8n através de ```http://localhost:5678/```, faça login usando suas credenciais (crie uma conta), crie um novo workflow e importe o arquivo ```Pesquisador de Notícias.json````e então configure o workflow de acordo com as credenciais da próxima seção.

## Requisitos de credenciais no n8n:
### Credenciais do postgreSQL:
- User: *user*;
- Password: *senha*;
- Host: *postgres*; (Escreva o nome para o docker resolver o link)
- Port: *5432*;
- Database: *zap_scrapper_db*;
  
### Credenciais do Redis:
- User: *blank*;
- Password: *blank*;
- Host: *redis*; (Escreva o nome para o docker resolver o link)
- Port: *6379*;

## API do Scrapper python:
- Esta API usa o DuckDuckGo como fonte para fazer pesquisas de forma gratuita, contando com funções auxiliares para extração de dados de páginas.
### Rotas:
- ```GET http://localhost:8000/```
  - *Parâmetros*:
    - *query* -> Palavras chave da pesquisa;
    - *number_of_results* -> Número de notícias a serem pesquisadas;
  - *Uso*:
    - ```GET http://localhost:8000/?query="Copa do mundo 2026"&number_of_results=3```
      - Retorna um json com 3 notícias sobre o assunto "Copa do mundo".
