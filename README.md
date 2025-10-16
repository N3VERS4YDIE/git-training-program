# Programa de capacitación de Git

Programa práctico para dominar Git desde fundamentos hasta trazabilidad y flujo de trabajo profesional.

## Cómo usar estas guías

- Orden recomendado: sigue las sesiones 1 → 8. Cada guía incluye “Anterior | Siguiente | Volver al índice”.
- Convenciones de comandos
  - Los comandos de Git son multiplataforma y se muestran en bloques `bash`.
  - Solo verás secciones separadas por SO cuando los comandos difieran realmente (instalación, servicios, portapapeles, rutas).
  - Orden de SO cuando aplica: Linux, Windows, macOS.
- Proveedores
  - Siempre que haya configuración específica, se cubren GitHub, GitLab y Bitbucket.

## Requisitos generales

- Git instalado y configurado (ver Guía 1 para instalación y configuración inicial).
- Acceso a al menos una plataforma remota (GitHub/GitLab/Bitbucket).
- Editor de texto (VS Code recomendado) y conexión a internet.

## Índice de guías

1. [Guía 1: Git básico](docs/guides/01-git-basico.md) — Fundamentos, instalación, configuración inicial, flujo mínimo y .gitignore.
2. [Guía 2: HTTPS vs SSH](docs/guides/02-https-vs-ssh.md) — Métodos de autenticación, helpers, cambio de URL de remoto y verificación.
3. [Guía 3: Git Credential Manager](docs/guides/03-git-credential-manager.md) — Instalación y uso de GCM con múltiples cuentas.
4. [Guía 4: Claves SSH](docs/guides/04-claves-ssh.md) — Generación ed25519, ssh-agent, registro en proveedores y alias.
5. [Guía 5: Firma GPG](docs/guides/05-firma-gpg.md) — GnuPG, firma automática de commits y tags, registro de claves.
6. [Guía 6: Ramas (CLI/GUI)](docs/guides/06-ramas-cli-gui.md) — Trabajo con ramas, merge/rebase y resolución de conflictos.
7. [Guía 7: Git Flow](docs/guides/07-git-flow.md) — Flujo con ramas por roles, releases y hotfixes, integración con PR/MR.
8. [Guía 8: Trazabilidad del código](docs/guides/08-trazabilidad.md) — log/blame/bisect, búsqueda histórica y auditoría.
