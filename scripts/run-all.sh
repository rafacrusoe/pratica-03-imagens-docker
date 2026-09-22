#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
evidence_dir="$repo_root/evidencias"
mkdir -p "$evidence_dir"

build_and_log() {
  local tag="$1"
  local dockerfile="$2"
  local context="$3"
  local timing_file="$4"

  /usr/bin/time -f "%e" -o "$timing_file" \
    docker build --progress=plain -t "$tag" -f "$dockerfile" "$context"
}

docker --version | tee "$evidence_dir/00-docker-version.txt"

docker rm -f \
  ping-google-container \
  python-pandas-container \
  python-pandas-ideal-container \
  data-science-container \
  >/dev/null 2>&1 || true

build_and_log \
  ping-google \
  "$repo_root/ping-google-image/Dockerfile" \
  "$repo_root/ping-google-image" \
  "$evidence_dir/tempo-ping-google.txt"

set +e
docker run --name ping-google-container ping-google 2>&1 \
  | tee "$evidence_dir/01-ping-google-execucao.txt"
ping_exit_code="${PIPESTATUS[0]}"
set -e
echo "codigo_saida_ping=$ping_exit_code" \
  | tee -a "$evidence_dir/01-ping-google-execucao.txt"

build_and_log \
  python-pandas \
  "$repo_root/python-pandas-image/Dockerfile" \
  "$repo_root/python-pandas-image" \
  "$evidence_dir/tempo-python-pandas.txt"

docker run --name python-pandas-container python-pandas \
  | tee "$evidence_dir/02-python-pandas-execucao.txt"

build_and_log \
  python-pandas-ideal \
  "$repo_root/python-pandas-imagem-ideal/Dockerfile" \
  "$repo_root/python-pandas-imagem-ideal" \
  "$evidence_dir/tempo-python-pandas-ideal.txt"

docker run --name python-pandas-ideal-container python-pandas-ideal \
  | tee "$evidence_dir/03-python-pandas-ideal-execucao.txt"

docker ps -a \
  --filter ancestor=python-pandas-ideal \
  --format 'table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}' \
  | tee "$evidence_dir/04-containers-imagem-ideal.txt"

build_and_log \
  data-science-image \
  "$repo_root/docker-layering-test/Dockerfile.initial" \
  "$repo_root/docker-layering-test" \
  "$evidence_dir/tempo-imagem-1.txt"

build_and_log \
  data-science-image-extended \
  "$repo_root/docker-layering-test/Dockerfile.extended" \
  "$repo_root/docker-layering-test" \
  "$evidence_dir/tempo-imagem-2.txt"

build_and_log \
  data-science-image-rebuild \
  "$repo_root/docker-layering-test/Dockerfile.rebuild" \
  "$repo_root/docker-layering-test" \
  "$evidence_dir/tempo-imagem-3.txt"

docker run --name data-science-container data-science-image-rebuild \
  | tee "$evidence_dir/05-data-science-execucao.txt"

{
  printf 'REPOSITORY\tTAG\tIMAGE ID\tSIZE\n'
  docker image ls \
    --format '{{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}' \
    | awk '$1 ~ /^data-science-image($|-extended$|-rebuild$)/'
} | tee "$evidence_dir/06-imagens-e-tamanhos.txt"

{
  echo "imagem_1_segundos=$(<"$evidence_dir/tempo-imagem-1.txt")"
  echo "imagem_2_segundos=$(<"$evidence_dir/tempo-imagem-2.txt")"
  echo "imagem_3_segundos=$(<"$evidence_dir/tempo-imagem-3.txt")"
} | tee "$evidence_dir/07-comparacao-tempos.txt"
