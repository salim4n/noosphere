#!/usr/bin/env bash
# Inventaire local indicatif : aucun agent lance, aucune installation, aucun reseau.
set -euo pipefail

if [[ $# -gt 1 ]]; then
  printf 'Usage: bash scripts/doctor.sh [--help]\n' >&2
  exit 2
fi
case "${1-}" in
  --help|-h)
    printf '%s\n' 'Usage: bash scripts/doctor.sh [--help]' \
      'Inventaire local en lecture seule ; ne verifie ni auth, ni modeles, ni quotas.'
    exit 0
    ;;
  '') ;;
  *) printf 'Option inconnue. Utiliser --help.\n' >&2; exit 2 ;;
esac

printf '%s\n' 'Noosphere : inventaire local, sans appel fournisseur.'
printf 'Systeme: %s / %s\n' "$(uname -s)" "$(uname -m)"
if [[ "$EUID" -eq 0 ]]; then
  printf '%s\n' 'ATTENTION: utilisateur root ; ne pas lancer les workers avec ces droits.'
fi
if command -v getconf >/dev/null 2>&1; then
  cpu=$(getconf _NPROCESSORS_ONLN 2>/dev/null || true)
  printf 'CPU visibles: %s\n' "${cpu:-inconnu}"
fi
if [[ -r /proc/meminfo ]] && command -v awk >/dev/null 2>&1; then
  awk '/^(MemTotal|MemAvailable):/ {print $1, $2, $3}' /proc/meminfo
fi
if command -v df >/dev/null 2>&1 && command -v awk >/dev/null 2>&1; then
  df -Pk . | awk 'NR==2 {print "Disque disponible (KiB):", $4}'
fi
printf '\n%s\n' 'Detection dans le PATH (pas de lancement ni de verification de version):'
for tool in git gh jq rg node bun python3 uv herdr pi codex agent docker; do
  if command -v "$tool" >/dev/null 2>&1; then
    printf '  %-9s present\n' "$tool"
  else
    printf '  %-9s absent\n' "$tool"
  fi
done
printf '\n%s\n' 'Un executable present ne prouve ni sa version, ni son origine, ni son bon fonctionnement.' \
  'Les outils absents peuvent etre optionnels. Lire docs/bootstrap.md avant toute installation.'
