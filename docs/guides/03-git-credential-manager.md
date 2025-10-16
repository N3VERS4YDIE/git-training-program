# Sesión 3: Git Credential Manager (GCM)

Gestiona tokens y sesiones de forma segura para evitar prompts y trabajar detrás de proxys o SSO.

## Objetivos

- Instalar y configurar GCM en Linux/Windows/macOS.
- Iniciar sesión con GitHub/GitLab/Bitbucket.
- Manejar múltiples cuentas y almacenamiento seguro.

## Requisitos

- Git.
- Navegador para completar inicios de sesión.

## Instalación

- Linux

```bash
# Descarga el .deb/.rpm desde:
# https://github.com/git-ecosystem/git-credential-manager/releases
sudo dpkg -i ./gcmcore-linux_amd64.deb || sudo apt -f install -y
```

- Windows

```powershell
winget install --id GitHub.GitCredentialManagerCore -e
```

- macOS

```bash
brew tap git-ecosystem/git-credential-manager
brew install --cask git-credential-manager-core
```

## Activar como helper por defecto

```bash
git config --global credential.helper manager-core
```

En Windows, `manager` también es válido; ambos apuntan a GCM.

## Iniciar sesión y probar

```bash
git-credential-manager
# Sigue el flujo (OAuth/Device Code) en el navegador.
# Luego prueba contra un remoto (HTTPS):
git ls-remote https://github.com/ORG/REPO.git
```

## Múltiples cuentas

- Dominios distintos (p. ej., `github.com` vs `github.empresa.com`).
- Reautoriza cuando cambien permisos.
- Para limpiar credenciales:
  - Linux: SecretService/gnome-keyring.
  - Windows: Administrador de credenciales.
  - macOS: Llavero.

## Migrar desde helpers antiguos

```bash
git config --global --unset credential.helper || true
git config --global credential.helper manager-core
```

## Problemas comunes

- Reintentos de login: limpia credenciales del host específico.
- Proxy corporativo: exporta `HTTPS_PROXY`/`HTTP_PROXY` y configura GCM.
- WSL: instala GCM en Windows o dentro de WSL según prefieras.

---

Anterior: [Sesión 2: HTTPS vs SSH](./02-https-vs-ssh.md) | Siguiente: [Sesión 4: Claves SSH](./04-claves-ssh.md) | Volver al índice: [README](/README.md)
