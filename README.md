# Pratica 03 - Criacao e otimizacao de imagens Docker

Projeto desenvolvido para a disciplina **Praticas Integradas Full Cycle**. O repositorio reproduz as etapas do roteiro de pratica sobre Dockerfiles, imagens personalizadas, escolha de imagens-base e cache de camadas.

## Estrutura

- `ping-google-image`: imagem Ubuntu que instala `ping` e testa a conectividade com `google.com`.
- `python-pandas-image`: imagem Ubuntu 22.04 com Python 3.10, Pandas e um script que cria um DataFrame.
- `python-pandas-imagem-ideal`: a mesma aplicacao baseada diretamente em `python:3.10`.
- `docker-layering-test`: tres Dockerfiles usados para comparar cache, tempo e tamanho das imagens.
- `scripts/run-all.sh`: executa todas as construcoes, contêineres e medicoes.
- `.github/workflows/pratica-docker.yml`: executa a pratica automaticamente no GitHub Actions.

## Como executar

Requisitos: Docker em execucao e Bash.

```bash
chmod +x scripts/run-all.sh
bash scripts/run-all.sh
```

Os resultados ficam em `evidencias/`.

## Comandos individuais

### Acao 1

```bash
docker build -t ping-google ping-google-image
docker run --name ping-google-container ping-google
```

### Acao 2

```bash
docker build -t python-pandas python-pandas-image
docker run --name python-pandas-container python-pandas
```

### Acao 3

```bash
docker build -t python-pandas-ideal python-pandas-imagem-ideal
docker run --name python-pandas-ideal-container python-pandas-ideal
docker ps -a --filter ancestor=python-pandas-ideal
```

### Acao 5

```bash
docker build -t data-science-image -f docker-layering-test/Dockerfile.initial docker-layering-test
docker build -t data-science-image-extended -f docker-layering-test/Dockerfile.extended docker-layering-test
docker build -t data-science-image-rebuild -f docker-layering-test/Dockerfile.rebuild docker-layering-test
docker image ls data-science-image data-science-image-extended data-science-image-rebuild
```

## Observacao sobre a imagem Ubuntu com Python

O roteiro usa `ubuntu:latest` e solicita Python 3.10. Como a tag `latest` muda ao longo do tempo e nem sempre oferece essa versao nos repositorios padrao, o projeto fixa `ubuntu:22.04`, que fornece Python 3.10. Assim, a construcao permanece reproduzivel e atende ao objetivo da atividade.

